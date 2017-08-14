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
    id: brightnessControl

    /* Setting brightness level.
     * @param: value -- the brightness level from 1 (min) to maximumBrightness (max).
     */
    function setBrightness(value) {
        disableAutoBrightness();
        if (value <= 1) setMinimumBrightness();
        else if (value >= displaySettings.maximumBrightness) setMaximumBrightness();
        else displaySettings.brightness = value;
    }

    /* Increasing brightness level by percents.
     * @param: percents -- the percents to change brighness level.
     */
    function increaseBrightness(percents) {
        setBrightness(displaySettings.brightness + _calcDelta(percents))
    }

    /* Decreasing brightness level by percents.
     * @param: percents -- the percents to change brightness level.
     */
    function decreaseBrightness(percents) {
        setBrightness(displaySettings.brightness - _calcDelta(percents))
    }

    /* Setting brightness to minimum level.
     */
    function setMinimumBrightness() {
        disableAutoBrightness();
        displaySettings.brightness = 1
    }

    /* Setting brightness to maximum level.
     */
    function setMaximumBrightness() {
        disableAutoBrightness();
        displaySettings.brightness = displaySettings.maximumBrightness
    }

    /* Enabling auto brightness.
     */
    function enableAutoBrightness() {
        displaySettings.autoBrightnessEnabled = true;
        displaySettings.ambientLightSensorEnabled = true;
    }

    /* Disabling auto brightness.
     */
    function disableAutoBrightness() {
        displaySettings.autoBrightnessEnabled = false
    }

    /* Switching auto brightness.
     */
    function switchAutoBrightness() {
        if (displaySettings.autoBrightnessEnabled && displaySettings.ambientLightSensorEnabled) {
            displaySettings.autoBrightnessEnabled = false;
        } else {
            displaySettings.autoBrightnessEnabled = true;
            displaySettings.ambientLightSensorEnabled = true;
        }
    }

    /* Calculating the absolute value to changing brightness.
     * @param: percents -- the percents to change brightness level.
     */
    function _calcDelta(percents) {
        return Math.round(displaySettings.maximumBrightness / 100 * percents)
    }

    DisplaySettings { id: displaySettings }
}
