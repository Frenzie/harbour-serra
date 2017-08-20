/*
  Copyright (C) 2016-2017 Petr Vytovtov
  Contact: Petr Vytovtov <osanwevpk@gmail.com>
  All rights reserved.

  This file is part of Serra for Sailfish OS.

  Serra is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Serra is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Serra. If not, see <http://www.gnu.org/licenses/>.
*/

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

                Row {
                    anchors.left: parent.left
                    width: parent.width - Theme.horizontalPageMargin
                    height: Math.max(commandValue.height, appsListButton.height)

                    TextField {
                        id: commandValue
                        width: parent.width - appsListButton.width
                        placeholderText: qsTr("Sh-command/file")
                        label: qsTr("Sh-command/file")
                    }

                    Button {
                        id: appsListButton
                        width: Theme.buttonWidthSmall / 3
                        text: "..."
                        onClicked: {
                            var dialog = pageStack.push(Qt.resolvedUrl("ChoosingAppPage.qml"))
                            dialog.accepted.connect(function () {
                                commandText.text = dialog.name
                                commandValue.text = dialog.exec
                            })
                        }
                    }
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
