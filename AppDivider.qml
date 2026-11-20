import QtQuick

Rectangle {
    id: root

    property bool vertical: false
    property int thickness: 1

    color: "#334152"
    radius: thickness / 2

    implicitWidth: vertical ? thickness : 1
    implicitHeight: vertical ? 1 : thickness
}
