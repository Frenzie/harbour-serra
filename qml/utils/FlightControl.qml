import QtQuick 2.0
;import MeeGo.Connman 0.2

Item {
    id: flightControl

    /* Turning on flight mode.
     */
    function turnOnFlightMode() {
        connMgr.instance.offlineMode = true
    }

    /* Turning off flight mode.
     */
    function turnOffFlightMode() {
        connMgr.instance.offlineMode = false
    }

    /* Switching flight mode.
     */
    function switchFlightMode() {
        connMgr.instance.offlineMode = !connMgr.instance.offlineMode
    }

    NetworkManagerFactory { id: connMgr }
}
