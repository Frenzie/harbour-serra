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
