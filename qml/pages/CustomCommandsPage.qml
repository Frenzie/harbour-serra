import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    SilicaListView {
        id: commandsList
        anchors.fill: parent
        model: settings.getAllCommads()

        header: PageHeader {
            title: qsTr("User commands")
        }

        delegate: ListItem {
            width: parent.width

            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: command
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    text: model.modelData.key
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    text: model.modelData.value
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    truncationMode: TruncationMode.Fade
                }
            }

            menu: ContextMenu {

                MenuItem {
                    text: qsTr("Remove")
                    onClicked: {
                        settings.removeCommand(command.text)
                        commandsList.model = settings.getAllCommads()
                    }
                }
            }
        }

        footer: Item {
            width: parent.width
            height: footerContent.height

            Column {
                id: footerContent
                width: parent.width

                Separator {
                    width: parent.width
                }

                TextField {
                    id: commandText
                    width: parent.width
                    font.capitalization: Font.AllLowercase
                    placeholderText: qsTr("Command text")
                    label: qsTr("Command text")
                }

                TextField {
                    id: commandValue
                    width: parent.width
                    placeholderText: qsTr("Sh-command/file")
                    label: qsTr("Sh-command/file")
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Theme.buttonWidthMedium
                    text: qsTr("Add command")
                    onClicked: {
                        settings.setCommand(commandText.text.toLowerCase(), commandValue.text)
                        commandsList.model = settings.getAllCommads()
                        commandText.text = ""
                        commandValue.text = ""
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: console.log(settings.getAllCommads())
}
