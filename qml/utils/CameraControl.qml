import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.dbus 2.0

Item {
    id: cameraControl

    function activateFrontCamera() {
        camera.call('showFrontViewfinder', undefined)
    }

    DBusInterface {
        id: camera
        service: 'com.jolla.camera'
        path: '/'
        iface: 'com.jolla.camera.ui'
    }
}
