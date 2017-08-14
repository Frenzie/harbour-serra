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
