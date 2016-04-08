import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Item {
    width: 640
    height: 480
    property alias registra: registra
    property alias voto: voto
    property alias pettorina: pettorina
    property alias formColumnLayout: columnLayout

    ColumnLayout {
        id: columnLayout
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 500
        anchors.topMargin: 5
        spacing: 5
        anchors.fill: parent

        Label {
            id: label1
            text: qsTr("Pettorina")
            Layout.maximumHeight: 50
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 50
            horizontalAlignment: Text.AlignHCenter
        }

        TextField {
            id: pettorina
            Layout.minimumHeight: 150
            Layout.maximumHeight: 150
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pointSize: 90
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            placeholderText: qsTr("Pettorina")
            //inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        Label {
            id: label2
            text: qsTr("Voto")
            transformOrigin: Item.Center
            clip: false
            Layout.maximumHeight: 50
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pointSize: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        }

        TextField {
            id: voto
            text: qsTr("")
            Layout.minimumHeight: 150
            Layout.maximumHeight: 150
            placeholderText: qsTr("Voto")
            Layout.fillHeight: true
            font.pointSize: 90
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
        }

        Button {
            id: registra
            text: qsTr("Registra")
            Layout.maximumHeight: 80
            Layout.minimumHeight: 0
            Layout.maximumWidth: 200
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rowSpan: 1
            isDefault: false
            checkable: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
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
