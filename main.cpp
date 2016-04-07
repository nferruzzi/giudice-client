#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "externals.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("Nicola Ferruzzi");
    app.setOrganizationDomain("github.com/nferruzzi");
    app.setApplicationName("Giudice di gara");

    QQmlApplicationEngine engine;

    Externals externals(NULL);
    engine.rootContext()->setContextProperty("externals", &externals);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
