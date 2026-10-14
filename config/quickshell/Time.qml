pragma Singleton

import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text

Singleton {
  id: root
  readonly property string time: {

    Qt.formatDateTime(clock.date, "ddd MMM d hh:mm")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
