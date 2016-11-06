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
                label: qsTr("Language:")
                menu: ContextMenu {

                    MenuItem {
                        text: qsTr("Russian")
                        onClicked: {}
                    }

                    MenuItem {
                        text: qsTr("English")
                        onClicked: {}
                    }

                    MenuItem {
                        text: qsTr("Turkish")
                        onClicked: {}
                    }

                    MenuItem {
                        text: qsTr("Ukrainian")
                        onClicked: {}
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }
}





