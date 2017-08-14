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
;import org.nemomobile.systemsettings 1.0

Item {
    id: volumeControl

    /* Setting volume level.
     * @param: value -- the volume level from 0 (min) to 100 (max).
     */
    function setVolume(value) {
        if (value <= 0) setMinimumVolume()
        else if (value >= 100) setMaximumVolume()
        else {
            profileControl.ringerVolume = value
            _setProfile()
        }
    }

    /* Increasing volume level by percents.
     * @param: percents -- the percents to change volume level.
     */
    function increaseVolume(percents) {
        setVolume(profileControl.ringerVolume + percents)
    }

    /* Decreasing volume level by percents.
     * @param: percents -- the percents to change volume level.
     */
    function decreaseVolume(percents) {
        setVolume(profileControl.ringerVolume - percents)
    }

    /* Setting volume to minimum level.
     */
    function setMinimumVolume() {
        profileControl.ringerVolume = 0
        _setProfile()
    }

    /* Setting volume to maximum level.
     */
    function setMaximumVolume() {
        profileControl.ringerVolume = 100
        _setProfile()
    }

    /* Setting volume profile.
     */
    function _setProfile() {
        profileControl.profile = (profileControl.ringerVolume > 0) ? "general" : "silent"
    }

    ProfileControl { id: profileControl }
}
