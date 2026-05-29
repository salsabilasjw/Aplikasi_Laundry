import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Column {
        anchors.fill: parent
        spacing: 24

        // Header
        Column {
            width: parent.width
            spacing: 8

            Text {
                text: "Dashboard"
                font.pixelSize: 32
                font.bold: true
                color: "#212121"
            }

            Text {
                text: "Welcome to BubblyWash management system"
                font.pixelSize: 14
                color: "#616161"
            }
        }

        // Stats Cards
        GridLayout {
            width: parent.width
            columns: 3
            rowSpacing: 20
            columnSpacing: 20

            StatCard {
                Layout.fillWidth: true
                title: "Total Orders"
                value: orderManager.totalOrders.toString()
                bgColor: "#E3F2FD"
                iconColor: "#1976D2"
                iconText: "📦"
            }

            StatCard {
                Layout.fillWidth: true
                title: "Pending Orders"
                value: orderManager.pendingOrders.toString()
                bgColor: "#FFF9C4"
                iconColor: "#F57C00"
                iconText: "🕐"
            }

            StatCard {
                Layout.fillWidth: true
                title: "Total Revenue"
                value: orderManager.formatRupiah(orderManager.totalRevenue)
                bgColor: "#C8E6C9"
                iconColor: "#388E3C"
                iconText: "💵"
            }
        }

        // Quick Overview
        Rectangle {
            width: parent.width
            height: 180
            color: "#FFFFFF"
            radius: 16
            border.color: "#E3F2FD"
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: "Quick Overview"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#212121"
                }

                GridLayout {
                    width: parent.width
                    columns: 2
                    columnSpacing: 20

                    Rectangle {
                        Layout.fillWidth: true
                        height: 90
                        color: "#E3F2FD"
                        radius: 12
                        border.color: "#90CAF9"
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "Completion Rate"
                                font.pixelSize: 12
                                color: "#616161"
                            }

                            Row {
                                spacing: 8

                                Text {
                                    text: orderManager.totalOrders > 0 ?
                                          Math.round(((orderManager.totalOrders - orderManager.pendingOrders) / orderManager.totalOrders) * 100) + "%" : "0%"
                                    font.pixelSize: 28
                                    font.bold: true
                                    color: "#1976D2"
                                }

                                Text {
                                    text: "of orders completed"
                                    font.pixelSize: 11
                                    color: "#757575"
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 6
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 90
                        color: "#C8E6C9"
                        radius: 12
                        border.color: "#A5D6A7"
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "Average Order Value"
                                font.pixelSize: 12
                                color: "#616161"
                            }

                            Row {
                                spacing: 8

                                Text {
                                    text: orderManager.totalOrders > 0 ?
                                          orderManager.formatRupiah(Math.round(orderManager.totalRevenue / orderManager.totalOrders)) : "Rp 0"
                                    font.pixelSize: 28
                                    font.bold: true
                                    color: "#388E3C"
                                }

                                Text {
                                    text: "per order"
                                    font.pixelSize: 11
                                    color: "#757575"
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 6
                                }
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    component StatCard: Rectangle {
            id: card
            property string title: ""
            property string value: ""
            property color bgColor: "#E3F2FD"
            property color iconColor: "#1976D2"
            property string iconText: ""

            height: 140
            color: card.bgColor
            radius: 16
            border.color: Qt.darker(card.bgColor, 1.05)
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Rectangle {
                    width: 44
                    height: 44
                    radius: 10
                    color: "#FFFFFF"

                    Text {
                        anchors.centerIn: parent
                        text: card.iconText
                        font.pixelSize: 22
                    }
                }

                Column {
                    width: parent.width
                    spacing: 4

                    Text {
                        text: card.title
                        font.family: "Poppins"
                        font.pixelSize: 14
                        color: "#616161"
                    }

                    Text {
                        text: card.value
                        font.family: "Poppins"
                        font.pixelSize: 28
                        font.bold: true
                        color: card.iconColor
                    }
                }
            }
        }
    }

