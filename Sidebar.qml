import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: sidebar

    // Public properties
    property string currentPage: "Dashboard"

    // Signal emitted when a page is selected
    signal pageSelected(string page)

    color: "#151E2B"
    radius: 20

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // Application title
        Text {
            text: "My Home"
            color: "#E9B65D"
            font.pixelSize: 24
            font.bold: true

            Layout.leftMargin: 8
            Layout.bottomMargin: 32
        }

        // Navigation buttons
        Repeater {
            model: [
                "Dashboard",
                "Rooms",
                "Cameras",
                "Devices",
                "Scenes",
                "Settings"
            ]

            delegate: Button {
                id: navigationButton

                Layout.fillWidth: true
                Layout.preferredHeight: 46

                text: modelData
                hoverEnabled: true

                // Custom button background
                background: Rectangle {
                    radius: 12

                    color: sidebar.currentPage === navigationButton.text
                           ? "#3B3325"
                           : navigationButton.hovered
                             ? "#253141"
                             : "transparent"

                    border.color: "#E9B65D"
                    border.width: sidebar.currentPage === navigationButton.text
                                  ? 1 : 0
                }

                // Custom button text
                contentItem: Text {
                    text: navigationButton.text

                    color: sidebar.currentPage === navigationButton.text
                           ? "#E9B65D"
                           : "#A1ADBC"

                    font.pixelSize: 15
                    font.bold: sidebar.currentPage === navigationButton.text

                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 14
                }

                onClicked: {
                    sidebar.currentPage = text
                    sidebar.pageSelected(text)
                }
            }
        }

        // Push content to the top
        Item {
            Layout.fillHeight: true
        }

        Text {
            text: "Smart Home | Qt 6"
            color: "#657183"
            font.pixelSize: 11

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
