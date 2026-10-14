import QtQuick
import Quickshell

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

            ClockWidget {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 10
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
