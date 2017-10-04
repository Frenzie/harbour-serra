import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.dbus 2.0

Item {
    id: galleryControl

    function showImages(urls) {
        gallery.call('showImages', urls)
    }

    DBusInterface {
        id: gallery
        service: 'com.jolla.gallery'
        path: '/com/jolla/gallery/ui'
        iface: 'com.jolla.gallery.ui'
    }
}
