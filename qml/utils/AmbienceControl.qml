import QtQuick 2.0
;import Sailfish.Ambience 1.0
;import com.jolla.gallery.ambience 1.0

Item {
    id: ambienceControl

    /* Creating new ambience from image.
     * @param: url -- the url of image for ambience.
     */
    function createAmbience(url) {
        var previousAmbienceUrl = Ambience.source
        Ambience.setAmbience(url, function (ambienceId) {
            pageStack.push(ambienceSettings, { 'contentId': ambienceId,
                                               'previousAmbienceUrl': previousAmbienceUrl })
        })
    }

    Component {
        id: ambienceSettings

        AmbienceSettingsPage {
            property alias previousAmbienceUrl: previousAmbience.url

            AmbienceInfo { id: previousAmbience }

            onAmbienceRemoved: Ambience.source = previousAmbienceUrl
        }
    }
}
