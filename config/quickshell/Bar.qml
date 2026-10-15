import QtQuick
import Quickshell
import qs.widgets.components

Scope {
    Variants {
        model: Quickshell.screens

        // qmllint disable uncreatable-type
        PanelWindow {
            id: barWindow
            required property var modelData
            screen: barWindow.modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 25
            color: "#fffcf0"

            ClockWidget {
                anchors {
                    centerIn: parent
                    verticalCenter: parent.verticalCenter
                }
            }

            Workspaces {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 10
                }
            }
        }
    }
}
