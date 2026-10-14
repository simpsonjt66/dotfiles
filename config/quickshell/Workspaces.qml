import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    id: root
    spacing: 4

    Repeater {
        model: 5

        Rectangle {
            id: wsRect
            required property int index

            readonly property int workspaceId: wsRect.index + 1
            readonly property var hyprWorkspace: Hyprland.workspaces.values.find(w => w.id === wsRect.workspaceId)
            readonly property bool isActive: Hyprland.focusedWorkspace?.id === wsRect.workspaceId
            readonly property bool hasWindows: wsRect.hyprWorkspace !== undefined

            width: 18
            height: 18
            radius: 2
            color: wsRect.isActive ? "#F2EFE4" : (wsRect.hasWindows ? "#E6E4D9" : "#F2EFE4")

            Text {
                text: wsRect.workspaceId
                anchors.centerIn: parent
                color: wsRect.isActive ? "#1e1e2e" : "#cdd6f4"
                font.pointSize: 9
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Hyprland.dispatch("workspace " + wsRect.workspaceId)
                }
            }
        }
    }
}
