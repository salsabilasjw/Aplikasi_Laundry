#include "OrderManager.h"
#include <QLocale>
#include <cmath>

OrderManager::OrderManager(QObject *parent)
    : QObject(parent)
    , m_orderCounter(0)
{
    // Initialize sub service prices
    initializeSubServicePrices();
}

void OrderManager::initializeSubServicePrices()
{
    // Harga sub service sesuai dengan React app
    m_subServicePrices["Cuci Biasa"] = 0.0;
    m_subServicePrices["Cuci + Lipat"] = 5000.0;
    m_subServicePrices["Cuci + Lipat + Setrika"] = 10000.0;
    m_subServicePrices["Cuci Bed Cover"] = 5000.0;
    m_subServicePrices["Karpet"] = 7000.0;
}

QStringList OrderManager::getSubServiceOptions() const
{
    return QStringList() << "Cuci Biasa (+Rp 0)"
                         << "Cuci + Lipat (+Rp 5.000)"
                         << "Cuci + Lipat + Setrika (+Rp 10.000)"
                         << "Cuci Bed Cover (+Rp 5.000)"
                         << "Karpet (+Rp 7.000)";
}

double OrderManager::getPricePerKg(const QString &serviceType) const
{
    // Harga sesuai dengan React app
    if (serviceType == "Regular")
        return 10000.0; // Rp 10.000/kg
    if (serviceType == "Express")
        return 15000.0; // Rp 15.000/kg
    return 10000.0;     // Default Regular
}

double OrderManager::getSubServicePrice(const QString &subService) const
{
    // Extract sub service name from option text
    // "Cuci Biasa (+Rp 0)" -> "Cuci Biasa"
    QString subServiceName = subService;
    if (subService.contains(" (+"))
        subServiceName = subService.split(" (+").first();

    return m_subServicePrices.value(subServiceName, 0.0);
}

QString OrderManager::formatDateTime(const QDateTime &dateTime) const
{
    // Format: "25 May 2026, 19:30:45" - sesuai dengan React
    return dateTime.toString("dd MMMM yyyy, HH:mm:ss");
}

void OrderManager::addOrder(const QString &customerName,
                            double weight,
                            const QString &serviceType,
                            const QString &subService)
{
    // Increment counter untuk ID baru
    m_orderCounter++;

    // Generate ID dengan format 001, 002, 003, dst
    QString orderId = QString("%1").arg(m_orderCounter, 3, 10, QChar('0'));

    // Extract sub service name (remove price info)
    QString subServiceName = subService;
    if (subService.contains(" (+"))
        subServiceName = subService.split(" (+").first();

    // Hitung harga
    double pricePerKg = getPricePerKg(serviceType);
    double subServicePrice = m_subServicePrices.value(subServiceName, 0.0);

    // Rumus: (berat × harga per kg) + harga sub layanan
    double totalPrice = (weight * pricePerKg) + subServicePrice;

    // Buat order object sebagai QVariantMap
    QVariantMap order;
    order["id"] = orderId;
    order["customerName"] = customerName;
    order["weight"] = weight;
    order["serviceType"] = serviceType;
    order["subService"] = subServiceName;
    order["subServicePrice"] = subServicePrice;
    order["totalPrice"] = totalPrice;
    order["status"] = "Processing"; // Default status
    order["createdAt"] = formatDateTime(QDateTime::currentDateTime());

    // Tambahkan ke list orders
    m_orders.append(order);

    // Emit signals
    emit ordersChanged();                         // Notify QML bahwa orders berubah
    emit orderAdded("Order added successfully!"); // Trigger toast notification
}

void OrderManager::updateOrderStatus(const QString &orderId, const QString &status)
{
    // Loop semua orders untuk cari yang sesuai ID
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
        if (order["status"].toString() == "Processing")
            count++;
    }
    return count;
}

double OrderManager::totalRevenue() const
{
    double total = 0.0;
    for (const QVariant &v : m_orders) {
        QVariantMap order = v.toMap();
        total += order["totalPrice"].toDouble();
    }
    return total;
}

QString OrderManager::formatRupiah(double amount) const
{
    // Format ke Rupiah Indonesia: "Rp 50.000"
    // Round ke integer terlebih dahulu
    qint64 roundedAmount = qRound(amount);

    // Format dengan thousand separator (titik untuk Indonesia)
    QLocale locale(QLocale::Indonesian);
    QString formatted = locale.toString(roundedAmount);

    // Tambahkan prefix "Rp "
    return "Rp " + formatted;
}
