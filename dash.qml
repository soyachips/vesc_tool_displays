/*
    Copyright 2018 - 2021 Benjamin Vedder	benjamin@vedder.se

    This file is part of VESC Tool.

    VESC Tool is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    VESC Tool is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.5
import QtQml 2.7
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

import Vedder.vesc.vescinterface 1.0
import Vedder.vesc.utility 1.0
import Vedder.vesc.commands 1.0
import Vedder.vesc.configparams 1.0

Item {
    id: rtData
    property var dialogParent: ApplicationWindow.overlay
    anchors.fill: parent
    property alias updateData: commandsUpdate.enabled    

    property Commands mCommands: VescIf.commands()
    property ConfigParams mMcConf: VescIf.mcConfig()
    property int odometerValue: 0
    property double efficiency_lpf: 0
    property bool isHorizontal: rtData.width > rtData.height

    property int gaugeSize: (isHorizontal ? Math.min((height)/1.25, width / 2.5 - 20) :
                                            Math.min(width / 1.37, (height) / 2.4 - 10 ))
    property int gaugeSize2: gaugeSize * 0.55
    
    Component.onCompleted: {
        mCommands.emitEmptySetupValues()
        
        // from RtData.qml
        mCommands.emitEmptyValues()
    }

    // Make background slightly darker
    Rectangle {
        anchors.fill: parent
        color: "#202020"
    }

    GridLayout {
        anchors.fill: parent
        columns: isHorizontal ? 3 : 1
        columnSpacing: 25
        rowSpacing: 0
        
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: gaugeSize + 40
            color: "transparent"
            Layout.rowSpan: isHorizontal ? 1 : 1
            

                CustomGauge {
                id: speedGauge
                width:parent.height
                height:parent.height
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: isHorizontal ? (width/4 - gaugeSize2)/2 - 50 : 0
                minimumValue: 0
                maximumValue: 150
                minAngle: -230
                maxAngle: 50
                labelStep: maximumValue > 60 ? 20 : 10
                value: 0
                unitText: VescIf.useImperialUnits() ? "mph" : "km/h"
                typeText: "Speed"

                Image {
                    anchors.centerIn: parent
                    antialiasing: true
                    opacity: 0.4
                    height: parent.height*0.05
                    fillMode: Image.PreserveAspectFit
                    source: {source = "qrc" + Utility.getThemePath() + "icons/vesc-96.png"}
                    anchors.horizontalCenterOffset: (gaugeSize)/3.25 + gaugeSize2/2 -10
                    anchors.verticalCenterOffset: -0.8*(gaugeSize)/2 - 30
                }

                CustomGauge {
                    id: currentGauge
                    width:gaugeSize2 * 1.7
                    height:gaugeSize2 * 1.7
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: parent.width/4 + width/2 +20
                    minimumValue: -60
                    maximumValue: 60
                    value: 50
                    labelStep: maximumValue > 60 ? 20 : 10
                    nibColor: {nibColor = Utility.getAppHexColor("tertiary1")}
                    unitText: "A"
                    typeText: "Current"
                    minAngle: -135
                    maxAngle: 135
                    visible: isHorizontal ? true : false
                }
            }
        }

        // SoC bar chart
        Item {
            
            width: 24
            height: 272
            visible: isHorizontal ? true : false
            
            Rectangle {
                width: 24
                height: 272
                color: "transparent"
                border.color: "#454545"
                border.width: 3
            }

            Rectangle {
                id: batteryBar
                gradient: Gradient { // This sets a vertical gradient fill
                    GradientStop { position: 0.0; color: "#80d0ef" }
                    GradientStop { position: 1.0; color: "#0086b1" }
                }
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                width: 12
                height: 260
            }
            
            // Vertical separators
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 32
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 58
                anchors.horizontalCenter: parent.horizontalCenter
            }Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 84
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 110
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 136
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 162
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 188
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 214
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 12
                height: 2
                color: "#222222"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 240
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Text on Right
        Rectangle {
            id: textRect
            color: "transparent"
            Layout.preferredWidth: 200
            Layout.preferredHeight:  270
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: isHorizontal ? 290 : 10
            anchors.verticalCenterOffset: isHorizontal ? 0 : 170
            
            Text {
                id: textLabels
                color: "#909090"
                text:
                "BATTERY" + "\n" +
                "RANGE" + "\n" +
                "CONSUMPTION" + "\n" +
                "TEMPS (MOS/MOTOR)"
                font.pixelSize: 14
                lineHeight: 4.2
            }
          
            Text {
                id: batteryTextValues
                color: "#DDDDDD"
                text: VescIf.getConnectedPortName()
                font.pixelSize: 36
                lineHeight: 1.7
                verticalAlignment: Text.AlignVCenter
            }          
            Text {
                id: rangeTextValue
                color: "#DDDDDD"
                text: VescIf.getConnectedPortName()
                font.pixelSize: 36
                lineHeight: 1.66
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                id: efficiencyTextValue
                color: "#DDDDDD"
                text: VescIf.getConnectedPortName()
                font.pixelSize: 36
                lineHeight: 1.67
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                id: tempTextValue
                color: "#DDDDDD"
                text: VescIf.getConnectedPortName()
                font.pixelSize: 36
                lineHeight: 1.67
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    
    Timer {
        running: true
        repeat: true
        interval: 100
                
        onTriggered: {
            mCommands.getValues()
            mCommands.getValuesSetup()
        }
    }

    Connections {
        id: commandsUpdate
        target: mCommands

        property string lastFault: ""

        function onValuesSetupReceived(values, mask) {

            currentGauge.maximumValue = 400
            currentGauge.minimumValue = -50
            currentGauge.labelStep = 50
            currentGauge.value = values.current_in
            
            // set height of battery SoC bar
            batteryBar.height = values.battery_level * 260

            var useImperial = VescIf.useImperialUnits()
            //var useImperial = true
            var useNegativeSpeedValues = VescIf.speedGaugeUseNegativeValues()

            var fl = mMcConf.getParamDouble("foc_motor_flux_linkage")
            var rpmMax = (values.v_in * 60.0) / (Math.sqrt(3.0) * 2.0 * Math.PI * fl)
            var speedFact = ((mMcConf.getParamInt("si_motor_poles") / 2.0) * 60.0 *
                             mMcConf.getParamDouble("si_gear_ratio")) /
                    (mMcConf.getParamDouble("si_wheel_diameter") * Math.PI)

            if (speedFact < 1e-3) {
                speedFact = 1e-3
            }

            var speedMax = 3.6 * rpmMax / speedFact
            var impFact = useImperial ? 0.621371192 : 1.0
            var speedMaxRound = Math.ceil((speedMax * impFact) / 10.0) * 10.0

            var dist = values.tachometer_abs / 1000.0
            var wh_consume = values.watt_hours - values.watt_hours_charged
            var wh_km_total = wh_consume / Math.max(dist , 1e-10)

            if (speedMaxRound > speedGauge.maximumValue || speedMaxRound < (speedGauge.maximumValue * 0.6) ||
                    useNegativeSpeedValues !== speedGauge.minimumValue < 0) {
                var labelStep = Math.ceil(speedMaxRound / 100) * 10

                if ((speedMaxRound / labelStep) > 30) {
                    labelStep = speedMaxRound / 30
                }

                speedGauge.labelStep = labelStep
                speedGauge.maximumValue = 140
                speedGauge.minimumValue = 0
            }

            var speedNow = values.speed * 3.6 * impFact
            speedGauge.value = useNegativeSpeedValues ? speedNow : Math.abs(speedNow)

            speedGauge.unitText = useImperial ? "mph" : "km/h"

            if (lastFault !== values.fault_str && values.fault_str !== "FAULT_CODE_NONE") {
                VescIf.emitStatusMessage(values.fault_str, false)
            }
            
            // battery SOC
            batteryTextValues.text =
                parseFloat(values.battery_level * 100).toFixed() + "<font size='1' color='#AAAAAA'> %&nbsp;&nbsp;(" +    // BATTERY SOC
                parseFloat(values.v_in).toFixed(1) + "<font size='1'> V)</font>"    // VOLTAGE
            batteryTextValues.textFormat = Text.RichText
            
            // range
            if( values.battery_wh / (wh_km_total / impFact) < 999.0) {
                rangeTextValue.text =
                    useImperial ? 
                    "<br>" +
                    parseFloat(values.battery_wh / (wh_km_total / impFact)).toFixed() + "<font size='1' color='#909090'> mi</font>"   // RANGE IN KM
                    :
                    "<br>" +
                    parseFloat(values.battery_wh / (wh_km_total / impFact)).toFixed() + "<font size='1' color='#909090'> km</font>"   // RANGE IN MILES
                rangeTextValue.textFormat = Text.RichText
            } else {
                rangeTextValue.text =
                    "<br>" +
                    "∞"
                rangeTextValue.textFormat = Text.RichText
            }
            
            // consumption per km
            if( (wh_km_total / impFact) < 999.0) {
                efficiencyTextValue.text =
                useImperial ? 
                "<br><br>" + parseFloat(wh_km_total / impFact).toFixed(1) + "<font size='1' color='#AAAAAA'> Wh/mi</font>"   // CONSUMPTION PER MILE
                :
                "<br><br>" + parseFloat(wh_km_total / impFact).toFixed(1) + "<font size='1' color='#AAAAAA'> Wh/km</font>"   // CONSUMPTION PER KM
                efficiencyTextValue.textFormat = Text.RichText
            } else {
                efficiencyTextValue.text = "∞"
            }
            
            // temperatures
            tempTextValue.text =
                useImperial ? 
                "<br><br><br>" +
                parseFloat(values.temp_mos * 9/5 + 32).toFixed() + "<font size='1' color='#AAAAAA'> \u00B0F</font> / " +
                parseFloat(values.temp_motor * 9/5 + 32).toFixed() + "<font size='1' color='#AAAAAA'> \u00B0F</font>"
                :
                "<br><br><br>" +
                parseFloat(values.temp_mos).toFixed() + "<font size='1' color='#AAAAAA'> \u00B0C</font> / " +
                parseFloat(values.temp_motor).toFixed() + "<font size='1' color='#AAAAAA'> \u00B0C</font>"
            tempTextValue.textFormat = Text.RichText
            
        }
    }
}