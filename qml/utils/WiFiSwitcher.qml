import QtQuick 2.0
import Sailfish.Silica 1.0
;import MeeGo.Connman 0.2
;import com.jolla.connection 1.0
;import org.nemomobile.configuration 1.0
;import org.nemomobile.dbus 1.0

Item {
    id: wifiSwitch

    property string entryPath
    property bool isOn: wifiTechnology.powered && !wifiTechnology.tethering

    function switchWifi() {
        if (wifiTechnology.tethering) {
            connectionAgent.stopTethering(true)
        } else {
            wifiTechnology.powered = !wifiTechnology.powered
            if (wifiTechnology.powered) {
                busyTimer.stop()
            } else if (connDialogConfig.rise) {
                busyTimer.restart()
            }
        }
    }

    Timer {
        id: busyTimer
        interval: connDialogConfig.scanningWait
        onTriggered: connectionSelector.openConnection()
        onRunningChanged: {
            if (running) {
                wifiTechnology.connectedChanged.connect(stop)
            } else {
                wifiTechnology.connectedChanged.disconnect(stop)
            }
        }
    }

    ConfigurationGroup {
        id: connDialogConfig

        path: "/apps/jolla-settings/wlan_fav_switch_connection_dialog"

        property bool rise: true
        property int scanningWait: 5000
    }

    NetworkTechnology {
        id: wifiTechnology
        path: networkManager.instance.technologyPathForType("wifi")
    }

    NetworkManagerFactory { id: networkManager }

    Connections {
        target: networkManager.instance
        onTechnologiesChanged: {
            wifiTechnology.path = networkManager.instance.technologyPathForType("wifi")
        }
        onTechnologiesEnabledChanged: {
            wifiTechnology.path = networkManager.instance.technologyPathForType("wifi")
        }
    }

    ConnectionAgent { id: connectionAgent }

    DBusInterface {
        id: connectionSelector

        destination: "com.jolla.lipstick.ConnectionSelector"
        path: "/"
        iface: "com.jolla.lipstick.ConnectionSelectorIf"

        function openConnection() {
            call('openConnectionNow', 'wifi')
        }
    }
}
