import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Giudice di gara")

    menuBar: MenuBar {
        Menu {
            title: qsTr("Configura")
            MenuItem {
                text: qsTr("&Giudice")
                onTriggered: function () {
                    giudiceServerDialog.open();
                }
            }
            MenuItem {
                text: qsTr("&Server")
                onTriggered: function () {
                    configServerDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    statusBar: StatusBar {
        RowLayout {
            anchors.fill: parent
            Label {
                text: "Giudice: " + settings.numeroGiudice + " server: " + settings.serverAddress;
                color: "green"
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

    Dialog {
        id: configServerDialog
        title: qsTr("Configurazione")
        standardButtons: StandardButton.Save | StandardButton.Cancel
        ColumnLayout {
            width: parent ? parent.width : 100
            Label {
               text: qsTr("Indirizzo del server")
               Layout.columnSpan: 2
               Layout.fillWidth: true
               wrapMode: Text.WordWrap
            }
            RowLayout {
               Layout.alignment: Qt.AlignHCenter
               TextField {
                   id: serverAddress
                   text: settings.serverAddress
                   Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                   Layout.rowSpan: 1
                   placeholderText: qsTr("es. 192.168.0.1")
                   inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                   Keys.onReturnPressed: {
                       Qt.inputMethod.hide();
                   }
               }
            }
        }

        onButtonClicked: {
            Qt.inputMethod.hide();
            if (clickedButton === StandardButton.Save) {
                if (serverAddress.text != "") {
                    settings.serverAddress = serverAddress.text
                    messageDialog.show(qsTr("Ok"), qsTr("Fatto"));
                } else {
                    messageDialog.show(qsTr("Errore"), qsTr("Il campo non puo' essere vuoto"));
                }
            }
        }
    }

    Dialog {
        id: giudiceServerDialog
        title: qsTr("Configurazione")
        standardButtons: StandardButton.Save | StandardButton.Cancel
        ColumnLayout {
            width: parent ? parent.width : 100
            Label {
               text: qsTr("Numero del giudice")
               Layout.columnSpan: 2
               Layout.fillWidth: true
               wrapMode: Text.WordWrap
            }
            RowLayout {
               Layout.alignment: Qt.AlignHCenter
               TextField {
                   id: numeroGiudice
                   text: settings.numeroGiudice
                   Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                   Layout.rowSpan: 1
                   placeholderText: qsTr("es. 1,2,3,4 o 5")
                   inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhDigitsOnly
                   validator: IntValidator { bottom:1; top: 5}
                   Keys.onReturnPressed: {
                       Qt.inputMethod.hide();
                   }
               }
            }
        }

        onButtonClicked: {
            Qt.inputMethod.hide();
            if (clickedButton === StandardButton.Save) {
                if (numeroGiudice.text != "") {
                    settings.numeroGiudice = numeroGiudice.text
                    messageDialog.show(qsTr("Ok"), qsTr("Fatto"));
                } else {
                    messageDialog.show(qsTr("Errore"), qsTr("Il campo non puo' essere vuoto"));
                }
            }
        }
    }
}
