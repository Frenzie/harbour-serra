import QtQuick 2.0
;import org.nemomobile.systemsettings 1.0

Item {
    id: brightnessControl

    /* Setting brightness level.
     * @param: value -- the brightness level from 1 (min) to maximumBrightness (max).
     */
    function setBrightness(value) {
        if (value <= 1) setMinimumBrightness()
        else if (value >= displaySettings.maximumBrightness) setMaximumBrightness()
        else displaySettings.brightness = value
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
        displaySettings.brightness = 1
    }

    /* Setting brightness to maximum level.
     */
    function setMaximumBrightness() {
        displaySettings.brightness = displaySettings.maximumBrightness
    }

    /* Calculating the absolute value to changing brightness.
     * @param: percents -- the percents to change brightness level.
     */
    function _calcDelta(percents) {
        return Math.round(displaySettings.maximumBrightness / 100 * percents)
    }

    DisplaySettings { id: displaySettings }
}
