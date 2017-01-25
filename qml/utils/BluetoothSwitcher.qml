import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Bluetooth 1.0
import MeeGo.Connman 0.2

Item {
    id: container

    property bool isOn: btTechModel.powered && adapter.powered

    function switchBt() {
        btTechModel.powered = !btTechModel.powered
    }

    TechnologyModel {
        id: btTechModel
        name: "bluetooth"
    }

    BluetoothAdapter {
        id: adapter
    }
}
