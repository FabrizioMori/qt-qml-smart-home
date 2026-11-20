import QtQuick
import QtQuick.Layouts

DashboardCard {
    id: root

    property string title: "Front Door Camera"
    property bool live: true
    property url imageSource: Qt.resolvedUrl("assets/images/camera/front-door-camera.png")
    property bool imageHasTimestamp: true
    property string timestamp: "Today 14:26:07"

    implicitHeight: 248
    contentMargin: 12
    cornerRadius: 18

    topColor: "#1D3541"
    middleColor: "#152733"
    bottomColor: "#0F1A23"
    borderColor: "#3A4F5C"

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 26
            spacing: 8

            Image {
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
                source: Qt.resolvedUrl("assets/icons/camera/camera.svg")
                sourceSize: Qt.size(36, 36)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                text: root.title
                color: "#FFFFFF"
                font.pixelSize: 15
                font.bold: true
            }

            Rectangle {
                visible: root.live
                Layout.leftMargin: 6
                width: 9
                height: 9
                radius: 4.5
                color: "#48F28E"
            }

            Text {
                visible: root.live
                text: "Live"
                color: "#48F28E"
                font.pixelSize: 15
                font.bold: true
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 16
            color: "#111922"
            clip: true

            Image {
                anchors.fill: parent
                source: root.imageSource
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }

            Rectangle {
                visible: !root.imageHasTimestamp
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 14
                anchors.bottomMargin: 14
                radius: 10
                color: "#4C4A4A"
                opacity: 0.7

                width: timeLabel.implicitWidth + 16
                height: 30

                Text {
                    id: timeLabel
                    anchors.centerIn: parent
                    text: root.timestamp
                    color: "#FFFFFF"
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }
    }
}
