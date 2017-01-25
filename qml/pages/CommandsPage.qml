import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    ListModel {
        id: rusCommands

        ListElement { command: "<поисковый-запрос>" }
        ListElement { command: "какие новости [о|об] <тема>" }
        ListElement { command: "[какая] погода [[в] <город>] [завтра|послезавтра]" }
        ListElement { command: "сдела[й|ть] селфи" }
        ListElement { command: "(увеличи[ть]|уменьши[ть]) (яркость|громкость)" }
        ListElement { command: "[постав(ь|ить)|сдела(й|ть)] громкость на максимум" }
        ListElement { command: "выключи[ть] звук" }
        ListElement { command: "[постав[ь|ить]|сдела[й|ть]|установи[ть]] громкость [на] <число> процент[ов|a]?" }
        ListElement { command: "(включить|выключить) wi-fi" }
    }

    ListModel {
        id: engCommands

        ListElement { command: "<search-query>" }
        ListElement { command: "what['s| is] news [about] <theme>" }
        ListElement { command: "[what['s| is]] weather [[in] <city>] [tommorow|[the] day after tomorrow]" }
        ListElement { command: "(make|do|take) [a] selfie" }
        ListElement { command: "(increase|decrease) (brightness|volume)" }
        ListElement { command: "[set] volume to maximum" }
        ListElement { command: "turn off volume" }
        ListElement { command: "[set] volume [to] <number> percent[s]" }
        ListElement { command: "turn (on|off) wi-fi" }
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
            height: commandText.lineCount == 1 ? Theme.itemSizeSmall :
                                                 commandText.lineCount == 2 ? Theme.itemSizeMedium :
                                                                              Theme.itemSizeLarge

            Label {
                id: commandText
                anchors.centerIn: parent
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: command
                wrapMode: Text.WordWrap
            }

            Separator {
                anchors.bottom: parent.bottom
                width: parent.width
                color: Theme.secondaryHighlightColor
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
}
