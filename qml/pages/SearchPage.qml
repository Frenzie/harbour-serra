import QtMultimedia 5.0
import QtQuick 2.0
import Sailfish.Silica 1.0

import com.jolla.settings.system 1.0
import org.nemomobile.dbus 2.0
import org.nemomobile.systemsettings 1.0


import "../views"


Page {
    id: page

    Audio { id: audio }

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
        }

        SilicaListView {
            id: listView
            anchors.fill: parent
            anchors.bottomMargin: searchBox.height
            clip: true

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
                        text: model.modelData.title
                    }

                    Label {
                        width: parent.width
                        color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        truncationMode: TruncationMode.Fade
                        text: decodeURI(model.modelData.url)
                    }
                }

                onClicked: Qt.openUrlExternally(decodeURI(model.modelData.url))
            }

            VerticalScrollDecorator {}
        }

        SearchBox {
            id: searchBox
            anchors.bottom: parent.bottom
            width: parent.width

            onSearchStarted: listView.headerItem.text = ""
        }
    }

    Connections {
        target: googleSearchHelper
        onGotAnswer: {
            listView.headerItem.text = answer
            if (searchBox.isVoiceSearch) {
                audio.source = "https://tts.voicetech.yandex.net/generate?text=\"" + answer +
                        "\"&format=mp3&lang=ru-RU&speaker=jane&emotion=good&" +
                        "key=9d7d557a-99dc-44b2-98c8-596cdf3c5dd3"
                audio.play()
            }
        }
        onGotSearchPage: listView.model = results
    }

    Connections {
        target: yandexSpeechKitHelper
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
            case "сделать фото": // TODO
                cameraDbus.takePhoto()
                break
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
            default:
                if (query.indexOf("громкость") === 0 && query.indexOf("процентов") !== -1) {
                    var volumeLevel = parseInt(query.split(" ")[1])
                    profileControl.ringerVolume = volumeLevel
                    profileControl.profile = volumeLevel > 0 ? "general" : "silent"
                } else {
                    googleSearchHelper.getSearchPage(query)
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
