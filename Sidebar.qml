import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: sidebar

    property string currentPage: "Dashboard"
    signal pageSelected(string page)

    color: "#151E2B"
    radius: 20

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // App identity: colored house icon and title
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            Layout.topMargin: 4
            Layout.bottomMargin: 4
            spacing: 8

            Image {
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                source: Qt.resolvedUrl("assets/icons/home.svg")
                sourceSize: Qt.size(80, 80)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                Layout.fillWidth: true
                text: "My Home"
                color: "#E9B65D"
                font.pixelSize: 20
                font.bold: true
                elide: Text.ElideRight
            }
        }

        // Thin divider between app identity and navigation
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.bottomMargin: 18
            color: "#334152"
        }

        Repeater {
            model: [
                { label: "Dashboard", icon: "dashboard" },
                { label: "Rooms",     icon: "rooms" },
                { label: "Cameras",   icon: "cameras" },
                { label: "Devices",   icon: "devices" },
                { label: "Scenes",    icon: "scenes" },
                { label: "Settings",  icon: "settings" }
            ]

            delegate: Button {
                id: navigationButton

                readonly property bool selected: sidebar.currentPage === text
                readonly property string iconName: modelData.icon

                text: modelData.label
                hoverEnabled: true
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                padding: 0

                background: Rectangle {
                    radius: 12
                    color: navigationButton.selected ? "#3B3325"
                           : navigationButton.hovered ? "#253141"
                           : "transparent"

                    border.color: navigationButton.selected ? "#E9B65D" : "transparent"
                    border.width: 1

                    Behavior on color {
                        ColorAnimation { duration: 130 }
                    }
                }

                contentItem: RowLayout {
                    spacing: 10

                    Image {
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                        Layout.leftMargin: 13
                        source: Qt.resolvedUrl("assets/icons/" + navigationButton.iconName + ".svg")
                        sourceSize: Qt.size(36, 36)
                        fillMode: Image.PreserveAspectFit
                        opacity: navigationButton.selected ? 1.0 : 0.75
                    }

                    Text {
                        text: navigationButton.text
                        color: navigationButton.selected ? "#E9B65D" : "#A1ADBC"
                        font.pixelSize: 14
                        font.bold: navigationButton.selected
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillWidth: true
                    }
                }

                onClicked: {
                    sidebar.currentPage = text
                    sidebar.pageSelected(text)
                }
            }
        }

        Item { Layout.fillHeight: true }

        Text {
            text: "Smart Home | Qt 6"
            color: "#657183"
            font.pixelSize: 11
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 8
        }
    }
}
