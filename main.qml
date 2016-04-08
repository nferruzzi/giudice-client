import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Styles 1.4
import "network.js" as Network
import "other.js" as Other

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

        Network.checkConnection(settings.numeroGiudice, function(xhr, state) {
            if (xhr.status == 401) {
                var msg = qsTr("Il server non e' compatibile con questo client");
                stateGroup.state = "off";
                statusBar.state = "serverError";
                statusBar.errorMessage = msg;
                Other.ShowDialog(qsTr("Errore"), msg);
                return;
            }

            if (xhr.status == 403) {
                var msg = qsTr("Il giudice %1 e' gia' in uso").arg(settings.numeroGiudice);
                stateGroup.state = "off";
                statusBar.errorMessage = msg;
                statusBar.state = "serverError";
                Other.ShowDialog(qsTr("Errore"), msg);
                return;
            }

            if (xhr.status == 404) {
                var msg = qsTr("Sono richiesti meno giudici: %1").arg(state['max']);
                stateGroup.state = "off";
                statusBar.errorMessage = msg;
                statusBar.state = "serverError";
                Other.ShowDialog(qsTr("Errore"), msg);
                return;
            }

            if (state) {
                currentGara = state;

                var version = '1.0';
                if (state.version !== version) {
                    var msg = qsTr("Il server (%1) e il client (%2) non usano la stessa versione del software").arg(state.version).arg(version);
                    stateGroup.state = "off";
                    statusBar.state = "serverError";
                    statusBar.errorMessage = msg;
                    Other.ShowDialog(qsTr("Errore"), msg);
                    return;
                }

                statusBar.state = "connected";
            } else {
                statusBar.state = "disconnected";
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
                    Other.ShowGiudiceDialog(function (state) {
                        if (state) {
                            stateGroup.state = "on";
                        }
                    });
                }
            }
            MenuItem {
                text: qsTr("&Server")
                onTriggered: function () {
                    Other.ShowServerDialog(function (state) {
                        if (state) {
                            stateGroup.state = "on";
                        }
                    });
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
        property string errorMessage

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
                    text: statusBar.errorMessage
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
                    Other.ShowDialog(qsTr("Voto registrato"), qsTr("Ok"));
                } else {
                    Other.ShowDialog(qsTr("Errore"), qsTr("Il voto non e' stato accettato"));
                }
            });
        }

        registra.enabled: pettorina.acceptableInput && voto.acceptableInput && statusBar.state == "connected"
    }

    Settings {
        id: settings
        property string serverAddress: ""
        property string numeroGiudice: ""
        property string uuid: externals.UUID
    }
}
