import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

DashboardCard {
    id: calendar

    // Demo data: January 21, 2025 (as shown in the mockup).
    // Later, these values can come from a C++ backend.
    property date demoToday: new Date(2025, 0, 21)
    property date selectedDate: demoToday
    property int displayedMonth: 0     // 0 = January
    property int displayedYear: 2025

    readonly property var monthNames: [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]

    property var events: [
        { title: "Team Meeting", time: "15:00 – 16:00", accent: "#FFC842" },
        { title: "Gym",          time: "18:00 – 19:00", accent: "#4DE4DE" },
        { title: "Dinner",       time: "20:00 – 21:00", accent: "#4DE4DE" }
    ]

    function sameDay(a, b) {
        return a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate()
    }

    function hasEvent(d) {
        // Sample markers for the reference month.
        return d.getFullYear() === 2025 && d.getMonth() === 0
            && [6, 11, 15, 16, 18, 21, 22, 24].indexOf(d.getDate()) !== -1
    }

    function changeMonth(offset) {
        let next = new Date(displayedYear, displayedMonth + offset, 1)
        displayedYear = next.getFullYear()
        displayedMonth = next.getMonth()
    }

    implicitWidth: 290
    implicitHeight: 270
    contentMargin: 12
    cornerRadius: 18

    // Inherit the shared gradient and border from DashboardCard.

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // =====================================
        // HEADER
        // =====================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            spacing: 8

            Image {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                source: Qt.resolvedUrl("assets/icons/calendar.svg")
                sourceSize: Qt.size(48, 48)
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: "Calendar"
                color: "#FFFFFF"
                font.pixelSize: 17
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                id: monthPicker
                Layout.preferredWidth: 93
                Layout.preferredHeight: 27
                color: "#263742"
                radius: 10
                border.color: "#3A4C58"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 9
                    anchors.rightMargin: 7
                    spacing: 3

                    Text {
                        Layout.fillWidth: true
                        text: calendar.monthNames[calendar.displayedMonth]
                              + " " + calendar.displayedYear
                        color: "#F0F4F7"
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        text: "v"
                        color: "#F0F4F7"
                        font.pixelSize: 11
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: monthPopup.open()
                }
            }
        }

        Item { Layout.preferredHeight: 13 }

        // =====================================
        // CALENDAR + EVENTS
        // =====================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            ColumnLayout {
                Layout.preferredWidth: 151
                Layout.minimumWidth: 145
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 3

                DayOfWeekRow {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 19
                    locale: Qt.locale("en_GB")  // Monday first
                    padding: 0
                    background: Item {}

                    delegate: Text {
                        required property var model
                        text: model.shortName.substring(0, 2)
                        color: "#C6D1D9"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MonthGrid {
                    id: monthGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 145
                    month: calendar.displayedMonth
                    year: calendar.displayedYear
                    locale: Qt.locale("en_GB")
                    padding: 0
                    background: Item {}

                    onClicked: function(date) {
                        calendar.selectedDate = date
                    }

                    delegate: Item {
                        required property var model
                        implicitWidth: 20
                        implicitHeight: 23

                        // Keep the cell in the grid; hide only its appearance.
                        opacity: model.month === monthGrid.month ? 1 : 0

                        readonly property bool selected:
                            calendar.sameDay(model.date, calendar.selectedDate)

                        Rectangle {
                            anchors.centerIn: parent
                            width: 22
                            height: 22
                            radius: 11
                            color: parent.selected ? "#FFC842" : "transparent"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: model.day
                            color: parent.selected ? "#18212A" : "#E1E9EF"
                            font.pixelSize: 11
                            font.bold: parent.selected
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            width: 3
                            height: 3
                            radius: 2
                            color: "#54DCD4"
                            visible: calendar.hasEvent(model.date) && !parent.selected
                        }
                    }
                }
            }

            AppDivider {
                vertical: true
                Layout.fillHeight: true
                color: "#3D515B"
            }

            ColumnLayout {
                Layout.preferredWidth: 94
                Layout.minimumWidth: 88
                Layout.fillWidth: false
                Layout.fillHeight: true
                spacing: 8

                Text {
                    Layout.fillWidth: true
                    text: calendar.sameDay(calendar.selectedDate, calendar.demoToday)
                          ? "Today"
                          : Qt.formatDate(calendar.selectedDate, "d MMM")
                    color: "#FFFFFF"
                    font.pixelSize: 14
                    font.bold: true
                    elide: Text.ElideRight
                }

                Repeater {
                    model: calendar.sameDay(calendar.selectedDate, calendar.demoToday)
                           ? calendar.events : []

                    delegate: RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        spacing: 5

                        Rectangle {
                            Layout.preferredWidth: 4
                            Layout.fillHeight: true
                            radius: 2
                            color: modelData.accent
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: modelData.title
                                color: "#F5F7F9"
                                font.pixelSize: 10
                                font.bold: true
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.time
                                color: "#C5D1D9"
                                font.pixelSize: 9
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    visible: !calendar.sameDay(calendar.selectedDate, calendar.demoToday)
                    text: "No events"
                    color: "#8FA3B2"
                    font.pixelSize: 11
                }

                Item { Layout.fillHeight: true }
            }
        }
    }

    // A small popup to navigate between months, instead of a native combo box.
    Popup {
        id: monthPopup
        parent: calendar
        x: calendar.width - width - calendar.contentMargin
        y: 34
        width: 170
        height: 56
        padding: 8
        modal: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: 11
            color: "#22333E"
            border.color: "#405665"
        }

        RowLayout {
            anchors.fill: parent
            spacing: 4

            Button {
                id: previousMonthButton
                Layout.preferredWidth: 32
                Layout.fillHeight: true
                text: "‹"
                onClicked: calendar.changeMonth(-1)
                background: Rectangle { color: "#304651"; radius: 7 }
                contentItem: Text {
                    text: previousMonthButton.text
                    color: "white"
                    font.pixelSize: 21
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Text {
                Layout.fillWidth: true
                text: calendar.monthNames[calendar.displayedMonth]
                      + " " + calendar.displayedYear
                color: "white"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Button {
                id: nextMonthButton
                Layout.preferredWidth: 32
                Layout.fillHeight: true
                text: "›"
                onClicked: calendar.changeMonth(1)
                background: Rectangle { color: "#304651"; radius: 7 }
                contentItem: Text {
                    text: nextMonthButton.text
                    color: "white"
                    font.pixelSize: 21
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
