import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    ListModel {
        id: rusCommands

        ListElement { command: "Поиск в интернете"; type: 1 }
        ListElement { command: "<поисковый-запрос>"; type: 0 }
        ListElement { command: "какие новости <тема>"; type: 0 }
        ListElement { command: "какие новости о/об <тема>"; type: 0 }
        ListElement { command: "фотографии <тема>"; type: 0 }
        ListElement { command: "картинки <тема>"; type: 0 }

        ListElement { command: "Погода"; type: 1 }
        ListElement { command: "погода"; type: 0 }
        ListElement { command: "какая погода"; type: 0 }
        ListElement { command: "погода в <город>"; type: 0 }
        ListElement { command: "какая погода в <город>"; type: 0 }
        ListElement { command: "погода завтра/послезавтра"; type: 0 }
        ListElement { command: "какая погода завтра/послезавтра"; type: 0 }
        ListElement { command: "погода в <город> завтра/послезавтра"; type: 0 }
        ListElement { command: "какая погода в <город> завтра/послезавтра"; type: 0 }

        ListElement { command: "Навигация"; type: 1 }
        ListElement { command: "как доехать до <место/адрес>"; type: 0 }

        ListElement { command: "Мультимедиа"; type: 1 }
        ListElement { command: "сдела[й/ть] селфи"; type: 0 }

        ListElement { command: "Системные"; type: 1 }
        ListElement { command: "включи[ть] wi-fi"; type: 0 }
        ListElement { command: "выключи[ть] wi-fi"; type: 0 }
        ListElement { command: "включи[ть] вспышку/фонарик"; type: 0 }
        ListElement { command: "выключи[ть] вспышку/фонарик"; type: 0 }
        ListElement { command: "включи[ть] bluetooth"; type: 0 }
        ListElement { command: "выключи[ть] bluetooth"; type: 0 }
//        ListElement { command: "включи[ть] gps"; type: 0 }
//        ListElement { command: "выключи[ть] gps"; type: 0 }
        ListElement { command: "выключи[ть] звук"; type: 0 }
        ListElement { command: "громкость на максимум"; type: 0 }
        ListElement { command: "постав[ь/ить] громкость на максимум"; type: 0 }
        ListElement { command: "сдела[й/ть] громкость на максимум"; type: 0 }
        ListElement { command: "громкость на <число> процент[ов/a]?"; type: 0 }
        ListElement { command: "постав[ь/ить] громкость на <число> процент[ов/a]?"; type: 0 }
        ListElement { command: "сдела[й/ть] громкость на <число> процент[ов/a]?"; type: 0 }
        ListElement { command: "установи[ть] громкость на <число> процент[ов/a]?"; type: 0 }
        ListElement { command: "увелич[ь/ить] громкость"; type: 0 }
        ListElement { command: "уменьш[ь/ить] громкость"; type: 0 }
        ListElement { command: "увелич[ь/ить] яркость"; type: 0 }
        ListElement { command: "уменьш[ь/ить] яркость"; type: 0 }
        ListElement { command: "позвони <имя>"; type: 0 }
    }

    ListModel {
        id: engCommands

        ListElement { command: "Search"; type: 1 }
        ListElement { command: "<search-query>"; type: 0 }
        ListElement { command: "what news <theme>"; type: 0 }
        ListElement { command: "what news about <theme>"; type: 0 }
        ListElement { command: "photos <theme>"; type: 0 }
        ListElement { command: "images <theme>"; type: 0 }

        ListElement { command: "Weather"; type: 1 }
        ListElement { command: "weather"; type: 0 }
        ListElement { command: "what weather"; type: 0 }
        ListElement { command: "weather in <city>"; type: 0 }
        ListElement { command: "what weather in <city>"; type: 0 }
        ListElement { command: "weather [day after] tomorrow"; type: 0 }
        ListElement { command: "what weather [day after] tomorrow"; type: 0 }
        ListElement { command: "weather in <city> [day after] tomorrow"; type: 0 }
        ListElement { command: "what weather in <city>] [day after] tomorrow"; type: 0 }

        ListElement { command: "Navigation"; type: 1 }
        ListElement { command: "navigate to <place/address>"; type: 0 }

        ListElement { command: "Multimedia"; type: 1 }
        ListElement { command: "take a selfie"; type: 0 }

        ListElement { command: "System"; type: 1 }
        ListElement { command: "turn on wi-fi"; type: 0 }
        ListElement { command: "turn off wi-fi"; type: 0 }
        ListElement { command: "turn on flashlight/torch"; type: 0 }
        ListElement { command: "turn off flashlight/torch"; type: 0 }
        ListElement { command: "turn on bluetooth"; type: 0 }
        ListElement { command: "turn off bluetooth"; type: 0 }
//        ListElement { command: "turn on gps"; type: 0 }
//        ListElement { command: "turn off gps"; type: 0 }
        ListElement { command: "turn off volume"; type: 0 }
        ListElement { command: "volume to maximum"; type: 0 }
        ListElement { command: "set volume to maximum"; type: 0 }
        ListElement { command: "volume to <number> percent[s]"; type: 0 }
        ListElement { command: "set volume to <number> percent[s]"; type: 0 }
        ListElement { command: "increase volume"; type: 0 }
        ListElement { command: "decrease volume"; type: 0 }
        ListElement { command: "increase brightness"; type: 0 }
        ListElement { command: "decrease brightness"; type: 0 }
        ListElement { command: "call <name>"; type: 0 }
    }

    SilicaListView {
        id: commandsList
        anchors.fill: parent
        anchors.bottomMargin: languageChooser.height
        clip: true

        header: PageHeader {
            title: qsTr("Commands list")
        }

        delegate: Item {
            width: parent.width
            height: type == 0 ? commandText.height + Theme.paddingMedium : commandSection.height

            Label {
                id: commandText
                anchors.centerIn: parent
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: command
                lineHeight: 0.8
                wrapMode: Text.WordWrap
                visible: type == 0
            }

            SectionHeader {
                id: commandSection
                text: command
                visible: type == 1
            }
        }

        VerticalScrollDecorator {}
    }

    ComboBox {
        id: languageChooser
        anchors.bottom: parent.bottom
        width: parent.width
        label: qsTr("Commands language:")
        currentIndex: {
            switch (settings.value("lang")) {
            case "ru-RU":
                commandsList.model = rusCommands
                return 0;
            case "en-US":
                commandsList.model = engCommands
                return 1;
            default:
                commandsList.model = rusCommands
                return 0;
            }
        }

        menu: ContextMenu {

            MenuItem {
                text: qsTr("Russian")
                onClicked: commandsList.model = rusCommands
            }

            MenuItem {
                text: qsTr("English")
                onClicked: commandsList.model = engCommands
            }
        }

        Rectangle {
            anchors.fill: parent
            z: -1
            gradient: Gradient {

                GradientStop {
                    position: 0.0
                    color: Theme.rgba(Theme.highlightBackgroundColor, 0.15)
                }

                GradientStop {
                    position: 1.0
                    color: "transparent"
                }
            }
        }
    }

    onStatusChanged: if (status === PageStatus.Active)
                         pageStack.pushAttached(Qt.resolvedUrl("CustomCommandsPage.qml"))
}
