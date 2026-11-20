import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

DashboardCard {
    id: root

    property string title: "Apartment Overview"
    property string subtitle: "3 rooms • 68 m²"
    property url mapSource: Qt.resolvedUrl("assets/images/apartment/apartment-overview.png")

    implicitHeight: 360
    contentMargin: 16

    topColor: "#213D49"
    middleColor: "#162B35"
    bottomColor: "#0F1D25"
    borderColor: "#3D5260"

    // A single reusable row for the four quick controls.
    component QuickControlRow: Item {
        id: controlRow

        property string label: ""
        property url iconSource: ""
        property alias checked: toggle.checked

        implicitHeight: 43

        RowLayout {
            anchors.fill: parent
            spacing: 8

            Image {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                source: controlRow.iconSource
                sourceSize: Qt.size(40, 40)
                fillMode: Image.PreserveAspectFit
            }

            Text {
                Layout.fillWidth: true
                text: controlRow.label
                color: "#EDF3F7"
                font.pixelSize: 11
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            Switch {
                id: toggle
                padding: 0
                implicitWidth: 40
                implicitHeight: 24

                indicator: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 24
                    radius: 12
                    color: toggle.checked ? "#FFC84B" : "#485663"

                    Rectangle {
                        width: 18
                        height: 18
                        radius: 9
                        x: toggle.checked ? parent.width - width - 3 : 3
                        y: 3
                        color: "#FFFFFF"

                        Behavior on x {
                            NumberAnimation { duration: 150 }
                        }
                    }
                }

                contentItem: Item { }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.title
                color: "#FFFFFF"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: root.subtitle
                color: "#B7C2CA"
                font.pixelSize: 13
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // The apartment image is completely static.
            Image {
                Layout.fillWidth: true
                Layout.fillHeight: true
                source: root.mapSource
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(1200, 700)
                smooth: true
                mipmap: true
            }

            DashboardCard {
                Layout.preferredWidth: 225
                Layout.fillHeight: true

                contentMargin: 13
                cornerRadius: 16
                topColor: "#223844"
                middleColor: "#192C36"
                bottomColor: "#14232D"
                borderColor: "#405461"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 5

                    Text {
                        text: "Quick Controls"
                        color: "#FFFFFF"
                        font.pixelSize: 15
                        font.bold: true
                    }

                    AppDivider { Layout.fillWidth: true }

                    QuickControlRow {
                        Layout.fillWidth: true
                        label: "Living Room Lights"
                        iconSource: Qt.resolvedUrl("assets/icons/apartment/lightbulb.svg")
                        checked: true
                    }
                    AppDivider { Layout.fillWidth: true }

                    QuickControlRow {
                        Layout.fillWidth: true
                        label: "Climate (22 °C)"
                        iconSource: Qt.resolvedUrl("assets/icons/apartment/climate.svg")
                        checked: true
                    }
                    AppDivider { Layout.fillWidth: true }

                    QuickControlRow {
                        Layout.fillWidth: true
                        label: "Security (Armed)"
                        iconSource: Qt.resolvedUrl("assets/icons/apartment/security.svg")
                        checked: false
                    }
                    AppDivider { Layout.fillWidth: true }

                    QuickControlRow {
                        Layout.fillWidth: true
                        label: "Front Door Lock"
                        iconSource: Qt.resolvedUrl("assets/icons/apartment/lock.svg")
                        checked: true
                    }

                    Item { Layout.fillHeight: true }
                }
            }
        }
    }
}
