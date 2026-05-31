#ifndef ORDERMANAGER_H
#define ORDERMANAGER_H

#include <QDateTime>
#include <QMap>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QVariantMap>

class OrderManager : public QObject
{
    Q_OBJECT

    // Properties yang bisa diakses dari QML
    Q_PROPERTY(QVariantList orders READ orders NOTIFY ordersChanged)
    Q_PROPERTY(int totalOrders READ totalOrders NOTIFY ordersChanged)
    Q_PROPERTY(int pendingOrders READ pendingOrders NOTIFY ordersChanged)
    Q_PROPERTY(double totalRevenue READ totalRevenue NOTIFY ordersChanged)

public:
    explicit OrderManager(QObject *parent = nullptr);

    // Getters untuk properties
    QVariantList orders() const { return m_orders; }
    int totalOrders() const { return m_orders.count(); }
    int pendingOrders() const;
    double totalRevenue() const;

    // Methods yang bisa dipanggil dari QML (Q_INVOKABLE)
    Q_INVOKABLE void addOrder(const QString &customerName,
                              double weight,
                              const QString &serviceType,
                              const QString &subService);
    Q_INVOKABLE void updateOrderStatus(const QString &orderId, const QString &status);
    Q_INVOKABLE QString formatRupiah(double amount) const;
    Q_INVOKABLE double getSubServicePrice(const QString &subService) const;
    Q_INVOKABLE QStringList getSubServiceOptions() const;

signals:
    // Signals untuk notify QML ketika data berubah
    void ordersChanged();
    void orderAdded(const QString &message); // Untuk toast notification

private:
    QVariantList m_orders;   // List semua order
    int m_orderCounter;      // Counter untuk generate ID order

    // Helper functions
    double getPricePerKg(const QString &serviceType) const;
    QString formatDateTime(const QDateTime &dateTime) const;

    // Sub service prices mapping
    QMap<QString, double> m_subServicePrices;
    void initializeSubServicePrices();
};

#endif // ORDERMANAGER_H
