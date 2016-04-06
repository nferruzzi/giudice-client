import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import "network.js" as Network

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Giudice di gara")

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: Network.checkConnection()
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("Configura")
            MenuItem {
                text: qsTr("&Giudice")
                onTriggered: function () {
                    var component = Qt.createComponent("giudiceServerDialog.qml");
                    var dlg = component.createObject(root);
                    dlg.open();
                }
            }
            MenuItem {
                text: qsTr("&Server")
                onTriggered: function () {
                    var component = Qt.createComponent("configServerDialog.qml");
                    var dlg = component.createObject(root);
                    dlg.open();
                }
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    statusBar: StatusBar {
        id: statusBar
        state: "disconnected"
        Component.onCompleted: Network.checkConnection();
        states: [
            State {
                name: "connected"
                PropertyChanges {
                    target: labelState
                    color: "green"
                    text: qsTr("Giudice: %1 Server: %2").arg(settings.numeroGiudice).arg(settings.serverAddress)
                }
            },
            State {
                name: "disconnected"
                PropertyChanges {
                    target: labelState
                    color: "red"
                    text: qsTr("Server non raggiungibile: %1").arg(settings.serverAddress)
                }
            }
        ]
        RowLayout {
            anchors.fill: parent
            Label {
                id: labelState
                font.pointSize: 8
            }
        }
    }

    MainForm {
        id: mainform
        anchors.fill: parent
        registra.onClicked: messageDialog.show(qsTr("Trasmissione in corso..."), qsTr("In attesa di conferma"))
        pettorina.placeholderText: qsTr("es. 10");
        voto.placeholderText: qsTr("es. 6,5");
    }

    MessageDialog {
        id: messageDialog

        function show(title, caption) {
            messageDialog.title = title;
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    Settings {
        id: settings
        property string serverAddress: ""
        property string numeroGiudice: ""
    }

}
