import QtQuick 2.0
import Sailfish.Silica 1.0

Column {

    property alias searchQueryField: searchQuery
    property alias searchQueryButton: searchButton
    property bool isRecording: false
    property bool isVoiceSearch: false

    signal recordStarted()
    signal searchStarted()

    SilicaListView {
        id: hints
        width: parent.width
        height: contentHeight
        verticalLayoutDirection: ListView.BottomToTop

        model: ListModel {}

        delegate: BackgroundItem {
            id: listItem
            width: parent.width
            height: Theme.itemSizeExtraSmall

            Label {
                id: hintLabel
                anchors.fill: parent
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.rightMargin: Theme.horizontalPageMargin
                font.pixelSize: Theme.fontSizeSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                verticalAlignment: Text.AlignVCenter
                truncationMode: TruncationMode.Fade
                text: hint
            }

            onClicked: {
                isVoiceSearch = false
                searchQueryField.focus = false
                searchQueryField.text = hintLabel.text
                googleSearchHelper.getSearchPage(hintLabel.text)
                searchStarted()
            }
        }
    }

    Item {
        id: controls
        width: parent.width
        height: Theme.iconSizeLarge + 2 * Theme.paddingMedium

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

        TextField {
            id: searchQuery
            anchors.left: parent.left
            anchors.right: searchButton.left
            anchors.verticalCenter: parent.verticalCenter
            placeholderText: qsTr("Search query")
            label: qsTr("Search query")

            onTextChanged: if (focus) yandexSearchHelper.getHints(text)

            EnterKey.enabled: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            EnterKey.onClicked: {
                isVoiceSearch = false
                focus = false
                googleSearchHelper.getSearchPage(text)
                searchStarted()
            }
        }

        IconButton {
            id: searchButton

            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.iconSizeLarge
            height: Theme.iconSizeLarge
            preventStealing: true
            icon.source: {
                if (searchQuery.focus) return "image://theme/icon-m-dismiss"
                else if (isRecording) return "image://theme/icon-m-search"
                else return "image://theme/icon-m-mic"
            }

            onClicked: {
                if (searchQuery.focus) {
                    hints.model.clear()
                    searchQuery.focus = false
                    searchQuery.text = ""
                } else if (settings.value("tapandtalk") === "false") {
                    audio.stop()
                    isRecording = true
                    recorder.startRecord()
                    recordTimer.start()
                    recordStarted()
                }
            }

            onPressed: {
                if (!searchQuery.focus && settings.value("tapandtalk") === "true") {
                    audio.stop()
                    isRecording = true
                    recorder.startRecord()
                    recordStarted()
                }
            }

            onReleased: {
                if (!searchQuery.focus && settings.value("tapandtalk") === "true") {
                    isRecording = false
                    isVoiceSearch = true
                    recorder.stopRecord()
                    var lang = settings.value("lang")
                    if (lang === "") lang = "ru-RU"
                    yandexSpeechKitHelper.recognizeQuery(recorder.getActualLocation(), lang, settings.value("yandexskcKey"))
                    searchStarted()
                }
            }
        }
    }

    Connections {
        target: yandexSearchHelper
        onGotHints: {
            hints.model.clear()
            for (var index = 0; index < data.length; index++) {
                hints.model.append({ hint: data[index] })
                if (index === 3) break
            }
        }
    }

    Connections {
        target: googleSearchHelper
        onGotSearchPage: hints.model.clear()
    }

    Connections {
        target: root
        onRecognitionStarted: {
            isRecording = false
            isVoiceSearch = true
            searchStarted()
        }
    }
}
