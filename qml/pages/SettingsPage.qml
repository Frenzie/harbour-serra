import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu {

            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            PageHeader {
                title: qsTr("Settings")
            }

            ComboBox {
                width: parent.width
                label: qsTr("Search and commands language:")
                currentIndex: {
                    switch (settings.value("lang")) {
                    case "ru-RU":
                        return 0;
                    case "en-US":
                        return 1;
//                    case "tr-TR":
//                        return 2;
//                    case "uk-UK":
//                        return 3;
                    default:
                        return 0;
                    }
                }

                menu: ContextMenu {

                    MenuItem {
                        text: qsTr("Russian")
                        onClicked: {
                            settings.setValue("lang", "ru-RU")
                            weatherHelper.setLang(settings.value("lang"))
                        }
                    }

                    MenuItem {
                        text: qsTr("English")
                        onClicked: {
                            settings.setValue("lang", "en-US")
                            weatherHelper.setLang(settings.value("lang"))
                        }
                    }

//                    MenuItem {
//                        text: qsTr("Turkish")
//                        onClicked: settings.setValue("lang", "tr-TR")
//                    }

//                    MenuItem {
//                        text: qsTr("Ukrainian")
//                        onClicked: settings.setValue("lang", "uk-UK")
//                    }
                }
            }

            TextSwitch {
                checked: settings.value("tapandtalk") === "true"
                text: qsTr("Tap-and-talk mode")
                description: qsTr("If this is active your voice command can be as long as long you hold button on the main screen. Otherwise standard time for voice commands is 6 seconds.")
                onCheckedChanged: settings.setValue("tapandtalk", checked ? "true" : "false")
            }

            SectionHeader {
                text: qsTr("API keys")
            }

            TextField {
                width: parent.width
                text: settings.value("yandexskcKey")
                placeholderText: "Yandex SpeechKit Cloud API key"
                label: "Yandex SpeechKit Cloud API key"
                onTextChanged: settings.setValue("yandexskcKey", text)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2 * Theme.horizontalPageMargin
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
                text: qsTr("If you notice problems with speech recognition, you can get your personal key <a href=\"https://developer.tech.yandex.ru/\">here</a> and use it.")
            }

            TextField {
                width: parent.width
                text: settings.value("weatherKey")
                placeholderText: "Open Weather Map API key"
                label: "Open Weather Map API key"
                onTextChanged: settings.setValue("weatherKey", text)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2 * Theme.horizontalPageMargin
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
                text: qsTr("If you notice problems with getting weather information, you can get your personal key <a href=\"http://openweathermap.org/api\">here</a> and use it.")
            }
        }

        VerticalScrollDecorator {}
    }
}





