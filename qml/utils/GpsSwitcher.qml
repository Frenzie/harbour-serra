import QtQuick 2.0
import Sailfish.Silica 1.0
;import MeeGo.Connman 0.2
;import com.jolla.settings.system 1.0

Item {

    property bool isOn: locationSettings.locationEnabled

    function switchGps() {
        var newState = !isOn
        locationSettings.locationEnabled = newState
        if (newState == false) {
            gpsTechModel.powered = false
        } else if (locationSettings.gpsEnabled) {
            gpsTechModel.powered = true
        }
    }

    TechnologyModel {
        id: gpsTechModel
        name: "gps"
    }

    LocationSettings {
        id: locationSettings
    }
}
