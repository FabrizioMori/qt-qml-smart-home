import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

DashboardCard {
    id: music

    implicitWidth: 290
    implicitHeight: 310
    contentMargin: 14
    cornerRadius: 18

    // Use the common DashboardCard colors for a consistent design.
    property string selectedRoom: "Living Room"
    property bool isPlaying: true
    property bool isFavorite: false
    property bool shuffleEnabled: false
    property bool repeatEnabled: false
    property int currentTrackIndex: 0
    property real progressSeconds: 102

    // Demo content. No audio is played at this stage.
    property var tracks: [
        { title: "Golden Hour", artist: "Kylie Harper",
          cover: "golden-hour.svg", duration: 236 },
        { title: "Night Drive", artist: "Alex Morgan",
          cover: "night-drive.svg", duration: 204 },
        { title: "Ocean Breeze", artist: "Lena Rivers",
          cover: "ocean-breeze.svg", duration: 228 }
    ]

    readonly property var currentTrack: tracks[currentTrackIndex]

    function formatTime(seconds) {
        const total = Math.max(0, Math.floor(seconds))
        const minutes = Math.floor(total / 60)
        const remainder = total % 60
        return minutes + ":" + (remainder < 10 ? "0" : "") + remainder
    }

    function changeTrack(direction) {
        if (shuffleEnabled && tracks.length > 1) {
            const offset = 1 + Math.floor(Math.random() * (tracks.length - 1))
            currentTrackIndex = (currentTrackIndex + offset) % tracks.length
        } else {
            currentTrackIndex = (currentTrackIndex + direction + tracks.length) % tracks.length
        }
        progressSeconds = 0
        isFavorite = false
    }

    // Silent playback simulation for the UI demo.
    Timer {
        interval: 1000
        running: music.isPlaying
        repeat: true

        onTriggered: {
            if (music.progressSeconds + 1 >= music.currentTrack.duration) {
                if (music.repeatEnabled) {
                    music.progressSeconds = 0
                } else {
                    music.progressSeconds = music.currentTrack.duration
                    music.isPlaying = false
                }
            } else {
                music.progressSeconds += 1
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // =========================================
        // HEADER
        // =========================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            spacing: 7

            Image {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                source: Qt.resolvedUrl("assets/icons/music/music-note.svg")
                sourceSize: Qt.size(48, 48)
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: "Music"
                color: "#FFFFFF"
                font.pixelSize: 17
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            ComboBox {
                id: roomCombo
                Layout.preferredWidth: 116
                Layout.preferredHeight: 30
                model: ["Living Room", "Bedroom", "Kitchen"]
                currentIndex: 0
                font.pixelSize: 11
                onActivated: music.selectedRoom = currentText

                background: Rectangle {
                    radius: 10
                    color: roomCombo.down ? "#344752" : "#273A45"
                    border.width: 1
                    border.color: "#41525C"
                }

                contentItem: Text {
                    text: roomCombo.displayText
                    color: "#E8EFF4"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                    rightPadding: 24
                    elide: Text.ElideRight
                }

                indicator: Image {
                    x: roomCombo.width - width - 9
                    y: (roomCombo.height - height) / 2
                    width: 13
                    height: 13
                    source: Qt.resolvedUrl("assets/icons/music/chevron-down.svg")
                    sourceSize: Qt.size(26, 26)
                }

                delegate: ItemDelegate {
                    id: roomDelegate
                    width: roomCombo.width - 8
                    height: 30
                    text: modelData
                    font.pixelSize: 11
                    highlighted: roomCombo.highlightedIndex === index

                    contentItem: Text {
                        text: roomDelegate.text
                        color: "#E8EFF4"
                        font.pixelSize: 11
                        leftPadding: 8
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 7
                        color: roomDelegate.highlighted ? "#3B535D" : "transparent"
                    }
                }

                popup: Popup {
                    y: roomCombo.height + 4
                    width: roomCombo.width
                    padding: 4
                    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: roomCombo.popup.visible ? roomCombo.delegateModel : null
                        currentIndex: roomCombo.highlightedIndex
                    }

                    background: Rectangle {
                        color: "#20313B"
                        radius: 10
                        border.width: 1
                        border.color: "#41525C"
                    }
                }
            }
        }

        AppDivider {
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.bottomMargin: 14
            color: "#354651"
        }

        // =========================================
        // COVER, TITLE, ARTIST, FAVORITE
        // =========================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 82
            spacing: 12

            Rectangle {
                Layout.preferredWidth: 82
                Layout.preferredHeight: 82
                color: "#283B49"
                radius: 10
                clip: true

                Image {
                    anchors.fill: parent
                    source: Qt.resolvedUrl("assets/images/music/" + music.currentTrack.cover)
                    sourceSize: Qt.size(180, 180)
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    Layout.fillWidth: true
                    text: music.currentTrack.title
                    color: "#FFFFFF"
                    font.pixelSize: 17
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: music.currentTrack.artist
                    color: "#C0CCD5"
                    font.pixelSize: 13
                    elide: Text.ElideRight
                }
            }

            MusicControlButton {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 36
                iconSize: 22
                iconSource: Qt.resolvedUrl(
                    music.isFavorite ? "assets/icons/music/heart-filled.svg"
                                     : "assets/icons/music/heart.svg")
                onClicked: music.isFavorite = !music.isFavorite
            }
        }

        Item { Layout.fillHeight: true }

        // =========================================
        // PROGRESS SLIDER
        // =========================================
        Slider {
            id: progressSlider
            Layout.fillWidth: true
            Layout.preferredHeight: 18
            Layout.topMargin: 12

            from: 0
            to: music.currentTrack.duration
            value: music.progressSeconds
            padding: 0
            onMoved: music.progressSeconds = value

            background: Item {
                x: progressSlider.leftPadding
                y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                width: progressSlider.availableWidth
                height: 5

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: "#52606B"
                }

                Rectangle {
                    width: parent.width * progressSlider.visualPosition
                    height: parent.height
                    radius: height / 2
                    color: "#FFC842"
                }
            }

            handle: Rectangle {
                x: progressSlider.leftPadding +
                   progressSlider.visualPosition * (progressSlider.availableWidth - width)
                y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                width: 12
                height: 12
                radius: 6
                color: "#FFFFFF"
                border.color: "#D6DBE0"
                border.width: 1
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 1

            Text {
                text: music.formatTime(music.progressSeconds)
                color: "#C7D2DB"
                font.pixelSize: 11
            }

            Item { Layout.fillWidth: true }

            Text {
                text: music.formatTime(music.currentTrack.duration)
                color: "#C7D2DB"
                font.pixelSize: 11
            }
        }

        // =========================================
        // PLAYBACK CONTROLS
        // =========================================
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 54
            Layout.topMargin: 16
            Layout.bottomMargin: 4
            spacing: 0

            MusicControlButton {
                iconSource: Qt.resolvedUrl("assets/icons/music/shuffle.svg")
                active: music.shuffleEnabled
                onClicked: music.shuffleEnabled = !music.shuffleEnabled
            }

            Item { Layout.fillWidth: true }

            MusicControlButton {
                iconSource: Qt.resolvedUrl("assets/icons/music/skip-back.svg")
                onClicked: music.changeTrack(-1)
            }

            Item { Layout.fillWidth: true }

            Button {
                id: playPauseButton
                Layout.preferredWidth: 52
                Layout.preferredHeight: 52
                hoverEnabled: true
                onClicked: music.isPlaying = !music.isPlaying

                background: Rectangle {
                    radius: width / 2
                    color: playPauseButton.down ? "#E8AD2B" :
                           playPauseButton.hovered ? "#FFD665" : "#FFC842"
                    border.width: 1
                    border.color: "#F5C958"

                    Behavior on color {
                        ColorAnimation { duration: 120 }
                    }
                }

                contentItem: Item {
                    Image {
                        anchors.centerIn: parent
                        width: 22
                        height: 22
                        source: Qt.resolvedUrl(music.isPlaying
                            ? "assets/icons/music/pause.svg"
                            : "assets/icons/music/play.svg")
                        sourceSize: Qt.size(44, 44)
                    }
                }
            }

            Item { Layout.fillWidth: true }

            MusicControlButton {
                iconSource: Qt.resolvedUrl("assets/icons/music/skip-forward.svg")
                onClicked: music.changeTrack(1)
            }

            Item { Layout.fillWidth: true }

            MusicControlButton {
                iconSource: Qt.resolvedUrl("assets/icons/music/repeat.svg")
                active: music.repeatEnabled
                onClicked: music.repeatEnabled = !music.repeatEnabled
            }
        }
    }
}
