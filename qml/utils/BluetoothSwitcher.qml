import QtQuick 2.0
import Sailfish.Silica 1.0
;import MeeGo.Connman 0.2
;import org.kde.bluezqt 1.0 as BluezQt

Item {
    id: container

    property QtObject _adapter: _bluetoothManager && _bluetoothManager.usableAdapter
    property QtObject _bluetoothManager: BluezQt.Manager

    property bool isOn: btTechModel.powered && _adapter && _adapter.powered

    function switchBt() {
        btTechModel.powered = !btTechModel.powered
    }

    TechnologyModel {
        id: btTechModel
        name: "bluetooth"
    }
}
