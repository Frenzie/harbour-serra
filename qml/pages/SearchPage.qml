import QtQuick 2.2
import Sailfish.Silica 1.0

import org.nemomobile.dbus 2.0
;import com.jolla.settings.system 1.0
;import org.nemomobile.systemsettings 1.0


import "../views"
import "../utils"


Page {
    id: page

    property string _query: ""
    property bool _isNews: false
    property int _offset: 0
    property bool isWeather: false

    property bool isNavigation: false
    property string start: ""
    property string finish: ""

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
    }

    AmbienceControl { id: ambienceControl } // experimental

    BluetoothControl { id: bluetoothControl }

    BrightnessContol { id: brightnessContol }

    FlashlightSwitcher { id: flashlight }

    FlightControl { id: flightControl }

    VolumeControl { id: volumeControl }

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

        SilicaGridView {
            id: gridView
            anchors.fill: parent
            anchors.bottomMargin: searchBox.height
            clip: true
            visible: false

            cellWidth: width / 3
            cellHeight: cellWidth

            delegate: ListItem {
                width: parent.width / 3
                height: width

                Image {
                    id: imageItem
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: modelData
                    onStatusChanged: if (status == Image.Error) {
                                         fillMode = Image.Pad
                                         source = "image://theme/icon-m-dismiss"
                                     }
                }

                menu: ContextMenu {

                    MenuItem {
                        text: qsTr("Create ambience")
                        onClicked: {
                            if (imageItem.source !== "image://theme/icon-m-dismiss")
                                ambienceControl.createAmbience(modelData);
                        }
                    }
                }

                onClicked: {
                    if (imageItem.source !== "image://theme/icon-m-dismiss")
                        pageStack.push(Qt.resolvedUrl("ImageViewPage.qml"), { _url: modelData });
                }
            }

            VerticalScrollDecorator {}
        }

        SilicaListView {
            id: numbersListView
            anchors.fill: parent
            anchors.bottomMargin: searchBox.height
            clip: true
            visible: false

            header: PageHeader {
                title: qsTr("Choose the number")
            }

            delegate: BackgroundItem {
                width: parent.width
                height: Theme.itemSizeMedium

                Label {
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    anchors.centerIn: parent
                    text: numbersListView.model[index]
                }

                onClicked: voicecall.dialNumber(numbersListView.model[index])
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

            footer: Button {
                visible: listView.model.count > 0
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 3 * 2
                text: qsTr("Load more")
                onClicked: {
                    _offset += 10
                    googleSearchHelper.getSearchPage(_query, _isNews, false, _offset)
                }
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

                onClicked: Qt.openUrlExternally(decodeURI(url))
            }

            VerticalScrollDecorator {}
        }

        SearchBox {
            id: searchBox
            anchors.bottom: parent.bottom
            width: parent.width

            onRecordStarted: busyIndicator.running = true

            onSearchStarted: {
                _query = searchQueryField.text
                listView.model.clear()
                _isNews = false
                _offset = 0
                listView.headerItem.text = ""
            }
        }
    }

    Connections {
        target: commandsParser
        onFinished: {
            isWeather = false
            isSimpleCommand = true
            var isCommonRequest = true
            var lang = settings.value("lang")
            var answer = ""
//            console.log("Command --> ", commandCode)
            switch (commandCode) {
                    case 1:
                        volumeControl.setMinimumVolume()
                        if (lang === "en-US") answer = "Volume is set to 0"
                        else answer = "Звук выключен"
                        break
                    case 2:
                        volumeControl.setMaximumVolume()
                        if (lang === "en-US") answer = "Volume is set to maximum"
                        else answer = "Громкость на максимуме"
                        break
                    case 3:
                        volumeControl.increaseVolume(10)
                        if (lang === "en-US") answer = "Volume is increased by 10%"
                        else answer = "Громкость увеличена на 10%"
                        break
                    case 4:
                        volumeControl.decreaseVolume(10)
                        if (lang === "en-US") answer = "Volume is decreased by 10%"
                        else answer = "Громкость уменьшена на 10%"
                        break
                    case 5:
                        brightnessContol.increaseBrightness(10)
                        if (lang === "en-US") answer = "Brightness is inceased by 10%"
                        else answer = "Яркость увеличена на 10%"
                        break
                    case 6:
                        brightnessContol.decreaseBrightness(10)
                        if (lang === "en-US") answer = "Brightness is decreased by 10%"
                        else answer = "Яркость уменьшена на 10%"
                        break
                    case 7:
                        cameraDbus.takeSelfie()
                        if (lang === "en-US") answer = "Opening the camera"
                        else answer = "Открываю камеру"
                        break
                    case 8:
                        isCommonRequest = false
                        listView.model.clear()
                        var queryParts = query.split(" ")
                        var startIndex = queryParts[2] === "о" || queryParts[2] === "об" || queryParts[2] === "about" ? 3 : 2
                        _query = query.split(" ").slice(startIndex).join(" ")
                        _isNews = true
                        _offset = 0
                        listView.headerItem.text = ""
                        googleSearchHelper.getSearchPage(_query, _isNews)
                        isSimpleCommand = false
                        break
                    case 9:
                        isWeather = true
                        weatherHelper.getWeatherByCoords(positionSource.position.coordinate.latitude,
                                                         positionSource.position.coordinate.longitude,
                                                         settings.value("weatherKey"))
                        break
                    case 10:
                        isWeather = true
                        if (settings.value("lang") === "ru-RU") yandexSpeechKitHelper.parseQuery(query, settings.value("yandexskcKey"))
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

                            if (city !== "" && dayOffset !== 0) weatherHelper.getWeatherByCityNameWithDate(transliterate(city), dayOffset, settings.value("weatherKey"))
                            else if (city !== "") weatherHelper.getWeatherByCityName(transliterate(city), settings.value("weatherKey"))
                            else if (dayOffset !== 0)
                                weatherHelper.getWeatherByCoordsWithDate(positionSource.position.coordinate.latitude,
                                                                         positionSource.position.coordinate.longitude, dayOffset, settings.value("weatherKey"))
                        }
                        break;
                    case 11:
                        var queryParts = query.split(" ")
                        var lastPart = queryParts[queryParts.length-1]
                        var volumeLevel = 0
                        if (lastPart[lastPart.length-1] === "%") volumeLevel = parseInt(lastPart.slice(0, -1))
                        else if (queryParts.length === 3) volumeLevel = parseInt(queryParts[1])
                        else if (queryParts.length === 4) volumeLevel = parseInt(queryParts[2])
                        else if (queryParts.length === 5) volumeLevel = parseInt(queryParts[3])
                        volumeControl.setVolume(volumeLevel)
                        if (lang === "en-US") answer = "Volume is set to " + volumeLevel + "%"
                        else answer = "Громкость установлена на " + volumeLevel + "%"
                        break
                    case 12:
                        if (!wifiSwitcher.isOn) wifiSwitcher.switchWifi()
                        if (lang === "en-US") answer = "Wi-Fi is on"
                        else answer = "Wi-Fi включен"
                        break
                    case 13:
                        if (wifiSwitcher.isOn) wifiSwitcher.switchWifi()
                        if (lang === "en-US") answer = "Wi-Fi is off"
                        else answer = "Wi-Fi выключен"
                        break
                    case 14:
                        if (!flashlight.flashlightOn) flashlight.toggleFlashlight()
                        if (lang === "en-US") answer = "Flashlight is on"
                        else answer = "Вспышка включена"
                        break
                    case 15:
                        if (flashlight.flashlightOn) flashlight.toggleFlashlight()
                        if (lang === "en-US") answer = "Flashlight is off"
                        else answer = "Вспышка выключена"
                        break
                    case 16:
                        bluetoothControl.turnOnBluetooth()
                        if (lang === "en-US") answer = "Bluetooth is on"
                        else answer = "Bluetooth включен"
                        break;
                    case 17:
                        bluetoothControl.turnOffBluetooth()
                        if (lang === "en-US") answer = "Bluetooth is off"
                        else answer = "Bluetooth выключен"
                        break;
//                    case 18:
//                        if (!gpsSwitcher.isOn) gpsSwitcher.switchGps()
//                        if (lang === "en-US") answer = "GPS is on"
//                        else answer = "GPS включен"
//                        break;
//                    case 19:
//                        if (gpsSwitcher.isOn) gpsSwitcher.switchGps()
//                        if (lang === "en-US") answer = "GPS is off"
//                        else answer = "GPS выключен"
//                        break;
                    case 20:
                        var offset = 2
                        if (settings.value("lang") === "ru-RU") offset = 3
                        start = positionSource.position.coordinate.latitude + "," + positionSource.position.coordinate.longitude
                        finish = query.split(" ").slice(offset).join("+")
                        googleMapsHelper.getDistance(start, finish, settings.value("lang"), "")
                        isNavigation = true
                        isSimpleCommand = false
                        break;
                    case 21:
                        if (isNavigation) {
                            googleMapsHelper.getDirection(start, finish, settings.value("lang"), "");
                            isCommonRequest = false;
                            isNavigation = false;
                        }
                        break;
                    case 22:
                        isSimpleCommand = false;
                        isCommonRequest = false;
                        googleSearchHelper.getSearchPage(query.split(" ").slice(1).join(" "), false, true);
                        break;
                    case 23:
                        isCommonRequest = false;
                        var name = query.split(" ").slice(1).join(" ");
                        if (settings.value("lang") === "ru-RU")
                            yandexSpeechKitHelper.parseName(name, settings.value("yandexskcKey"));
                        else voicecall.dial(contactsHelper.getPhoneNumbers(name));
                        break;
                    case 24:
                        flightControl.turnOnFlightMode();
                        break;
                    case 25:
                        brightnessContol.enableAutoBrightness();
                        if (lang === "en-US") answer = "Auto brightness is enables";
                        else answer = "Автоматическая яркость актифирована";
                        break;
                    default:
                        isSimpleCommand = false;
                        break;
                    }
            recognitionFinished();
            if (isCommonRequest) {
                listView.model.clear();
                _query = query;
                _isNews = false;
                _offset = 0;
                listView.headerItem.text = "";
                googleSearchHelper.getSearchPage(_query);
            }
            if (answer !== "") {
                audio.source = yandexSpeechKitHelper.generateAnswer(answer, lang, settings.value("yandexskcKey"));
                audio.play();
            }
        }
    }

    Connections {
        target: googleMapsHelper
        onGotResponce: {
            listView.headerItem.text = answer
            var lang = settings.value("lang")
            if (lang === "") lang = "ru-RU"
            audio.source = yandexSpeechKitHelper.generateAnswer(answer, lang, settings.value("yandexskcKey"))
            audio.play()
        }
        onGotPath: {
            busyIndicator.running = false
            pageStack.push(Qt.resolvedUrl("NavigationPage.qml"), { "path": path })
        }
    }

    Connections {
        target: googleSearchHelper
        onGotAnswer: {
            if (!isWeather) {
                listView.headerItem.text = answer
                if (searchBox.isVoiceSearch) {
                    var lang = settings.value("lang")
                    if (lang === "") lang = "ru-RU"
                    audio.source = yandexSpeechKitHelper.generateAnswer(answer, lang, settings.value("yandexskcKey"))
                    audio.play()
                }
            }
        }
        onGotSearchPage: {
            busyIndicator.running = false
            gridView.visible = false
            listView.visible = true
            numbersListView.visible = false
            for (var index in results) {
                listView.model.append({ title: results[index].title,
                                        url:   results[index].url })
            }
        }
        onGotImages: {
            busyIndicator.running = false
            gridView.visible = true
            listView.visible = false
            numbersListView.visible = false
            gridView.model = images
//            console.log(images)
        }
    }

    Connections {
        target: weatherHelper
        onGotWeather: {
            var lang = settings.value("lang")
            listView.headerItem.text = transliterate(answer, lang === "ru-RU")
            audio.source = yandexSpeechKitHelper.generateAnswer(listView.headerItem.text, lang, settings.value("yandexskcKey"))
            audio.play()
        }
    }

    Connections {
        target: yandexSpeechKitHelper
        onGotNames: voicecall.dial(contactsHelper.getPhoneNumbers(names))
        onGotWeatherData: {
            if (isWeather) {
                if (city !== "" && day !== 0) weatherHelper.getWeatherByCityNameWithDate(transliterate(city), day, settings.value("weatherKey"))
                else if (city !== "") weatherHelper.getWeatherByCityName(transliterate(city), settings.value("weatherKey"))
                else if (day !== 0)
                    weatherHelper.getWeatherByCoordsWithDate(positionSource.position.coordinate.latitude,
                                                             positionSource.position.coordinate.longitude,
                                                             day, settings.value("weatherKey"))
            } else {
                console.log("onGotWeatherData --> ", city)
            }
        }
        onGotResponce: {
//            console.log("onGotResponce --> ", query)
            searchBox.searchQueryField.text = query.replace("после завтра", "послезавтра").toLowerCase()
            var customCommand = settings.command(searchBox.searchQueryField.text)
            if (customCommand !== "") {
                var lang = settings.value("lang")
                var runningAnswer = lang === "en-US" ? "Running" : "Выполняю"
                audio.source = yandexSpeechKitHelper.generateAnswer(runningAnswer, lang, settings.value("yandexskcKey"))
                audio.play()
                scriptRunner.runScript(customCommand)
                busyIndicator.running = false
            } else commandsParser.parseCommand(searchBox.searchQueryField.text, settings.value("lang"))
        }
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

    DBusInterface {
        id: voicecall
        service: "com.jolla.voicecall.ui"
        path: "/"
        iface: "com.jolla.voicecall.ui"

        function dial(numbers) {
            busyIndicator.running = false
            if (numbers.length === 1) call('dial', numbers[0])
            else if (numbers.length > 1) {
                numbersListView.model = numbers
                numbersListView.visible = true
                gridView.visible = false
                listView.visible = false
            }
        }

        function dialNumber(number) {
            numbersListView.visible = false
            gridView.visible = false
            listView.visible = true
            call('dial', number)
        }
    }

    Component.onCompleted: {
        if (settings.value("lang") === "") {
            if (localeString === "en-US" || localeString === "ru-RU") {
                settings.setValue("lang", localeString)
            } else {
                settings.setValue("lang", "ru-RU")
            }
            notification.previewBody = qsTr("Commands language is set to ") + settings.value("lang")
            notification.publish()
        }
        weatherHelper.setLang(settings.value("lang"))
        var tapAndTalkMode = settings.value("tapandtalk")
        if (tapAndTalkMode === "") settings.setValue("tapandtalk", "false")
        var doNotOpenMode = settings.value("donotopen")
        if (doNotOpenMode === "") settings.setValue("donotopen", "true")
    }
}
