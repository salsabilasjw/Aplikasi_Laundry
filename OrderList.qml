import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var selectedOrder: null

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        Column {
            width: parent.width
            spacing: 8

            Text {
                text: "Order List"
                font.pixelSize: 32
                font.bold: true
                color: "#212121"
            }

            Text {
                text: "View and manage all laundry orders"
                font.pixelSize: 14
                color: "#616161"
            }
        }

        // Table Card
        Rectangle {
            width: parent.width
            height: 480
            color: "#FFFFFF"
            radius: 16
            border.color: "#E3F2FD"
            border.width: 1

            Column {
                anchors.fill: parent

                // Table Header
                Rectangle {
                    width: parent.width
                    height: 55
                    color: "#E3F2FD"
                    radius: 16
                    border.color: "#90CAF9"
                    border.width: 1

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 24
                        anchors.rightMargin: 24
                        spacing: 10

                        HeaderText { text: "Order ID";    width: 80 }
                        HeaderText { text: "Customer";    width: 130 }
                        HeaderText { text: "Service";     width: 100 }
                        HeaderText { text: "Sub Service"; width: 140 }
                        HeaderText { text: "Weight";      width: 80 }
                        HeaderText { text: "Total Price"; width: 110 }
                        HeaderText { text: "Status";      width: 110 }
                        HeaderText { text: "Actions";     width: 180 }
                    }
                }

                // Table Body
                ListView {
                    width: parent.width
                    height: parent.height - 55
                    clip: true
                    model: orderManager.orders

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 75
                        color: index % 2 === 0 ? "#FFFFFF" : "#FAFAFA"
                        border.color: "#E0E0E0"
                        border.width: 0.5

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 24
                            anchors.rightMargin: 24
                            spacing: 10

                            // Order ID
                            Text {
                                width: 80
                                text: "#" + modelData.id
                                font.pixelSize: 13
                                font.bold: true
                                font.family: "Courier"
                                color: "#1976D2"
                                verticalAlignment: Text.AlignVCenter
                                height: parent.height
                            }

                            // Customer Name
                            Text {
                                width: 130
                                text: modelData.customerName
                                font.pixelSize: 13
                                color: "#212121"
                                verticalAlignment: Text.AlignVCenter
                                height: parent.height
                                elide: Text.ElideRight
                            }

                            // Service Type
                            Row {
                                width: 100
                                height: parent.height
                                spacing: 8

                                Rectangle {
                                    width: 8
                                    height: 8
                                    radius: 4
                                    color: modelData.serviceType === "Express" ? "#FFA000" : "#1976D2"
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: modelData.serviceType
                                    font.pixelSize: 12
                                    color: "#424242"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            // Sub Service
                            Text {
                                width: 140
                                text: modelData.subService
                                font.pixelSize: 11
                                color: "#616161"
                                verticalAlignment: Text.AlignVCenter
                                height: parent.height
                                elide: Text.ElideRight
                            }

                            // Weight
                            Text {
                                width: 80
                                text: modelData.weight + " kg"
                                font.pixelSize: 13
                                color: "#424242"
                                verticalAlignment: Text.AlignVCenter
                                height: parent.height
                            }

                            // Total Price
                            Text {
                                width: 110
                                text: orderManager.formatRupiah(modelData.totalPrice)
                                font.pixelSize: 12
                                font.bold: true
                                color: "#388E3C"
                                verticalAlignment: Text.AlignVCenter
                                height: parent.height
                            }

                            // Status
                            Item {
                                width: 110
                                height: parent.height

                                Rectangle {
                                    width: modelData.status === "Processing" ? 95 : 80
                                    height: 28
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: modelData.status === "Processing" ? "#FFF9C4" : "#C8E6C9"
                                    border.color: modelData.status === "Processing" ? "#FFD54F" : "#A5D6A7"
                                    border.width: 1
                                    radius: 14

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.status
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: modelData.status === "Processing" ? "#F57C00" : "#388E3C"
                                    }
                                }
                            }

                            // Actions
                            Row {
                                width: 180
                                height: parent.height
                                spacing: 8

                                Button {
                                    width: 65
                                    height: 34
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Struk"
                                    font.pixelSize: 11

                                    background: Rectangle {
                                        gradient: Gradient {
                                            GradientStop { position: 0; color: "#42A5F5" }
                                            GradientStop { position: 1; color: "#1E88E5" }
                                        }
                                        radius: 8
                                    }

                                    contentItem: Text {
                                        text: parent.text
                                        color: "#FFFFFF"
                                        font: parent.font
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    onClicked: {
                                        selectedOrder = modelData;
                                        receiptPopup.open();
                                    }
                                }

                                Button {
                                    width: 65
                                    height: 34
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.status === "Processing" ? "Done" : "Reopen"
                                    font.pixelSize: 11

                                    background: Rectangle {
                                        gradient: Gradient {
                                            GradientStop {
                                                position: 0
                                                color: modelData.status === "Processing" ? "#66BB6A" : "#FFA726"
                                            }
                                            GradientStop {
                                                position: 1
                                                color: modelData.status === "Processing" ? "#43A047" : "#FB8C00"
                                            }
                                        }
                                        radius: 8
                                    }

                                    contentItem: Text {
                                        text: parent.text
                                        color: "#FFFFFF"
                                        font: parent.font
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    onClicked: {
                                        var newStatus = modelData.status === "Processing" ? "Done" : "Processing";
                                        orderManager.updateOrderStatus(modelData.id, newStatus);
                                    }
                                }
                            }
                        }
                    }

                    // Empty State
                    Text {
                        anchors.centerIn: parent
                        text: "No orders yet\nAdd your first order to get started"
                        font.pixelSize: 15
                        color: "#9E9E9E"
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 1.5
                        visible: orderManager.orders.length === 0
                    }
                }
            }
        }

        // Summary Footer
        Rectangle {
            width: parent.width
            height: 55
            color: "#E3F2FD"
            radius: 12
            border.color: "#90CAF9"
            border.width: 1
            visible: orderManager.orders.length > 0

            Row {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 60

                Text {
                    text: "Showing " + orderManager.orders.length + " order" + (orderManager.orders.length !== 1 ? "s" : "")
                    font.pixelSize: 13
                    color: "#0D47A1"
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item { width: parent.width - 500 }

                Text {
                    text: orderManager.pendingOrders + " Processing"
                    font.pixelSize: 13
                    color: "#1976D2"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: (orderManager.totalOrders - orderManager.pendingOrders) + " Completed"
                    font.pixelSize: 13
                    color: "#388E3C"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    // Receipt Popup
    Popup {
        id: receiptPopup
        anchors.centerIn: parent
        width: 480
        height: 750
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#FFFFFF"
            radius: 16
        }

        Receipt {
            anchors.fill: parent
            order: selectedOrder
            onCloseClicked: receiptPopup.close()
        }
    }

    component HeaderText: Text {
        font.pixelSize: 13
        font.bold: true
        color: "#424242"
        verticalAlignment: Text.AlignVCenter
        height: 55
    }
}