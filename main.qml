import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1200
    height: 800
    title: "BubblyWash - Laundry Management"

    property string currentView: "dashboard"

    // Load Custom Fonts
    FontLoader { id: afacadFlux; source: "qrc:/BubblyWash/fonts/AfacadFlux-Bold.ttf" }
    FontLoader { id: poppinsRegular; source: "qrc:/BubblyWash/fonts/Poppins-Regular.ttf" }
    FontLoader { id: poppinsMedium; source: "qrc:/BubblyWash/fonts/Poppins-Medium.ttf" }
    FontLoader { id: poppinsSemiBold; source: "qrc:/BubblyWash/fonts/Poppins-SemiBold.ttf" }
    FontLoader { id: poppinsBold; source: "qrc:/BubblyWash/fonts/Poppins-Bold.ttf" }

    // Toast Notification
    Rectangle {
        id: toast
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        width: 350
        height: 60
        radius: 12
        color: "#FFFFFF"
        visible: false
        z: 1000

        // Shadow effect
        layer.enabled: true
        layer.effect: ShaderEffect {
            property color shadowColor: "#40000000"
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp vec4 shadowColor;
                uniform lowp float qt_Opacity;
                void main() {
                    lowp vec4 p = texture2D(source, qt_TexCoord0);
                    gl_FragColor = mix(shadowColor, p, p.a) * qt_Opacity;
                }
            "
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: parent.radius
            color: "transparent"
            border.color: "#66BB6A"
            border.width: 2
            z: -1
        }

        Row {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "✓"
                font.pixelSize: 24
                font.bold: true
                color: "#66BB6A"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: toastText
                font.pixelSize: 14
                font.family: poppinsRegular.name
                color: "#212121"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        function show(message) {
            toastText.text = message
            toast.visible = true
            toast.opacity = 0
            fadeIn.start()
            toastTimer.start()
        }

        NumberAnimation {
            id: fadeIn
            target: toast
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: fadeOut
            target: toast
            property: "opacity"
            to: 0
            duration: 300
            easing.type: Easing.InCubic
            onFinished: toast.visible = false
        }

        Timer {
            id: toastTimer
            interval: 3000
            onTriggered: fadeOut.start()
        }
    }

    Connections {
        target: orderManager
        function onOrderAdded(message) {
            toast.show(message)
        }
    }

    // Background gradient (from-blue-50 via-white to-blue-50)
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#EFF6FF" }   // from-blue-50
            GradientStop { position: 0.5; color: "#FFFFFF" }   // via-white
            GradientStop { position: 1.0; color: "#EFF6FF" }   // to-blue-50
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar (w-64 = 256px)
        Rectangle {
            id: sidebar
            Layout.preferredWidth: 256
            Layout.fillHeight: true
            color: "#FFFFFF"

            // Shadow effect (shadow-lg)
            layer.enabled: true
            layer.effect: ShaderEffect {
                property color shadowColor: "#10000000"
            }

            // Border right (border-r border-blue-100)
            Rectangle {
                anchors.right: parent.right
                width: 1
                height: parent.height
                color: "#DBEAFE"  // blue-100
            }

            Column {
                anchors.fill: parent
                spacing: 0

                // Logo Section (p-6 border-b)
                Rectangle {
                    width: parent.width
                    height: 100  // Adjusted for padding
                    color: "#FFFFFF"

                    // Border bottom
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: "#DBEAFE"
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 12  // gap-3

                        // Logo dengan bubble effect
                        Item {
                            width: 48
                            height: 48

                            // Main circle (w-12 h-12)
                            Rectangle {
                                width: 48
                                height: 48
                                radius: 24
                                gradient: Gradient {
                                    GradientStop { position: 0; color: "#60A5FA" }  // from-blue-400
                                    GradientStop { position: 1; color: "#2563EB" }  // to-blue-600
                                }

                                // Shadow-lg
                                layer.enabled: true

                                // Inner circle (w-8 h-8 bg-white/30)
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 32
                                    height: 32
                                    radius: 16
                                    color: "#FFFFFF"
                                    opacity: 0.3

                                    // Innermost circle (w-4 h-4 bg-white/40)
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 16
                                        height: 16
                                        radius: 8
                                        color: "#FFFFFF"
                                        opacity: 0.4
                                    }
                                }
                            }

                            // Top-right bubble (-top-1 -right-1 w-5 h-5)
                            Rectangle {
                                x: 28
                                y: -4
                                width: 20
                                height: 20
                                radius: 10
                                color: "#93C5FD"  // blue-300
                                opacity: 0.6
                            }

                            // Left bubble (top-2 -left-1 w-4 h-4)
                            Rectangle {
                                x: -4
                                y: 8
                                width: 16
                                height: 16
                                radius: 8
                                color: "#BFDBFE"  // blue-200
                                opacity: 0.4
                            }
                        }

                        Column {
                            spacing: 0
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "BubblyWash"
                                font.pixelSize: 20  // text-xl
                                font.family: afacadFlux.name
                                font.bold: true
                                color: "#1E3A8A"  // text-blue-900
                            }

                            Text {
                                text: "Laundry Management"
                                font.pixelSize: 12  // text-xs
                                font.family: poppinsRegular.name
                                color: "#1D4ED8"  // text-blue-700
                            }
                        }
                    }
                }

                // Navigation (flex-1 p-4)
                Column {
                    width: parent.width
                    topPadding: 16
                    leftPadding: 16
                    rightPadding: 16
                    spacing: 8  // space-y-2

                    NavButton {
                        width: parent.width - 32
                        text: "Dashboard"
                        iconCode: "\ue871"  // Material icon equivalent
                        isActive: currentView === "dashboard"
                        onClicked: currentView = "dashboard"
                    }

                    NavButton {
                        width: parent.width - 32
                        text: "Add Order"
                        iconCode: "+"
                        isActive: currentView === "addOrder"
                        onClicked: currentView = "addOrder"
                    }

                    NavButton {
                        width: parent.width - 32
                        text: "Order List"
                        iconCode: "≡"
                        isActive: currentView === "orderList"
                        onClicked: currentView = "orderList"
                    }
                }

                Item { height: parent.height }

                // Footer spacer
                Rectangle {
                    width: parent.width
                    height: 60
                    color: "transparent"

                    Rectangle {
                        anchors.top: parent.top
                        width: parent.width
                        height: 1
                        color: "#DBEAFE"
                    }
                }
            }
        }

        // Main Content (flex-1 overflow-auto)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                anchors.fill: parent
                anchors.margins: 32  // p-8
                source: {
                    if (currentView === "dashboard") return "qrc:/BubblyWash/Dashboard.qml"
                    if (currentView === "addOrder") return "qrc:/BubblyWash/AddOrder.qml"
                    if (currentView === "orderList") return "qrc:/BubblyWash/OrderList.qml"
                    return ""
                }

                onLoaded: {
                    // Pass font families to loaded component
                    if (item) {
                        item.afacadFlux = afacadFlux.name
                        item.poppinsRegular = poppinsRegular.name
                        item.poppinsMedium = poppinsMedium.name
                        item.poppinsSemiBold = poppinsSemiBold.name
                        item.poppinsBold = poppinsBold.name
                    }
                }
            }
        }
    }

    // Navigation Button Component
    component NavButton: Button {
        property bool isActive: false
        property string iconCode: ""

        height: 48  // py-3 (12px top + 12px bottom + content)

        background: Rectangle {
            radius: 12  // rounded-xl
            color: "transparent"

            // Gradient background when active
            Rectangle {
                anchors.fill: parent
                radius: 12
                visible: parent.parent.isActive
                gradient: Gradient {
                    GradientStop { position: 0; color: "#3B82F6" }  // from-blue-500
                    GradientStop { position: 1; color: "#2563EB" }  // to-blue-600
                }

                // Shadow when active (shadow-lg shadow-blue-200)
                layer.enabled: true
            }

            // Hover state (hover:bg-blue-50)
            Rectangle {
                anchors.fill: parent
                radius: 12
                color: "#EFF6FF"
                visible: !parent.parent.isActive && parent.parent.hovered
            }

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
        }

        contentItem: Row {
            spacing: 12  // gap-3
            leftPadding: 16  // px-4

            Text {
                text: parent.parent.iconCode
                font.pixelSize: 20
                color: parent.parent.isActive ? "#FFFFFF" : "#616161"
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Text {
                text: parent.parent.text
                color: parent.parent.isActive ? "#FFFFFF" : "#4B5563"  // text-gray-600
                font.pixelSize: 14
                font.family: afacadFlux.name
                font.weight: parent.parent.isActive ? Font.Bold : Font.Medium
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }  // transition-all
                }
            }
        }

        // Hover color change for text (hover:text-blue-700)
        states: State {
            name: "hovered"
            when: hovered && !isActive
            PropertyChanges {
                target: contentItem.children[1]
                color: "#1D4ED8"
            }
        }
    }
}