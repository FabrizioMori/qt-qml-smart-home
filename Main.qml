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

            ApartmentOverviewWidget {
                Layout.fillWidth: true
                Layout.preferredHeight: 440
            }

            // Status cards
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                spacing: 12

                StatusCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true

                    title: "Wi-Fi"
                    value: "Excellent"
                    iconSource: Qt.resolvedUrl("assets/icons/status/wifi.svg")
                    accentColor: "#59EFFF"
                    iconGlowColor: "#14343D"
                    showStatusDot: true
                }

                StatusCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true

                    title: "Air Quality"
                    value: "Good"
                    iconSource: Qt.resolvedUrl("assets/icons/status/leaf.svg")
                    accentColor: "#8DFF54"
                    iconGlowColor: "#203826"
                    showStatusDot: true
                }

                StatusCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1.4
                    Layout.fillHeight: true

                    title: "Energy (Today)"
                    value: "8.4 kWh"
                    subtitle: "↓ -12% vs. yesterday"
                    iconSource: Qt.resolvedUrl("assets/icons/status/energy.svg")
                    accentColor: "#FFD24A"
                    iconGlowColor: "#3A3118"

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Repeater {
                            model: [8, 12, 16, 10, 18, 24]

                            delegate: Rectangle {
                                width: 5
                                height: modelData
                                radius: 2.5
                                color: "#FFD24A"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

                StatusCard {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true

                    title: "Connected Devices"
                    value: "14"
                    iconSource: Qt.resolvedUrl("assets/icons/status/devices.svg")
                    accentColor: "#4BE9F3"
                    iconGlowColor: "#143139"
                    showStatusDot: true
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

            MusicWidget {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 270
            }
        }
    }
}
