import Quickshell // for PanelWindow

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

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
