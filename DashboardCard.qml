import QtQuick

Item {
    id: card

    // Content placed inside the card
    default property alias content: contentArea.data

    // Appearance
    property color topColor: "#243B46"
    property color middleColor: "#182A34"
    property color bottomColor: "#101B24"
    property color borderColor: "#405361"

    property int cornerRadius: 18
    property int contentMargin: 16

    implicitWidth: 260
    implicitHeight: 200

    // Card background
    Rectangle {
        anchors.fill: parent

        radius: card.cornerRadius

        border.width: 1
        border.color: card.borderColor

        gradient: Gradient {
            orientation: Gradient.Vertical

            GradientStop {
                position: 0.0
                color: card.topColor
            }

            GradientStop {
                position: 0.5
                color: card.middleColor
            }

            GradientStop {
                position: 1.0
                color: card.bottomColor
            }
        }
    }

    // Content container
    Item {
        id: contentArea

        anchors.fill: parent
        anchors.margins: card.contentMargin
    }
}
