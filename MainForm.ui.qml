import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

Item {
    width: 640
    height: 480

    property alias button2: button2

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
            id: textField1
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pointSize: 70
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            placeholderText: qsTr("Pettorina")
            inputMethodHints: Qt.ImhPreferNumbers
            validator: IntValidator { bottom:0; top: 10000}
        }

        Label {
            id: label2
            text: qsTr("Voto")
            font.pointSize: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        TextField {
            id: textField2
            text: qsTr("")
            placeholderText: qsTr("Voto")
            Layout.fillHeight: true
            font.pointSize: 70
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhDigitsOnly
            validator: DoubleValidator { bottom:0; top: 10; decimals: 2; notation: DoubleValidator.StandardNotation}
        }

        Button {
            id: button2
            height: 90
            text: qsTr("Registra")
            Layout.rowSpan: 1
            isDefault: false
            enabled: true
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
                        color: "green"
                        text: control.text
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 1
                    }
            }
        }
    }
}
