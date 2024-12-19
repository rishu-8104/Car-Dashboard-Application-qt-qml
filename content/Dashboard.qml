import QtQuick 2.0

Item {
    id: id_dashboard
    width: 720
        height: 480

        // Gradient background from white to grey to black
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: 'black' }
                GradientStop { position: 0.5; color: 'grey' }
                GradientStop { position: 1.0; color: "#f9c919" }
            }
        }

    //to creating data for demonstration purpose
    property int count: 0
    property int randNum: 0
    Timer {
        id: id_timer
        repeat: true
        interval: 1000
        running: false

        onTriggered: {
            if(id_gear.value == 6) id_gear.value = 0;
            else id_gear.value++;

            if(count % 5 == 0){
                if(id_speed.value == 0) id_speed.value = 280
                else id_speed.value = 0

                if(id_info.fuelValue == 0) id_info.fuelValue = 4
                else id_info.fuelValue = 0
            }
            count++;

            if(count % 2 == 0){
                id_turnLeft.isActive = true
                id_turnRight.isActive = false
            }else{
                id_turnLeft.isActive = false
                id_turnRight.isActive = true
            }
        }
    }

    Rectangle {
        id: id_speedArea


        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width * 0.4
        height: width
        color: "black"
        radius: width/2
        z: 1


        Speed {
            id: id_speed
            anchors.fill: id_speedArea
            anchors.margins: id_speedArea.width * 0.025
        }
    }

    Rectangle {
        id: id_gearArea

        anchors {
            bottom: id_speedArea.bottom
        }
        x: parent.width / 20
        width: parent.width * 0.35
        height: width
        color: "black"
        radius: width/2

        Gear {
            id: id_gear
            anchors.fill: id_gearArea
            anchors.margins: id_gearArea.width * 0.025
        }
    }

    Rectangle {
        id: id_infoArea

        anchors {
            bottom: id_speedArea.bottom
        }
        x: parent.width - parent.width / 2.5
        width: parent.width * 0.35
        height: width
        color: "black"
        radius: width/2

        Info {
            id: id_info
            anchors.fill: id_infoArea
            anchors.margins: id_infoArea.width * 0.025
        }
    }

    Rectangle {

        anchors {
            bottom: id_speedArea.bottom
            left: id_gearArea.horizontalCenter
            right: id_infoArea.horizontalCenter
        }
        height: id_gearArea.width / 2
        color: "black"
        z: -1
    }

    Turn {
        id: id_turnLeft

        anchors {
            right: id_gearArea.right
            rightMargin: id_gearArea.height * 0.04
            bottom: id_gearArea.bottom
            bottomMargin: id_gearArea.height * 0.01
        }
        width: id_gearArea.width / 5.5
        height: id_gearArea.height / 8.2

        isActive: false
    }

    Turn {
        id: id_turnRight

        anchors {
            left: id_infoArea.left
            leftMargin: id_infoArea.height * 0.04
            bottom: id_infoArea.bottom
            bottomMargin: id_infoArea.height * 0.01
        }
        width: id_infoArea.width / 5.5
        height: id_infoArea.height / 8.2
        transformOrigin: Item.Center
        rotation: 180

        isActive: true
    }


    // Control Panel Area
    Rectangle {
                id: id_controlPanelBorder
                width: id_controlPanel.width + 20 // 5 pixels border on each side
                height: id_controlPanel.height + 20 // 5 pixels border on each side
                color: "#11546a"
                anchors.centerIn: id_controlPanel
                z: -0 // Ensure it's drawn behind the control panel
            }
    Rectangle {
        id: id_controlPanel
        width: parent.width
        height: parent.height * 0.2
        color: "#929292"
        anchors.bottom: parent.bottom
        z: 0 // Ensure control panel is above the border

        // Gear Selection Label
        Text {
            id: gearSelectionLabel
            text: "Select Gear"
            color: "white"
            font.pixelSize: 18
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        property int firstGearButtonX: gearSelectionLabel.x + gearSelectionLabel.width + 20
        property int gearButtonY: gearSelectionLabel.y
        Rectangle {
            id: id_automaticButton
            width: 100
            height: 40
            color: id_timer.running ? "orange" : "lightgrey" // Color indicates if the timer is running
            radius: 20
            anchors.verticalCenter: id_speedToggleButton.verticalCenter
            anchors.right: id_fuelButton.left // Place it next to the Fuel Toggle Button for consistency
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 10

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    id_timer.running = !id_timer.running; // Toggle the running state of the timer
                }
            }

            Text {
                text: id_timer.running ? "Stop" : "Automatic" // Text changes based on the timer's state
                anchors.centerIn: parent
                color: "black"
            }
        }
        Repeater {
            model: 7 // 0 to 6 gears
            delegate: Rectangle {
                width: 40
                height: 40
                color: model.index === id_gear.value ? "orange" : "white"
                border.color: "white"
                radius: 20
                x: id_controlPanel.firstGearButtonX + (50 * index) // 50 includes width of the button + 10px margin
                y: id_controlPanel.gearButtonY

                MouseArea {
                    anchors.fill: parent
                    onClicked: id_gear.value = model.index
                }

                Text {
                    text: model.index.toString()
                    anchors.centerIn: parent
                    color: "black"
                }
            }
        }

        // Speed Toggle Button
        Rectangle {
            id: id_speedToggleButton
            width: 100
            height: 40
            color: id_speed.value > 0 ? "orange" : "lightgrey"
            anchors.verticalCenter: gearSelectionLabel.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 400
            anchors.top: parent.top
            anchors.topMargin: 10


            radius: 20

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    id_speed.value = id_speed.value > 0 ? 0 : 280;
                }
            }

            Text {
                text: "Toggle Speed"
                anchors.centerIn: parent
                color: "black"
            }
        }

        // Fuel Toggle Button - Placed next to the Speed Toggle Button
        Rectangle {
            id: id_fuelButton
            width: 100
            height: 40
            color: id_info.fuelValue > 0 ? "orange" : "lightgrey"
            anchors.verticalCenter: id_speedToggleButton.verticalCenter
            anchors.right: id_speedToggleButton.left
            anchors.rightMargin: 100
            anchors.top: parent.top
            anchors.topMargin: 10
            radius: 20

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    id_info.fuelValue = id_info.fuelValue === 0 ? 4 : 0;
                }
            }

            Text {
                text: "Fuel Toggle"
                anchors.centerIn: parent
                color: "black"
            }
        }

        // Indicator Controls Label
        Text {
            id: indicatorControlsLabel
            text: "Control Indicator"
            color: "white"
            font.pixelSize: 18
            anchors.left: parent.left
            anchors.top: gearSelectionLabel.bottom
            anchors.topMargin: 40
            anchors.leftMargin: 20

        }

        // Left Indicator Button
        Rectangle {
            id: id_leftIndicatorButton
            width: 60
            height: 40
            color: id_turnLeft.isActive ? "orange" : "lightgrey"
            radius: 20
            anchors.left: indicatorControlsLabel.right
            anchors.leftMargin: 60
            anchors.verticalCenter: indicatorControlsLabel.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    id_turnLeft.isActive = !id_turnLeft.isActive;
                    if(id_turnLeft.isActive) {
                        id_turnRight.isActive = false; // Turn off right indicator when left is turned on
                    }
                }
            }

            Text {
                text: "Left"
                anchors.centerIn: parent
                color: "black"
            }
        }

        // Right Indicator Button - Placed next to the Left Indicator Button
        Rectangle {
            id: id_rightIndicatorButton
            width: 60
            height: 40
            color: id_turnRight.isActive ? "orange" : "lightgrey"
            radius: 20
            anchors.left: id_leftIndicatorButton.right
            anchors.leftMargin: 20
            anchors.verticalCenter: id_leftIndicatorButton.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    id_turnRight.isActive = !id_turnRight.isActive;
                    if(id_turnRight.isActive) {
                        id_turnLeft.isActive = false; // Turn off left indicator when right is turned on
                    }
                }
            }

            Text {
                text: "Right"
                anchors.centerIn: parent
                color: "black"
            }
        }
    }

}
