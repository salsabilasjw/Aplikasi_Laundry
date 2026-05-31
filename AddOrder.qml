import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property string afacadFlux: ""
    property string poppinsRegular: ""
    property string poppinsMedium: ""
    property string poppinsSemiBold: ""
    property string poppinsBold: ""

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        // Header
        Column {
            width: parent.width
            spacing: 8

            Text {
                text: "Add New Order"
                font.pixelSize: 32
                font.bold: true
                color: "#212121"
                font.family: afacadFlux
            }

            Text {
                text: "Create a new laundry order for your customer"
                font.pixelSize: 14
                color: "#616161"
            }
        }

        // Form Card
        Rectangle {
            width: Math.min(650, parent.width)
            implicitHeight: formContentColumn.implicitHeight + 40
            color: "#FFFFFF"
            radius: 16
            border.color: "#E3F2FD"
            border.width: 1

            Column {
                id: formContentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 20
                spacing: 14

                // Customer Name
                Column {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: "Customer Name"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#424242"
                        font.family: poppinsRegular
                    }

                    TextField {
                        id: customerNameField
                        width: parent.width
                        height: 40
                        placeholderText: "Enter customer name"
                        font.pixelSize: 14

                        background: Rectangle {
                            color: "#FFFFFF"
                            border.color: parent.activeFocus ? "#1976D2" : "#BDBDBD"
                            border.width: 2
                            radius: 10
                        }
                    }
                }

                // Weight
                Column {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: "Weight (kg)"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#424242"
                        font.family: poppinsBold
                    }

                    TextField {
                        id: weightField
                        width: parent.width
                        height: 40
                        placeholderText: "Enter weight in kg"
                        font.pixelSize: 14
                        validator: DoubleValidator { bottom: 0; decimals: 1 }

                        background: Rectangle {
                            color: "#FFFFFF"
                            border.color: parent.activeFocus ? "#1976D2" : "#BDBDBD"
                            border.width: 2
                            radius: 10
                        }
                    }
                }

                // Service Type
                Column {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: "Service Type"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#424242"
                        font.family: poppinsSemiBold
                    }

                    ComboBox {
                        id: serviceTypeCombo
                        width: parent.width
                        height: 40
                        model: ["Regular - Rp 10.000/kg", "Express - Rp 15.000/kg"]
                        font.pixelSize: 14

                        background: Rectangle {
                            color: "#FFFFFF"
                            border.color: parent.activeFocus ? "#1976D2" : "#BDBDBD"
                            border.width: 2
                            radius: 10
                        }
                    }
                }

                // Sub Service Type
                Column {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: "Sub Service Type"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#424242"
                        font.family: poppinsSemiBold
                    }

                    ComboBox {
                        id: subServiceCombo
                        width: parent.width
                        height: 40
                        model: orderManager.getSubServiceOptions()
                        font.pixelSize: 14

                        background: Rectangle {
                            color: "#FFFFFF"
                            border.color: parent.activeFocus ? "#1976D2" : "#BDBDBD"
                            border.width: 2
                            radius: 10
                        }
                    }
                }

                // Price Estimate
                Rectangle {
                    id: priceEstimateBox
                    width: parent.width
                    height: 90
                    color: "#E3F2FD"
                    border.color: "#90CAF9"
                    border.width: 1
                    radius: 12

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: "Estimated Total Price:"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#1E88E5"
                        }

                        Text {
                            text: {
                                var weight = weightField.text || "0";
                                var pricePerKg = serviceTypeCombo.currentIndex === 0 ? 10000 : 15000;
                                return weight + " kg × " + orderManager.formatRupiah(pricePerKg) + "/kg = " +
                                       orderManager.formatRupiah(parseFloat(weight) * pricePerKg);
                            }
                            font.pixelSize: 11
                            color: "#1976D2"
                        }

                        Text {
                            text: {
                                var subServicePrice = orderManager.getSubServicePrice(subServiceCombo.currentText);
                                var subServiceName = subServiceCombo.currentText.split(" (+")[0];
                                return subServiceName + " = +" + orderManager.formatRupiah(subServicePrice);
                            }
                            font.pixelSize: 11
                            color: "#1976D2"
                            visible: orderManager.getSubServicePrice(subServiceCombo.currentText) > 0
                        }
                    }

                    Text {
                        text: {
                            var weight = parseFloat(weightField.text) || 0;
                            var pricePerKg = serviceTypeCombo.currentIndex === 0 ? 10000 : 15000;
                            var subServicePrice = orderManager.getSubServicePrice(subServiceCombo.currentText);
                            var total = (weight * pricePerKg) + subServicePrice;
                            return orderManager.formatRupiah(total);
                        }
                        font.pixelSize: 20
                        font.bold: true
                        color: "#1976D2"
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Submit Button
                Button {
                    width: parent.width
                    height: 44
                    text: "Add Order"
                    font.pixelSize: 16
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
                        if (customerNameField.text.trim() === "") {
                            return;
                        }

                        var weight = parseFloat(weightField.text);
                        if (!weight || weight <= 0) {
                            return;
                        }

                        var serviceType = serviceTypeCombo.currentIndex === 0 ? "Regular" : "Express";
                        var subService = subServiceCombo.currentText;

                        orderManager.addOrder(
                            customerNameField.text.trim(),
                            weight,
                            serviceType,
                            subService
                        );

                        // Clear form
                        customerNameField.text = "";
                        weightField.text = "";
                        serviceTypeCombo.currentIndex = 0;
                        subServiceCombo.currentIndex = 0;

                        // Switch to order list
                        currentView = "orderList";
                    }
                }
            }
        }

        // Info Cards
        GridLayout {
            width: Math.min(650, parent.width)
            columns: 2
            columnSpacing: 16

            Rectangle {
                Layout.fillWidth: true
                height: 75
                color: "#E3F2FD"
                radius: 12
                border.color: "#90CAF9"
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Regular Service"
                        font.pixelSize: 11
                        color: "#616161"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "24-48 hours"
                        font.pixelSize: 15
                        font.bold: true
                        color: "#1976D2"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 75
                color: "#FFF9C4"
                radius: 12
                border.color: "#FFF59D"
                border.width: 1

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Express Service"
                        font.pixelSize: 11
                        color: "#616161"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "12-24 hours"
                        font.pixelSize: 15
                        font.bold: true
                        color: "#F57C00"
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}