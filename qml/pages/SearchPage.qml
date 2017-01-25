import QtMultimedia 5.0
import QtQuick 2.2
import QtPositioning 5.3
import Sailfish.Silica 1.0

import com.jolla.settings.system 1.0
import org.nemomobile.dbus 2.0
import org.nemomobile.systemsettings 1.0


import "../views"
//import "../../../jolla-settings/pages/networking"


Page {
    id: page

    property string _query: ""
    property bool _isNews: false
    property int _offset: 0

    Audio { id: audio }

    PositionSource {
        id: positionSource
        active: true
//        onPositionChanged: {
//            if (position.coordinate.isValid) {
//                if (measure(lat, lon, position.coordinate.latitude, position.coordinate.longitude) >= 5) {
//                    lat = position.coordinate.latitude
//                    lon = position.coordinate.longitude
//                    mapView.source = buildMapQuery(lat, lon, 17)
//                }
//            } else console.log("Coordinates is not valid")
//        }
    }

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

//    EnableSwitch {
//        id: wifiSwicher

//        function sw() {
//            if (wifiTechnology.tethering) {
//                        connectionAgent.stopTethering(true)
//                    } else {
//                        wifiTechnology.powered = !wifiTechnology.powered
//                        if (wifiTechnology.powered) {
//                            busyTimer.stop()
//                        } else if (connDialogConfig.rise) {
//                            busyTimer.restart()
//                        }
//                    }
//        }
//    }

//    onStatusChanged: if (status === PageStatus.Active) {
//                         wifiSwicher.sw()
//                     }

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
            listView.headerItem.text = transliterate(answer, true)
                var lang = "ru-RU"
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
            searchBox.searchQueryField.text = query
            switch (query) {
            case "увеличить яркость":
                displaySettings.brightness += Math.round(displaySettings.maximumBrightness / 10)
                if (displaySettings.brightness > displaySettings.maximumBrightness)
                    displaySettings.brightness = displaySettings.maximumBrightness
                break
            case "уменьшить яркость":
                displaySettings.brightness -= Math.round(displaySettings.maximumBrightness / 10)
                if (displaySettings.brightness < 1) displaySettings.brightness = 1
                break
//            case "сделать фото": // TODO
//                cameraDbus.takePhoto()
//                break
            case "сделать селфи":
                cameraDbus.takeSelfie()
                break
            case "увеличить громкость":
                profileControl.ringerVolume += 10
                if (profileControl.ringerVolume > 100) profileControl.ringerVolume = 100
                profileControl.profile = profileControl.ringerVolume > 0 ? "general" : "silent"
                break
            case "уменьшить громкость":
                profileControl.ringerVolume -= 10
                if (profileControl.ringerVolume < 0) profileControl.ringerVolume = 0
                profileControl.profile = profileControl.ringerVolume > 0 ? "general" : "silent"
                break
            case "громкость на максимум":
                profileControl.ringerVolume = 100
                profileControl.profile = "general"
                break
            case "выключить звук":
                profileControl.ringerVolume = 0
                profileControl.profile = "silent"
                break
            case "какая погода":
                weatherHelper.getWeatherByCoords(positionSource.position.coordinate.latitude,
                                                 positionSource.position.coordinate.longitude)
                break;
            default:
                if (query.indexOf("громкость") === 0 && query.indexOf("процентов") !== -1) {
                    var volumeLevel = parseInt(query.split(" ")[1])
                    profileControl.ringerVolume = volumeLevel
                    profileControl.profile = volumeLevel > 0 ? "general" : "silent"
                } else if (query.indexOf("какая погода") === 0) {
                    query = query.replace("после завтра", "послезавтра")
                    yandexSpeechKitHelper.parseQuery(query)
                } else {
                    listView.model.clear()
                    var newsSearchRe = /^какие новости (о|об)/
                    if (query.match(newsSearchRe)) {
                        _query = query.split(" ").slice(3).join(" ")
                        _isNews = true
                        _offset = 0
                        googleSearchHelper.getSearchPage(_query, _isNews)
                    } else {
                        _query = query
                        _isNews = false
                        _offset = 0
                        googleSearchHelper.getSearchPage(_query)
                    }
                }
            }
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
}
