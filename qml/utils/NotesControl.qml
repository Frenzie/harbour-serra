import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.dbus 2.0

Item {
    id: notesControl

    function createEmptyNote() {
        notes.call('newNote', undefined)
    }

    DBusInterface {
        id: notes
        service: 'com.jolla.notes'
        path: '/'
        iface: 'com.jolla.notes'
    }
}
