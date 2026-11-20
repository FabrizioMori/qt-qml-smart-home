import QtQuick
import QtQuick.Layouts

DashboardCard {
    id: card

    property string title: ""
    property string value: ""
    property string subtitle: ""
    property string iconSource: ""

    property color accentColor: "#51E3D4"
    property color iconGlowColor: "#13343D"
    property bool showStatusDot: false
    property color statusDotColor: "#49F2A3"

    // slot per eventuale contenuto extra a destra
    default property alias extraContent: extraArea.data

    implicitHeight: 82
    cornerRadius: 18
    contentMargin: 12

    topColor: "#223742"
    middleColor: "#162833"
    bottomColor: "#101B24"
    borderColor: "#3A4D5A"

    RowLayout {
        anchors.fill: parent
        spacing: 10

        // Icon area
        Item {
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.centerIn: parent
                width: 44
                height: 44
                radius: 22
                color: card.iconGlowColor
                opacity: 0.95
            }

            Rectangle {
                anchors.centerIn: parent
                width: 30
                height: 30
                radius: 15
                color: "transparent"

                Image {
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    source: card.iconSource
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(48, 48)
                }
            }
        }

        // Text area
        ColumnLayout {
            Layout.fillWidth: true

            Layout.fillHeight: false
            Layout.alignment: Qt.AlignVCenter

            spacing: 1

            Text {
                text: card.title
                color: "#B8C4CD"
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Text {
                text: card.value
                color: "#FFFFFF"
                font.pixelSize: 15
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                visible: text.length > 0
                text: card.subtitle
                color: "#49F2A3"
                font.pixelSize: 10
                elide: Text.ElideRight
            }

        }

        // Extra content on the right
        Item {
            id: extraArea
            Layout.preferredWidth: childrenRect.width
            Layout.fillHeight: true
        }

        // Optional dot
        Rectangle {
            visible: card.showStatusDot
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 4

            width: 9
            height: 9
            radius: 4.5
            color: card.statusDotColor
        }
    }
}