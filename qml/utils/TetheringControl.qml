import QtQuick 2.0
;import Sailfish.Telephony 1.0
;import com.jolla.settings 1.0
;import Sailfish.Silica.private 1.0
;import MeeGo.Connman 0.2
;import com.jolla.settings.network.translations 1.0
;import com.jolla.settings.system 1.0
;import MeeGo.QOfono 0.2
;import com.jolla.connection 1.0

Item {

    /* Enabling tethering.
     */
    function turnOnTethering() {
        if (_canTethering() && !wifiTechnology.tethering) connectionAgent.startTethering("wifi")
    }

    /* Disabling tethering.
     */
    function turnOffTethering() {
        if (_canTethering() && wifiTechnology.tethering) connectionAgent.stopTethering()
    }

    /* Switching tethering mode.
     */
    function switchTethering() {
        if (_canTethering())
            if (wifiTechnology.tethering) connectionAgent.stopTethering();
            else connectionAgent.startTethering("wifi");
    }

    /* Checking tethering possibility.
     */
    function _canTethering() {
        return !networkManager.instance.offlineMode &&
                (_roamingDataAllowed() || wifiTechnology.tethering);
    }

    /* Checking data usage in roaming possibility.
     */
    function _roamingDataAllowed() {
        return networkRegistration.valid && connectionManager.valid
            && !(networkRegistration.status === "roaming" && !connectionManager.roamingAllowed);
    }

    ConnectionAgent { id: connectionAgent }

    NetworkManagerFactory { id: networkManager }

    NetworkTechnology {
        id: wifiTechnology
        path: networkManager.instance.technologyPathForType("wifi")
    }

    SimManager {
        id: simManager
        controlType: SimManagerType.Data
    }

    OfonoNetworkRegistration {
        id: networkRegistration
        modemPath: simManager.activeModem
    }

    OfonoConnMan {
        id: connectionManager
        modemPath: simManager.activeModem
    }
}
