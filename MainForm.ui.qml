import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

Item {
    width: 640
    height: 480
    property alias registra: registra
    property alias voto: voto
    property alias pettorina: pettorina

    ColumnLayout {
        id: columnLayout1
        spacing: 20
        anchors.fill: parent

        Label {
            id: label1
            text: qsTr("Pettorina")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 40
            horizontalAlignment: Text.AlignHCenter
        }

        TextField {
            id: pettorina
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pointSize: 90
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            placeholderText: qsTr("Pettorina")
            validator: IntValidator { bottom:0; top: 10000}
        }

        Label {
            id: label2
            text: qsTr("Voto")
            font.pointSize: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        TextField {
            id: voto
            text: qsTr("")
            placeholderText: qsTr("Voto")
            Layout.fillHeight: true
            font.pointSize: 90
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            validator: DoubleValidator { bottom:0; top: 10; decimals: 2; notation: DoubleValidator.StandardNotation}
        }

        Button {
            id: registra
            height: 90
            text: qsTr("Registra")
            Layout.rowSpan: 1
            isDefault: false
            enabled: pettorina.text !== '' && voto.text !== ''
            checkable: false
            Layout.minimumHeight: 100
            Layout.minimumWidth: 300
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBaseline
            anchors {
                bottom: parent.bottom
                bottomMargin: 8
            }
            style: ButtonStyle {
                id: buttonStyle1
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: "Arial"
                        font.pointSize: 30
                        color: registra.enabled ? "green" : "gray"
                        text: control.text
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 1
                    }
            }
        }
    }
}
