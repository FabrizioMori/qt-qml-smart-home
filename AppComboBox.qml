
import QtQuick
import QtQuick.Controls.Basic

ComboBox {
    id: control

    implicitWidth: 116
    implicitHeight: 30

    font.pixelSize: 11

    // Custom background
    background: Rectangle {
        radius: 10
        color: control.down ? "#344752" : "#273A45"

        border.width: 1
        border.color: "#41525C"
    }

    // Selected text
    contentItem: Text {
        text: control.displayText
        color: "#E8EFF4"

        font: control.font
        verticalAlignment: Text.AlignVCenter

        leftPadding: 10
        rightPadding: 24
        elide: Text.ElideRight
    }

    // Dropdown arrow
    indicator: Image {
        x: control.width - width - 9
        y: (control.height - height) / 2

        width: 13
        height: 13

        source: Qt.resolvedUrl(
            "assets/icons/chevron-down.svg"
        )

        sourceSize: Qt.size(26, 26)
        fillMode: Image.PreserveAspectFit
    }

    // Dropdown options
    delegate: ItemDelegate {
        id: optionDelegate

        width: control.width - 8
        height: 30

        text: modelData
        font.pixelSize: control.font.pixelSize

        highlighted: control.highlightedIndex === index

        contentItem: Text {
            text: optionDelegate.text
            color: "#E8EFF4"

            font: optionDelegate.font
            leftPadding: 8
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            radius: 7
            color: optionDelegate.highlighted
                   ? "#3B535D"
                   : "transparent"
        }
    }

    // Dropdown popup
    popup: Popup {
        y: control.height + 4
        width: control.width
        padding: 4

        implicitHeight: contentItem.implicitHeight
                        + topPadding + bottomPadding

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight

            model: control.popup.visible
                   ? control.delegateModel
                   : null

            currentIndex: control.highlightedIndex
        }

        background: Rectangle {
            color: "#20313B"
            radius: 10

            border.width: 1
            border.color: "#41525C"
        }
    }
}
