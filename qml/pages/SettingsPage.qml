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

//            SectionHeader {
//                text: qsTr("News settings")
//            }

//            ComboBox {
//                width: parent.width
//                label: qsTr("News language:")
//                menu: ContextMenu {

//                    MenuItem {
//                        text: qsTr("English")
//                        onClicked: {}
//                    }

//                    MenuItem {
//                        text: qsTr("German")
//                        onClicked: {}
//                    }

//                    MenuItem {
//                        text: qsTr("French")
//                        onClicked: {}
//                    }

//                    MenuItem {
//                        text: qsTr("Italian")
//                        onClicked: {}
//                    }

//                    MenuItem {
//                        text: qsTr("Espaniol")
//                        onClicked: {}
//                    }

//                    MenuItem {
//                        text: qsTr("Portugalian")
//                        onClicked: {}
//                    }
//                }
//            }
        }

        VerticalScrollDecorator {}
    }
}





