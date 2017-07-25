# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-serra

CONFIG += sailfishapp
QT += multimedia dbus sql

SOURCES += src/harbour-serra.cpp \
    src/yandexsearchhelper.cpp \
    src/googlesearchhelper.cpp \
    src/searchresultobject.cpp \
    src/yandexspeechkithelper.cpp \
    src/recorder.cpp \
    src/newshelper.cpp \
    src/settingswrapper.cpp \
    src/weatherhelper.cpp \
    src/commandsparser.cpp \
    src/commanditem.cpp \
    src/scriptrunner.cpp \
    src/googlemapshelper.cpp \
    src/navigationstep.cpp \
    src/vkstream.cpp \
    src/contactshelper.cpp

OTHER_FILES += qml/harbour-serra.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-serra.changes.in \
    rpm/harbour-serra.spec \
    rpm/harbour-serra.yaml \
    translations/*.ts \
    harbour-serra.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-serra-ru.ts

DISTFILES += \
    qml/pages/SearchPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AboutPage.qml \
    qml/views/SearchBox.qml \
    qml/pages/CommandsPage.qml \
    qml/utils/WiFiSwitcher.qml \
    qml/utils/FlashlightSwitcher.qml \
    qml/utils/BluetoothSwitcher.qml \
    qml/utils/GpsSwitcher.qml \
    qml/pages/CustomCommandsPage.qml \
    qml/pages/NavigationPage.qml \
    qml/pages/ImageViewPage.qml

HEADERS += \
    src/yandexsearchhelper.h \
    src/googlesearchhelper.h \
    src/searchresultobject.h \
    src/yandexspeechkithelper.h \
    src/recorder.h \
    src/newshelper.h \
    src/settingswrapper.h \
    src/weatherhelper.h \
    src/commandsparser.h \
    src/commanditem.h \
    src/scriptrunner.h \
    src/googlemapshelper.h \
    src/navigationstep.h \
    src/vkstream.h \
    src/contactshelper.h

