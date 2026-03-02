import QtQuick 6.5
import QtQuick.Window 6.5
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell

WaylandCompositor {
    id: comp

    WaylandOutput {
        id: output
        sizeFollowsWindow: true
        window: Window {
            id: win
            width: 1280
            height: 800
            visible: true
            color: "#101018"

            Item {
                id: clientLayer
                anchors.fill: parent
                focus: true
            }
        }
    }

    WaylandSeat {
        id: seat
        compositor: comp
    }

    XdgShell {
        onToplevelCreated: function(toplevel, xdgSurface) {
            shellItemComponent.createObject(clientLayer, {
                "toplevel": toplevel
            })
            toplevel.sendConfigure(Qt.size(0, 0), [])
        }
    }

    Component {
        id: shellItemComponent

        Item {
            id: wrapper
            x: (clientLayer.width  - width)  / 2
            y: (clientLayer.height - height) / 2
            width:  Math.min(900, clientLayer.width  - 64)
            height: Math.min(600, clientLayer.height - 64) + titleBar.height

            property var toplevel   // set via createObject

            // ── Title bar ──────────────────────────────────────────
            Rectangle {
                id: titleBar
                width: parent.width
                height: 28
                color: "#2a2a3a"
                radius: 4

                Text {
                    anchors.centerIn: parent
                    text: wrapper.toplevel ? wrapper.toplevel.title : ""
                    color: "#ccccdd"
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    property point pressPos
                    onPressed:  pressPos = Qt.point(mouse.x, mouse.y)
                    onPositionChanged: if (mouse.buttons & Qt.LeftButton) {
                        wrapper.x += mouse.x - pressPos.x
                        wrapper.y += mouse.y - pressPos.y
                    }
                    // Click-to-raise
                    onClicked: wrapper.z = ++clientLayer.highestZ
                }
            }

            // ── Client surface ─────────────────────────────────────
            ShellSurfaceItem {
                id: surfaceItem
                anchors.top: titleBar.bottom
                width:  parent.width
                height: parent.height - titleBar.height
                shellSurface: wrapper.toplevel
                focus: true

                onSurfaceDestroyed: wrapper.destroy()
            }
        }
    }

    // Track z-ordering
    property int highestZ: 0
}
