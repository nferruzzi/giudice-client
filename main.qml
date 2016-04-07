import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Styles 1.4
import "network.js" as Network

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Giudice di gara")
    property var currentGara

    Component.onCompleted: {
        console.log("UUID: ", settings.uuid);
        Network.userUUID = settings.uuid;
    }

    StateGroup {
        id: stateGroup
        state: "on"
        states: [
            State {
                name: "off"
                PropertyChanges {
                }
            },
            State {
                name: "on"
                PropertyChanges {
                }
            }
        ]
    }

    function checkConnection() {
        if (stateGroup.state === "off") return;

        Network.checkConnection(function(state) {
            if (state) {
                currentGara = state;

                var version = '1.0';
                if (state.version !== version) {
                    stateGroup.state = "off";
                    statusBar.state = "serverError";
                    messageDialog.show(qsTr("Errore"), qsTr("Il server (%1) e il client (%2) non usano la stessa versione del software").arg(state.version).arg(version));
                    return;
                }
            }
        });
    }

    Timer {
        interval: 3000; running: true; repeat: true
        onTriggered: checkConnection()
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
            MenuSeparator {}
            MenuItem {
                text: qsTr("&Collegati al server")
                checked: true
                visible: stateGroup.state === "off"
                onTriggered: function () {
                    stateGroup.state = "on";
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
        Component.onCompleted: {
            checkConnection();
        }
        states: [
            State {
                name: "connected"
                PropertyChanges {
                    target: labelState
                    color: "green"
                    text: qsTr("Giudice: %1 Trial: %2 | Gara: %3 | Server: %4").
                        arg(settings.numeroGiudice).
                        arg(root.currentGara.current_trial+1).
                        arg(root.currentGara.description).
                        arg(settings.serverAddress)
                }
            },
            State {
                name: "disconnected"
                PropertyChanges {
                    target: labelState
                    color: "red"
                    text: qsTr("Server non raggiungibile: %1").arg(settings.serverAddress)
                }
            },
            State {
                name: "serverError"
                PropertyChanges {
                    target: labelState
                    color: "red"
                    text: qsTr("Server non compatibile: %1").arg(settings.serverAddress)
                }
            }
        ]
        RowLayout {
            anchors.fill: parent
            Label {
                id: labelState
                font.pointSize: 16
            }
        }
    }

    MainForm {
        id: mainform
        anchors.fill: parent

        formColumnLayout.anchors.bottomMargin: Qt.platform.os === "android" ? 500 : 0;

        pettorina.placeholderText: qsTr("es: 10");
        //voto.validator: DoubleValidator { bottom:0; top: 10; decimals: 2; notation: DoubleValidator.StandardNotation}
        pettorina.validator: IntValidator { bottom:0; top: 10000}
        pettorina.inputMethodHints: Qt.ImhFormattedNumbersOnly
        pettorina.onTextChanged: {
            var pf = parseInt(pettorina.text);
            console.log(pf);
            if (pf >= 0 && pf <= 10000) {
                pettorina.textColor = "green";
            } else {
                pettorina.textColor = "red";
            }
        }

        voto.placeholderText: qsTr("es: 6.5");
        voto.validator: RegExpValidator { regExp: /\d0?(\.\d{0,2})?/ }
        voto.inputMethodHints: Qt.ImhFormattedNumbersOnly
        voto.onTextChanged: {
            var pf = parseFloat(voto.text);
            console.log(pf);
            if (pf >= 0.0 && pf <= 10.0) {
                voto.textColor = "green";
            } else {
                voto.textColor = "red";
            }
        }

        registra.onClicked: {
            Network.sendVote(root.currentGara.current_trial, parseInt(pettorina.text), parseFloat(voto.text), settings.numeroGiudice, function(xhr, resp) {
                if (resp != null) {
                    messageDialog.show(qsTr("Voto registrato"), qsTr("Ok"));
                } else {
                    messageDialog.show(qsTr("Errore"), qsTr("Il voto non e' stato accettato"));
                }
            });
        }

        registra.enabled: pettorina.acceptableInput && voto.acceptableInput && statusBar.state == "connected"
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
        property string uuid: externals.UUID
    }
}
