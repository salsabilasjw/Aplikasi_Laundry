#include "OrderManager.h"

OrderManager::OrderManager(QObject *parent)
    : QObject(parent), m_orderCounter(0)
{
}

double OrderManager::getPricePerKg(const QString &serviceType) const
{
    if (serviceType == "Regular") return 10000.0;
    if (serviceType == "Express") return 15000.0;
    return 10000.0;
}

void OrderManager::addOrder(const QString &customerName, double weight, const QString &serviceType)
{
    m_orderCounter++;
    QString orderId = QString("%1").arg(m_orderCounter, 3, 10, QChar('0'));

    double pricePerKg = getPricePerKg(serviceType);
    double totalPrice = weight * pricePerKg;

    QVariantMap order;
    order["id"] = orderId;
    order["customerName"] = customerName;
    order["weight"] = weight;
    order["serviceType"] = serviceType;
    order["totalPrice"] = totalPrice;
    order["status"] = "Processing";
    order["createdAt"] = QDateTime::currentDateTime().toString("dd MMMM yyyy, HH:mm:ss");

    m_orders.append(order);
    emit ordersChanged();
    emit orderAdded("Order added successfully!");
}

void OrderManager::updateOrderStatus(const QString &orderId, const QString &status)
{
    for (int i = 0; i < m_orders.count(); ++i) {
        QVariantMap order = m_orders[i].toMap();
        if (order["id"].toString() == orderId) {
            order["status"] = status;
            m_orders[i] = order;
            emit ordersChanged();
            break;
        }
    }
}

int OrderManager::pendingOrders() const
{
    int count = 0;
    for (const QVariant &v : m_orders) {
        QVariantMap order = v.toMap();
        if (order["status"].toString() == "Processing") count++;
    }
    return count;
}

double OrderManager::totalRevenue() const
{
    double total = 0;
    for (const QVariant &v : m_orders) {
        QVariantMap order = v.toMap();
        total += order["totalPrice"].toDouble();
    }
    return total;
}

QString OrderManager::formatRupiah(double amount) const
{
    return QString("Rp %L1").arg(qint64(amount), 0, 10, QChar(','));
}