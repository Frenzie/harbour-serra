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

import org.nemomobile.dbus 2.0
;import QtQml 2.0

QtObject {
    id: flashlight

    property bool flashlightOn
    property bool busy

    function handleToggle(available) {
        if (!available) {
            busy = false
        }
    }

    function handleError() {
        console.log("Failed to call method 'toggleFlashlight'.")
        busy = false
    }

    function toggleFlashlight() {
        busy = true
        flashlightDbus.call("toggleFlashlight", undefined, handleToggle, handleError)
    }

    property QtObject flashlightDbus: DBusInterface {
        signalsEnabled: true
        service: "com.jolla.settings.system.flashlight"
        path: "/com/jolla/settings/system/flashlight"
        iface: "com.jolla.settings.system.flashlight"
        function flashlightOnChanged(newOn) {
            busy = false
            flashlight.flashlightOn = newOn
        }
    }

    Component.onCompleted: {
        flashlight.flashlightOn = flashlightDbus.getProperty("flashlightOn")
    }
}
