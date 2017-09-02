import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.dbus 2.0


Item {
    id: calendarControl

    function showAgenda() {
        calendar.call('viewDate', Date.now())
    }

    DBusInterface {
        id: calendar
        service: 'com.jolla.calendar.ui'
        path: '/com/jolla/calendar/ui'
        iface: 'com.jolla.calendar.ui'
    }
}
