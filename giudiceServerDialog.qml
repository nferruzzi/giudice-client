import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import "other.js" as Other

Dialog {
    id: giudiceServerDialog
    title: qsTr("Configurazione")
    standardButtons: StandardButton.Save | StandardButton.Cancel
    property var callback

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

    onAccepted: doAccepted()

    function doAccepted() {
        console.log(numeroGiudice.text);
        Qt.inputMethod.hide();

        if (numeroGiudice.text !== "") {
            settings.numeroGiudice = numeroGiudice.text
            Other.ShowDialog(qsTr("Ok"), qsTr("Fatto"));
            if (giudiceServerDialog.callback) giudiceServerDialog.callback(true);
        } else {
            Other.ShowDialog(qsTr("Errore"), qsTr("Il campo non puo' essere vuoto"));
            if (giudiceServerDialog.callback) giudiceServerDialog.callback(false);
        }
    }
 }
