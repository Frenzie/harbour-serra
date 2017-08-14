import QtQuick 2.0
;import MeeGo.Connman 0.2

Item {
    id: bluetoothControl

    /* Turning on Bluetooth.
     */
    function turnOnBluetooth() {
        btTechModel.powered = true
    }

    /* Turning off Bluetooth.
     */
    function turnOffBluetooth() {
        btTechModel.powered = false
    }

    /* Switching Bluetooth.
     */
    function switchBluetooth() {
        btTechModel.powered = !btTechModel.powered
    }

    TechnologyModel {
        id: btTechModel
        name: "bluetooth"
    }
}
