Your overall architecture is on the right track: you have an entrypoint
([shell.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/shell.qml)),
a multi-monitor bar manager using `Variants`
([Bar.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Bar.qml)),
reusable widgets
([ClockWidget.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/ClockWidget.qml),
[Workspaces.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Workspaces.qml)),
and a dedicated data provider
([Time.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Time.qml)).

Running your files against Qt 6's `qmllint` and checking Quickshell's live log
reveals specific scoping, namespacing, and linter-quirk issues.

---

### Why the Linter (and Quickshell) Is Nagging

#### 1. Delegate Scoping & the `index` Error in [Workspaces.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Workspaces.qml)

- **The "Why"**: In Qt 6 QML, properties injected by delegates (like `index` in
  a `Repeater`) are dynamic context properties. Accessing `index` directly
  without declaring it causes:
  1. A runtime
     `WARN scene: @Workspaces.qml[16:-1]: ReferenceError: index is not defined`
     in Quickshell when bindings evaluate before context properties are
     attached.
  2. Linter warnings: `Unqualified access: 'index' is implicitly injected`.
- **The Fix**: Add `required property int index` to the delegate root item.

#### 2. Unqualified Scope Access in [Workspaces.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Workspaces.qml)

- **The "Why"**: Child elements (`Text`, `MouseArea`) reference parent
  properties like `workspaceId` and `isActive` without qualification. QML must
  traverse the outer component scope hierarchy at runtime, which degrades
  performance and triggers `[unqualified]` warnings.
- **The Fix**: Give the delegate element an ID (e.g. `id: wsRect`) and qualify
  references as `wsRect.workspaceId` and `wsRect.isActive`.

#### 3. Singleton Namespacing & `qmldir` in [Time.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Time.qml)

- **The "Why"**: Quickshell's custom QML loader recognizes `pragma Singleton` at
  runtime. However, standard Qt tooling (`qmllint` and `qmlls` LSP) adheres to
  standard Qt module rules: without a `qmldir` file declaring the singleton, the
  linter does not know `Time` is a singleton type, which produces:
  - `Type Time not declared as singleton in qmldir but using pragma Singleton`
  - In
    [ClockWidget.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/ClockWidget.qml):
    `Member "time" not found on type "Time"`
- **The Property Binding Bug**: In
  [Time.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Time.qml),
  wrapping the expression in curly braces `{ Qt.formatDateTime(...) }` makes it
  a JavaScript code block without a `return` statement, evaluating to
  `undefined`.
- **The Fix**: Remove the curly braces for a standard declarative binding and
  add a local `qmldir`.

#### 4. The `PanelWindow is not creatable` Nag in [Bar.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Bar.qml)

- **The "Why"**: In Quickshell's internal type definition
  (`quickshell-window.qmltypes`), `PanelWindowInterface` is marked
  `isCreatable: false` because it is an abstract interface instantiated by the
  Wayland or X11 backend. The linter flags creating it directly as an error.
- **The Fix**: This is a known Quickshell false positive; silence it cleanly
  with an inline comment:
  ```qml
  // qmllint disable uncreatable-type
  PanelWindow { ... }
  ```

#### 5. Scope Nesting in [shell.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/shell.qml) vs [Bar.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Bar.qml)

- **The "Why"**: `Scope` in Quickshell is a non-visual `Reloadable` container
  designed to hoist background services, timers, and manage hot-reloads without
  duplicating them across monitors. Having `Scope { Bar {} }` in `shell.qml`
  while `Bar.qml` itself is also rooted in `Scope` creates redundant nested
  scopes.

---

### How to Fix the Files

#### 1. Add `qmldir` for Singleton Registration

Create a `qmldir` file in
`/home/jsimpson/Code/dotfiles/config/quickshell/qmldir` to inform `qmllint` and
the LSP about your singleton:

```text
singleton Time 1.0 Time.qml
```

#### 2. Clean Up [Time.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Time.qml)

