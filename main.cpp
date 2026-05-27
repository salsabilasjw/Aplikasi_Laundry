#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "OrderManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Register OrderManager
    OrderManager orderManager;
    engine.rootContext()->setContextProperty("orderManager", &orderManager);

    // Load main QML
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/Aplikasi_Laundry/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
