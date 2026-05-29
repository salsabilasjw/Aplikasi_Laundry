#ifndef ORDERMANAGER_H
#define ORDERMANAGER_H

#include <QDateTime>
#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class OrderManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList orders READ orders NOTIFY ordersChanged)
    Q_PROPERTY(int totalOrders READ totalOrders NOTIFY ordersChanged)
    Q_PROPERTY(int pendingOrders READ pendingOrders NOTIFY ordersChanged)
    Q_PROPERTY(double totalRevenue READ totalRevenue NOTIFY ordersChanged)

public:
    explicit OrderManager(QObject *parent = nullptr);

    QVariantList orders() const { return m_orders; }
    int totalOrders() const { return m_orders.count(); }
    int pendingOrders() const;
    double totalRevenue() const;

    Q_INVOKABLE void addOrder(const QString &customerName,
                              double weight,
                              const QString &serviceType);
    Q_INVOKABLE void updateOrderStatus(const QString &orderId, const QString &status);
    Q_INVOKABLE QString formatRupiah(double amount) const;

signals:
    void ordersChanged();
    void orderAdded(const QString &message);

private:
    QVariantList m_orders;
    int m_orderCounter;

    double getPricePerKg(const QString &serviceType) const;
};

#endif // ORDERMANAGER_H