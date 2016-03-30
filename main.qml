import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

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
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("&Server")
                onTriggered: function () {
                    configServerDialog.open();
                    //configServer.showNormal();
                }
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

//    statusBar: StatusBar {
//        RowLayout {
//            anchors.fill: parent
//            Label { text: "Connesso al server remoto"; color: "green" }
//        }
//    }

    MainForm {
        id: mainform
        anchors.fill: parent
        registra.onClicked: messageDialog.show(qsTr("Trasmissione in corso..."), qsTr("In attesa di conferma"))
        pettorina.placeholderText: qsTr("es 10");
        voto.placeholderText: qsTr("es 6,5");
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(title, caption) {
            messageDialog.title = title;
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    Dialog {
        id: configServerDialog
        title: qsTr("Configurazione")
        standardButtons: StandardButton.Save | StandardButton.Cancel
        ColumnLayout {
            id: column
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
                   text: ""
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
                    messageDialog.show(qsTr("Ok"), qsTr("Fatto"));
                } else {
                    messageDialog.show(qsTr("Errore"), qsTr("Il campo non puo' essere vuoto"));
                }
            }
        }
    }
}
