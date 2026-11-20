import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control

    property url iconSource
    property int iconSize: 19
    property bool active: false

    implicitWidth: 38
    implicitHeight: 38
    hoverEnabled: true

    background: Rectangle {
        radius: 11
        color: control.down ? "#354B58"
                            : control.active ? "#2C454A"
                            : control.hovered ? "#283C47" : "transparent"

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    contentItem: Item {
        Image {
            anchors.centerIn: parent
            width: control.iconSize
            height: control.iconSize
            source: control.iconSource
            sourceSize: Qt.size(control.iconSize * 2, control.iconSize * 2)
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
    }
}
