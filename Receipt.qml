import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: receiptRoot
    property var order: null
    signal closeClicked()

    Column {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 10

        // Close Button
        Button {
            anchors.right: parent.right
            width: 40
            height: 40
            text: "×"
            font.pixelSize: 28

            background: Rectangle {
                color: parent.hovered ? "#F5F5F5" : "transparent"
                radius: 8
            }

            contentItem: Text {
                text: parent.text
                color: "#757575"
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: closeClicked()
        }

        // Header
        Column {
            width: parent.width
            spacing: 10

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Image {
                    width: 80
                    height: 80
                    source: "images/logo.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "BubblyWash"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#0D47A1"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Laundry Management System"
                font.pixelSize: 13
                color: "#616161"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Jl. Universitas No.9 Pintu 1 USU, Medan"
                font.pixelSize: 11
                color: "#757575"
            }

            Rectangle {
                width: parent.width
                height: 2
                color: "#E0E0E0"
            }
        }

        // Order Number
        Rectangle {
            width: parent.width
            height: 65
            color: "#E3F2FD"
            radius: 10

            Column {
                anchors.centerIn: parent
                spacing: 4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "No. Order"
                    font.pixelSize: 11
                    color: "#616161"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "#" + (order ? order.id : "")
                    font.pixelSize: 22
                    font.bold: true
                    font.family: "Courier"
                    color: "#1976D2"
                }
            }
        }

        // Details
        Column {
            width: parent.width
            spacing: 0

            DetailRow { label: "Nama Customer"; value: order ? order.customerName : "" }
            DetailRow { label: "Berat";         value: order ? order.weight + " kg" : "" }
            DetailRow { label: "Jenis Layanan"; value: order ? order.serviceType : "" }
            DetailRow { label: "Sub Layanan";   value: order ? order.subService : "" }
            DetailRow {
                label: "Harga per kg"
                value: order ? orderManager.formatRupiah(order.serviceType === "Regular" ? 10000 : 15000) : ""
            }
            DetailRow {
                label: "Biaya Sub Layanan"
                value: order ? orderManager.formatRupiah(order.subServicePrice) : ""
                visible: order && order.subServicePrice > 0
            }
            DetailRow { label: "Tanggal & Jam"; value: order ? order.createdAt : ""; isLast: true }
        }

        // Total Breakdown
        Rectangle {
            width: parent.width
            height: 95
            color: "#C8E6C9"
            radius: 12
            border.color: "#81C784"
            border.width: 2

            Column {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 6

                // Biaya Cuci
                Row {
                    width: parent.width

                    Text {
                        text: "Biaya Cuci (" + (order ? order.weight : 0) + " kg)"
                        font.pixelSize: 12
                        color: "#616161"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item { width: parent.width - 300 }

                    Text {
                        text: order ? orderManager.formatRupiah(order.weight * (order.serviceType === "Regular" ? 10000 : 15000)) : ""
                        font.pixelSize: 12
                        color: "#424242"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Biaya Sub Service (jika ada)
                Row {
                    width: parent.width
                    visible: order && order.subServicePrice > 0

                    Text {
                        text: "Biaya " + (order ? order.subService : "")
                        font.pixelSize: 12
                        color: "#616161"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item { width: parent.width - 300 }

                    Text {
                        text: order ? "+" + orderManager.formatRupiah(order.subServicePrice) : ""
                        font.pixelSize: 12
                        color: "#424242"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#81C784"
                }

                // Total
                Row {
                    width: parent.width

                    Text {
                        text: "Total Harga"
                        font.pixelSize: 17
                        font.bold: true
                        color: "#424242"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item { width: parent.width - 300 }

                    Text {
                        text: order ? orderManager.formatRupiah(order.totalPrice) : ""
                        font.pixelSize: 26
                        font.bold: true
                        color: "#388E3C"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        // Status
        Rectangle {
            width: 160
            height: 38
            anchors.horizontalCenter: parent.horizontalCenter
            color: order && order.status === "Processing" ? "#FFF9C4" : "#C8E6C9"
            border.color: order && order.status === "Processing" ? "#FFD54F" : "#A5D6A7"
            border.width: 1
            radius: 19

            Text {
                anchors.centerIn: parent
                text: "Status: " + (order ? order.status : "")
                font.pixelSize: 13
                font.bold: true
                color: order && order.status === "Processing" ? "#F57C00" : "#388E3C"
            }
        }

        // Footer
        Column {
            width: parent.width
            spacing: 6

            Rectangle {
                width: parent.width
                height: 2
                color: "#E0E0E0"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Terima kasih atas kepercayaan Anda!"
                font.pixelSize: 11
                color: "#757575"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Simpan struk ini sebagai bukti transaksi"
                font.pixelSize: 11
                color: "#757575"
            }
        }

        // Print Button
        Button {
            width: parent.width
            height: 52
            text: "🖨️  Cetak Struk"
            font.pixelSize: 15
            font.bold: true

            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0; color: "#42A5F5" }
                    GradientStop { position: 1; color: "#1E88E5" }
                }
                radius: 12
            }

            contentItem: Text {
                text: parent.text
                color: "#FFFFFF"
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                console.log("Print receipt for order:", order.id);
            }
        }
    } // Penutup Column Utama

    // Component DetailRow diletakkan di level terluar (Root Level)
    component DetailRow: Rectangle {
        property string label: ""
        property string value: ""
        property bool isLast: false

        width: parent.width
        height: 42
        color: "transparent"

        Item {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4

            Text {
                text: label
                font.pixelSize: 13
                color: "#616161"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            Text {
                text: value
                font.pixelSize: 13
                font.bold: true
                color: "#212121"
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                width: 180
                horizontalAlignment: Text.AlignRight
                anchors.right: parent.right
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#E0E0E0"
            visible: !isLast
        }
    }
} // Penutup Item Root Utama