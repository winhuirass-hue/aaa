#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtEnvironmentVariables>  // qputenv

int main(int argc, char *argv[])
{
    // Must be set before QGuiApplication is constructed
    qputenv("QT_QPA_PLATFORM", "wayland-egl");   // run compositor on a nested Wayland session
    // qputenv("QT_QPA_PLATFORM", "xcb");         // ← swap to this for testing inside X11

    QGuiApplication app(argc, argv);
    app.setApplicationName("noru-compositor");
    app.setApplicationVersion("0.1.0");
    app.setOrganizationName("noru");

    QQmlApplicationEngine eng;

    // Surface fatal QML errors immediately instead of silently running broken
    QObject::connect(
        &eng,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() {
            qCritical() << "Fatal: QML object creation failed — exiting.";
            QCoreApplication::exit(1);
        },
        Qt::QueuedConnection
    );

    eng.loadFromModule("NCompositor", "main");

    if (eng.rootObjects().isEmpty()) {
        qCritical() << "Fatal: no root objects loaded from NCompositor/main";
        return 1;
    }

    return app.exec();
}