Remove the unused `Quickshell.Io` import and fix the property binding:

```qml
pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string time: Qt.formatDateTime(clock.date, "ddd MMM d hh:mm")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
```

#### 3. Update [ClockWidget.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/ClockWidget.qml)

Give it a root ID for clean encapsulation:

```qml
import QtQuick

Text {
    id: root
    text: Time.time
    font.pointSize: 10
}
```

#### 4. Fix Delegate Scoping & Dispatch in [Workspaces.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Workspaces.qml)

Add `required property int index`, qualify child properties, remove unused
imports, and use standard Hyprland dispatch syntax (`workspace <id>`):

```qml
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
```

#### 5. Update [Bar.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Bar.qml)

Add the linter suppression comment and give `PanelWindow` an explicit ID:

```qml
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
```

---

### Suggested Directory Structure as You Expand

When adding more widgets and services, grouping components into subdirectories
keeps singletons and UI elements cleanly namespaced:

```text
config/quickshell/
├── shell.qml              # Root entry point
├── Bar.qml                # Screen variant bar definition
├── qmldir                 # Exposes local modules
├── widgets/               # UI components
│   ├── ClockWidget.qml
│   └── Workspaces.qml
└── services/              # Singletons / background services
    ├── qmldir             # Registers singletons for this sub-module
    └── Time.qml
```

Would you like me to apply these updates to your files and create the `qmldir`
directly in your configuration?The updates have been applied and verified
against both `qmllint` and the running Quickshell daemon.

### Changes Applied

1. **Created
   [qmldir](file:///home/jsimpson/Code/dotfiles/config/quickshell/qmldir)**
   - Explicitly registered all local components (`Bar`, `ClockWidget`,
     `Workspaces`) and declared `Time` as a `singleton`.
   - Completely silences the `missing-property` and
     `singleton not declared in qmldir` warnings from `qmllint` and `qmlls`.

2. **Fixed Scoping in
   [Workspaces.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Workspaces.qml)**
   - Added `required property int index` to the delegate
     [Rectangle](file:///home/jsimpson/Code/dotfiles/config/quickshell/Workspaces.qml#L13),
     resolving the runtime `ReferenceError: index is not defined`.
   - Added `id: wsRect` and qualified all child property lookups
     (`wsRect.workspaceId`, `wsRect.isActive`, `wsRect.hasWindows`), eliminating
     all unqualified access warnings.
   - Updated the click handler to use standard Hyprland dispatch syntax:
     `Hyprland.dispatch("workspace " + wsRect.workspaceId)`.
   - Removed unused `import Quickshell`.

3. **Fixed Property Binding in
   [Time.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Time.qml)**
   - Removed the block wrapper `{ ... }` around `Qt.formatDateTime(...)` so the
     property evaluates directly without returning `undefined`.
   - Cleaned up unused imports (`Quickshell.Io`).

4. **Suppressed C++ Interface Warning in
   [Bar.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/Bar.qml)**
   - Added `// qmllint disable uncreatable-type` above `PanelWindow` to suppress
     the false-positive warning caused by Quickshell's abstract C++ interface
     definition.
   - Assigned `id: barWindow` and qualified `screen: barWindow.modelData`.

5. **Updated
   [ClockWidget.qml](file:///home/jsimpson/Code/dotfiles/config/quickshell/ClockWidget.qml)**
   - Assigned `id: root` for explicit element scoping.

6. **Ignored Ephemeral `.qmlls.ini` in
   [.gitignore](file:///home/jsimpson/Code/dotfiles/.gitignore)**
   - Added `.qmlls.ini` so Quickshell's auto-generated VFS symlink isn't tracked
     in git.

---

### Verification

- **Linter**: `qmllint config/quickshell/*.qml` now passes with exit code `0`
  and **0 warnings / 0 errors**.
- **Runtime**: Quickshell reloaded cleanly with:
  ```text
  INFO: Reloading configuration...
  INFO: Configuration Loaded
  ```
