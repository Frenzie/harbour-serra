import QtMultimedia 5.0
import QtQuick 2.2
import QtPositioning 5.3
import Sailfish.Silica 1.0

import com.jolla.settings.system 1.0
import org.nemomobile.dbus 2.0
import org.nemomobile.systemsettings 1.0


import "../views"
import "../utils"


Page {
    id: page

    property string _query: ""
    property bool _isNews: false
    property int _offset: 0

    Audio { id: audio }

    PositionSource {
        id: positionSource
        active: true
    }

    FlashlightSwitcher { id: flashlight }

    WiFiSwitcher { id: wifiSwitcher }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                text: qsTr("Commands list")
                onClicked: pageStack.push(Qt.resolvedUrl("CommandsPage.qml"))
            }
        }

        SilicaListView {
            id: listView
            anchors.fill: parent
            anchors.bottomMargin: searchBox.height
            clip: true
            model: ListModel { id: listModel }

            header: TextArea {
                id: answerField
                width: parent.width
                enabled: false
                color: Theme.secondaryColor
                wrapMode: TextEdit.WordWrap
                visible: text.length > 0
                labelVisible: false
            }

            delegate: BackgroundItem {
                id: listItem
                width: parent.width
                height: Theme.itemSizeMedium

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Theme.paddingLarge
                    anchors.rightMargin: Theme.paddingLarge
                    spacing: Theme.paddingSmall

                    Label {
                        width: parent.width
                        color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        font.pixelSize: Theme.fontSizeMedium
                        truncationMode: TruncationMode.Fade
                        text: title
                    }

                    Label {
                        width: parent.width
                        color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        truncationMode: TruncationMode.Fade
                        text: decodeURI(url)
                    }
                }

                Component.onCompleted: {
                    if (index === listModel.count-1) {
                        _offset += 10
                        googleSearchHelper.getSearchPage(_query, _isNews, _offset)
                    }
                }

                onClicked: Qt.openUrlExternally(decodeURI(url))
            }

            VerticalScrollDecorator {}
        }

        SearchBox {
            id: searchBox
            anchors.bottom: parent.bottom
            width: parent.width

            onSearchStarted: {
                listView.model.clear()
                _query = searchQueryField.text
                _isNews = false
                _offset = 0
                listView.headerItem.text = ""
            }
        }
    }

    Connections {
        target: commandsParser
        onFinished: switch (commandCode) {
                    case 1:
                        profileControl.ringerVolume = 0
                        profileControl.profile = "silent"
                        break
                    case 2:
                        profileControl.ringerVolume = 100
                        profileControl.profile = "general"
                        break
                    case 3:
                        profileControl.ringerVolume += 10
                        if (profileControl.ringerVolume > 100) profileControl.ringerVolume = 100
                        profileControl.profile = profileControl.ringerVolume > 0 ? "general" : "silent"
                        break
                    case 4:
                        profileControl.ringerVolume -= 10
                        if (profileControl.ringerVolume < 0) profileControl.ringerVolume = 0
                        profileControl.profile = profileControl.ringerVolume > 0 ? "general" : "silent"
                        break
                    case 5:
                        displaySettings.brightness += Math.round(displaySettings.maximumBrightness / 10)
                        if (displaySettings.brightness > displaySettings.maximumBrightness)
                            displaySettings.brightness = displaySettings.maximumBrightness
                        break
                    case 6:
                        displaySettings.brightness -= Math.round(displaySettings.maximumBrightness / 10)
                        if (displaySettings.brightness < 1) displaySettings.brightness = 1
                        break
                    case 7:
                        cameraDbus.takeSelfie()
                        break
                    case 8:
                        listView.model.clear()
                        var queryParts = query.split(" ")
                        var startIndex = queryParts[2] === "о" || queryParts[2] === "об" || queryParts[2] === "about" ? 3 : 2
                        _query = query.split(" ").slice(startIndex).join(" ")
                        _isNews = true
                        _offset = 0
                        googleSearchHelper.getSearchPage(_query, _isNews)
                        break
                    case 9:
                        weatherHelper.getWeatherByCoords(positionSource.position.coordinate.latitude,
                                                         positionSource.position.coordinate.longitude)
                        break
                    case 10:
                        if (settings.value("lang") === "ru-RU") yandexSpeechKitHelper.parseQuery(query)
                        else {
                            var dayOffset = 0
                            if (query.indexOf("day after tomorrow") !== -1) dayOffset = 2
                            else if (query.indexOf("tomorrow") !== -1) dayOffset = 1
                            var city = ""
                            if (query.indexOf(" in ") !== -1) {
                            var city = query.slice(query.indexOf(" in ")+4)
                                if (dayOffset === 1) city = city.slice(0, city.indexOf(" tomorrow"))
                                if (dayOffset === 2) city = city.slice(0, city.indexOf(" day after tomorrow"))
                            }

                            if (city !== "" && dayOffset !== 0) weatherHelper.getWeatherByCityNameWithDate(transliterate(city), dayOffset)
                            else if (city !== "") weatherHelper.getWeatherByCityName(transliterate(city))
                            else if (dayOffset !== 0)
                                weatherHelper.getWeatherByCoordsWithDate(positionSource.position.coordinate.latitude,
                                                                         positionSource.position.coordinate.longitude, dayOffset)
                        }
                        break;
                    case 11:
                        var queryParts = query.split(" ")
                        var volumeLevel = 0
                        if (queryParts.length === 3) parseInt(queryParts[1])
                        else if (queryParts.length === 4) parseInt(queryParts[2])
                        else if (queryParts.length === 5) parseInt(queryParts[3])
                        profileControl.ringerVolume = volumeLevel
                        profileControl.profile = volumeLevel > 0 ? "general" : "silent"
                        break
                    case 12:
                        if (!wifiSwitcher.isOn) wifiSwitcher.switchWifi()
                        break
                    case 13:
                        if (wifiSwitcher.isOn) wifiSwitcher.switchWifi()
                        break
                    case 14:
                        if (!flashlight.flashlightOn) flashlight.toggleFlashlight()
                        break
                    case 15:
                        if (flashlight.flashlightOn) flashlight.toggleFlashlight()
                        break
                    default:
                        listView.model.clear()
                        _query = query
                        _isNews = false
                        _offset = 0
                        googleSearchHelper.getSearchPage(_query)
                        break
                    }
    }

    Connections {
        target: googleSearchHelper
        onGotAnswer: {
            listView.headerItem.text = answer
            if (searchBox.isVoiceSearch) {
                var lang = settings.value("lang")
                if (lang === "") lang = "ru-RU"
                audio.source = "https://tts.voicetech.yandex.net/generate?text=\"" + answer +
                        "\"&format=mp3&lang=" + lang + "&speaker=jane&emotion=good&" +
                        "key=9d7d557a-99dc-44b2-98c8-596cdf3c5dd3"
                audio.play()
            }
        }
        onGotSearchPage: {
            for (var index in results) {
                listView.model.append({ title: results[index].title,
                                        url:   results[index].url })
            }
        }
    }

    Connections {
        target: weatherHelper
        onGotWeather: {
            var lang = settings.value("lang")
            listView.headerItem.text = transliterate(answer, lang === "ru-RU")
            audio.source = "https://tts.voicetech.yandex.net/generate?text=\"" +
                    listView.headerItem.text +
                    "\"&format=mp3&lang=" + lang + "&speaker=jane&emotion=good&" +
                    "key=9d7d557a-99dc-44b2-98c8-596cdf3c5dd3"
            audio.play()
        }
    }

    Connections {
        target: yandexSpeechKitHelper
        onGotWeatherData: {
            if (city !== "" && day !== 0) weatherHelper.getWeatherByCityNameWithDate(transliterate(city), day)
            else if (city !== "") weatherHelper.getWeatherByCityName(transliterate(city))
            else if (day !== 0)
                weatherHelper.getWeatherByCoordsWithDate(positionSource.position.coordinate.latitude,
                                                         positionSource.position.coordinate.longitude, day)
        }
        onGotResponce: {
            searchBox.searchQueryField.text = query.replace("после завтра", "послезавтра").toLowerCase()
            commandsParser.parseCommand(searchBox.searchQueryField.text, settings.value("lang"))
        }
    }

    DisplaySettings {
        id: displaySettings
    }

    ProfileControl {
        id: profileControl
    }

    DBusInterface {
        id: cameraDbus
        iface: "com.jolla.camera.ui"
        service: "com.jolla.camera"
        path: "/"

        function takePhoto() {
            call("showViewfinder", undefined)
        }

        function takeSelfie() {
            call("showFrontViewfinder", undefined)
        }
    }

    Component.onCompleted: weatherHelper.setLang(settings.value("lang"))
}
