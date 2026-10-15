import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    id: root
    spacing: 4

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: wsRect
            required property var modelData

            width: 18
            height: 18
            radius: 2
            color: modelData.focused ? "#e5e2d8" : "#e6e4d9"

            Text {
                anchors.centerIn: parent
                text: wsRect.modelData.id
                color: wsRect.modelData.focused ? "#100f0f" : "#b7b5ac"
                font.pixelSize: 12
                font.family: "JetBrainsMono Nerd Font"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: wsRect.modelData.activate()
            }
        }
    }
}
