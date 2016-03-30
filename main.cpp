#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("Nicola Ferruzzi");
    app.setOrganizationDomain("github.com/nferruzzi");
    app.setApplicationName("Giudice di gara");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
