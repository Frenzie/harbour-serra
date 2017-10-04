import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.dbus 2.0

Item {
    id: settingsControl

    function showSettings() {
        settings_.call('showSettings', undefined)
    }

    DBusInterface {
        id: settings_
        service: 'com.jolla.settings'
        path: '/com/jolla/settings/ui'
        iface: 'com.jolla.settings.ui'
    }
}
