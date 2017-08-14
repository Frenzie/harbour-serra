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
