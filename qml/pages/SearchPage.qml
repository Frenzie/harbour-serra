import QtQuick 2.0
import Sailfish.Silica 1.0

import "../views"


Page {
    id: page

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
        onGotAnswer: listView.headerItem.text = answer
        onGotSearchPage: listView.model = results
    }

    Connections {
        target: yandexSpeechKitHelper
        onGotResponce: {
            searchBox.searchQueryField.text = query
            googleSearchHelper.getSearchPage(query)
        }
    }
}
