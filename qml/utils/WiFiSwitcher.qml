/*
  Copyright (C) 2016-2017 Petr Vytovtov
  Contact: Petr Vytovtov <osanwevpk@gmail.com>
  All rights reserved.

  This file is part of Serra for Sailfish OS.

  Serra is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Serra is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Serra. If not, see <http://www.gnu.org/licenses/>.
*/

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
