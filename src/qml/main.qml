import QtQuick 6.5
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell

WaylandCompositor {
    id: comp
    // Optional: set a custom socket name, otherwise "wayland-0"
    // socketName: "wayland-1"

    // 1) Output (your “screen”)
    WaylandOutput {
        id: output
        sizeFollowsWindow: true
        window: Window {
            id: win
            width: 1280
            height: 800
            visible: true
            color: "#101018"  // scene background

            // A simple layer where we place client windows
            Item {
                id: clientLayer
                anchors.fill: parent
                focus: true
            }

            // Optional: a top panel or wallpaper QML here…
        }
    }

    // 2) Seat/input (keyboard, pointer, touch)
    WaylandSeat { id: seat }

    // 3) xdg-shell: modern desktop surfaces
    XdgShell {
        // A new 'xdg_surface' appeared (toplevel or popup)
        onToplevelCreated: function(toplevel, xdgSurface) {
            // Display the surface with a ShellSurfaceItem
            var item = shellItemComponent.createObject(output.window.contentItem, {
                "shellSurface": xdgSurface,
                "z": 10
            })
            item.anchors.centerIn = output.window.contentItem
            xdgSurface.sendConfigure() // initial configure (size/state)
        }
    }

    // Reusable visual for a client window
    Component {
        id: shellItemComponent
        ShellSurfaceItem {
            id: s
            anchors.margins: 8
            width: Math.min(900, parent.width - 64)
            height: Math.min(600, parent.height - 64)
            focus: true

            // Allow click-to-raise, simple drag
            property point pressPos
            MouseArea {
                anchors.fill: parent
                onPressed: { s.pressPos = Qt.point(mouse.x, mouse.y); s.forceActiveFocus() }
                onPositionChanged: if (mouse.buttons & Qt.LeftButton) {
                    s.x += mouse.x - s.pressPos.x
                    s.y += mouse.y - s.pressPos.y
                }
            }
        }
    }
}
