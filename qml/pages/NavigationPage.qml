import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    property var path

    SilicaListView {
        anchors.fill: parent
        model: path

        header: PageHeader {
            title: qsTr("Path")
        }

        delegate: Item {
            width: parent.width
            height: (navigationIcon.height > navigationText.height ?
                        navigationIcon.height : navigationText.height) + 2 * Theme.paddingSmall

            Row {
                anchors.centerIn: parent
                width: parent.width - 2 * Theme.horizontalPageMargin
                spacing: Theme.paddingLarge

                Image {
                    id: navigationIcon
                    width: Theme.iconSizeMedium
                    height: Theme.iconSizeMedium
                    source: {
                        var iconSource = ""
                        switch (model.modelData.maneuver) {
                        case "turn-right":
                        case "ramp-right":
                        case "keep-right":
                        case "roundabout-right":
                        case "turn-slight-right":
                            iconSource = "icon-m-rotate-right"
                            break
                        case "turn-left":
                        case "ramp-left":
                        case "keep-left":
                        case "roundabout-left":
                        case "turn-slight-left":
                            iconSource = "icon-m-rotate-left"
                            break
                        case "merge":
                        case "straight":
                        default:
                            iconSource = "icon-m-page-up"
                            break
                        }
                        return "image://theme/" + iconSource
                    }
                }

                Label {
                    id: navigationText
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - Theme.iconSizeMedium - Theme.paddingLarge
                    wrapMode: Text.WordWrap
                    text: model.modelData.text + " (" + model.modelData.distance + ")"
                }
            }

            Component.onCompleted: console.log(model.modelData.maneuver, model.modelData.text)
        }

        VerticalScrollDecorator {}
    }
}
