import QtQuick
import QtQuick.Layouts

DashboardCard {
    id: weather

    // Data (simulated for now)
    property string city: "Berlin"
    property int temperature: 14
    property string condition: "Partly Cloudy"

    property var forecast: [
        { day: "Today", icon: "partly-cloudy", high: 15, low: 8 },
        { day: "Wed",   icon: "sun",           high: 16, low: 9 },
        { day: "Thu",   icon: "cloud",         high: 14, low: 7 },
        { day: "Fri",   icon: "sun",           high: 17, low: 9 }
    ]

    // Shared card appearance, with a slightly bluer weather gradient
    implicitWidth: 290
    implicitHeight: 260
    contentMargin: 14
    cornerRadius: 18
    borderColor: "#405665"
    topColor: "#244454"
    middleColor: "#1A2D39"
    bottomColor: "#111E27"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header: icon, title, city and location pin
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            spacing: 7

            Image {
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25
                source: Qt.resolvedUrl("assets/icons/weather/partly-cloudy.svg")
                sourceSize: Qt.size(50, 50)
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: "Weather"
                color: "#FFFFFF"
                font.pixelSize: 16
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                text: weather.city
                color: "#E0E7ED"
                font.pixelSize: 11
            }

            Image {
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                source: Qt.resolvedUrl("assets/icons/weather/location.svg")
                sourceSize: Qt.size(32, 32)
                fillMode: Image.PreserveAspectFit
            }
        }

        // Current weather. The illustration is a static SVG asset.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 94

            Image {
                anchors.right: parent.right
                anchors.rightMargin: -6
                anchors.top: parent.top
                anchors.topMargin: -4

                width: 165
                height: 115
                source: Qt.resolvedUrl("assets/icons/weather/hero.svg")
                sourceSize: Qt.size(330, 230)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Column {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 9
                spacing: 1

                Text {
                    text: weather.temperature + " °C"
                    color: "#FFFFFF"
                    font.pixelSize: 43
                    font.weight: Font.DemiBold
                }

                Text {
                    text: weather.condition
                    color: "#BAC8D2"
                    font.pixelSize: 15
                }
            }
        }

        // Separator between current conditions and forecast
        AppDivider {
            Layout.fillWidth: true
            color: "#344955"
        }

        // Four-day forecast
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Layout.topMargin: 5
            spacing: 0

            Repeater {
                model: weather.forecast

                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.topMargin: 3
                        anchors.bottomMargin: 2
                        spacing: 3

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.day
                            color: "#E8EDF2"
                            font.pixelSize: 11
                        }

                        Image {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: 29
                            Layout.preferredHeight: 29
                            source: Qt.resolvedUrl(
                                "assets/icons/weather/" + modelData.icon + ".svg"
                            )
                            sourceSize: Qt.size(58, 58)
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.high + "° / " + modelData.low + "°"
                            color: "#E8EDF2"
                            font.pixelSize: 11
                        }
                    }

                    AppDivider {
                        visible: index < weather.forecast.length - 1
                        vertical: true
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 12
                        anchors.bottomMargin: 8
                        color: "#354754"
                    }
                }
            }
        }
    }
}
