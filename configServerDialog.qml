import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

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
               placeholderText: qsTr("es. 192.168.0.1:8000 or server:8000")
               inputMethodHints: Qt.ImhUrlCharactersOnly
               Keys.onReturnPressed: {
                   Qt.inputMethod.hide();
               }
           }
        }
    }

    onAccepted: doAccepted()

    function doAccepted() {
        Qt.inputMethod.hide();
        if (serverAddress.text != "") {
            settings.serverAddress = serverAddress.text
            messageDialog.show(qsTr("Ok"), qsTr("Fatto"));
        } else {
            messageDialog.show(qsTr("Errore"), qsTr("Il campo non puo' essere vuoto"));
        }
    }
}
