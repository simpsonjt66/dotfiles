import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

RowLayout {
    spacing: 4

    // Iterate through a standard set of workspaces (e.g., 1 to 9)
    Repeater {
        model: 5

        Rectangle {
            readonly property int workspaceId: index + 1
            readonly property var hyprWorkspace: Hyprland.workspaces.values.find(w => w.id === workspaceId)
            readonly property bool isActive: Hyprland.focusedWorkspace?.id === workspaceId
            readonly property bool hasWindows: hyprWorkspace !== undefined

            width: 18
            height: 18
            radius: 2
            color: isActive ? "#F2EFE4" : (hasWindows ? "#E6E4D9" : "#F2EFE4")

            Text {
                text: workspaceId
                anchors.centerIn: parent
                color: isActive ? "#1e1e2e" : "#cdd6f4"
                font.pointSize: 9
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  Hyprland.dispatch("hl.dsp.focus({ workspace = \"" + workspaceId +"\"})")
                }
            }
        }
    }
}
