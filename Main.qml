import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ApplicationWindow {
    id: root

    width: 1600
    height: 900
    minimumWidth: 1200
    minimumHeight: 700

    visible: true
    title: "Smart Home"
    color: "#0B1019"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        // =====================================
        // LEFT SIDEBAR
        // =====================================
        Sidebar {
            Layout.preferredWidth: 170
            Layout.fillHeight: true

            onPageSelected: function(page) {
                console.log("Selected page:", page)
            }
        }

        // =====================================
        // CENTRAL DASHBOARD
        // =====================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // Header
            Text {
                text: "Welcome Home"
                color: "white"
                font.pixelSize: 30
                font.bold: true
            }

            // Apartment overview
            DashboardCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 340

                topColor: "#264552"

                Text {
                    anchors.centerIn: parent
                    text: "Apartment Overview"
                    color: "white"
                    font.pixelSize: 22
                }
            }

            // Status cards
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.preferredHeight: 110

                spacing: 12

                Repeater {
                    model: [
                        "Wi-Fi",
                        "Air Quality",
                        "Energy",
                        "Devices"
                    ]

                    delegate: DashboardCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1


                        topColor: "#264552"

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                }
            }

            // Bottom dashboard
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 12

                // Camera preview
                DashboardCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1

                    topColor: "#264552"

                    Text {
                        anchors.centerIn: parent
                        text: "Front Door Camera"
                        color: "white"
                        font.pixelSize: 20
                    }
                }

                // Energy consumption
                DashboardCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1

                    topColor: "#264552"

                    Text {
                        anchors.centerIn: parent
                        text: "Energy Consumption"
                        color: "white"
                        font.pixelSize: 20
                    }
                }
            }
        }

        // RIGHT SIDEBAR
        ColumnLayout {
            Layout.preferredWidth: 290
            Layout.fillWidth: false
            Layout.fillHeight: true
            spacing: 16

            WeatherWidget {
                Layout.fillWidth: true
                Layout.preferredHeight: 260
                Layout.fillHeight: false

                city: "Berlin"
                temperature: 14
                condition: "Partly Cloudy"
            }

            CalendarWidget {
                Layout.fillWidth: true
                Layout.preferredHeight: 270
                Layout.fillHeight: false
            }

            Repeater {
                model: ["Music"]

                delegate: DashboardCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    topColor: "#264552"

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: "white"
                        font.pixelSize: 20
                    }
                }
            }
        }
    }
}
