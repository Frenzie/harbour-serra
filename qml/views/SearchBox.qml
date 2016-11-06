import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root

    property alias searchQueryField: searchQuery
    property alias searchQueryButton: searchButton

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
                searchQueryField.focus = false
                searchQueryField.text = hintLabel.text
                googleSearchHelper.getSearchPage(hintLabel.text)
                hints.model.clear()
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
                focus = false
                googleSearchHelper.getSearchPage(text)
                hints.model.clear()
                searchStarted()
            }
        }

        IconButton {
            id: searchButton

            property bool isRecording: false

            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.iconSizeLarge
            height: Theme.iconSizeLarge
            icon.source: isRecording || searchQuery.focus ? "image://theme/icon-m-search" :
                                                            "image://theme/icon-m-mic"

            onClicked: {
                if (searchQuery.focus) {
                    yandexSpeechKitHelper.getSearchPage(searchQuery.text)
                    searchStarted()
                } else if (isRecording) {
                    isRecording = false
                    recorder.stopRecord()
                    yandexSpeechKitHelper.recognizeQuery(recorder.getActualLocation())
                    searchStarted()
                } else {
                    isRecording = true
                    recorder.startRecord()
                    recordStarted()
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
}
