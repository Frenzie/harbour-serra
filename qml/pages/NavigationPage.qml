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

    property var path

    SilicaListView {
        anchors.fill: parent
        model: path

        header: PageHeader {
            title: qsTr("Path")
        }

        delegate: BackgroundItem {
            id: navigationItem
            width: parent.width
            height: (navigationIcon.height > navigationText.height ?
                        navigationIcon.height : navigationText.height) + 2 * Theme.paddingSmall
            enabled: false

            highlighted: model.modelData.isCurrent
            onHighlightedChanged: if (highlighted) {
                                      var command = navigationText.text.replace(/<\/?b>/g, "")
                                      audio.source = yandexSpeechKitHelper.generateAnswer(command, settings.value("lang"), settings.value("yandexskcKey"))
                                      audio.play()
                                  }

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
                    color: navigationItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
            }

            Component.onCompleted: console.log(model.modelData.maneuver, model.modelData.text)
        }

        VerticalScrollDecorator {}
    }

    Connections {
        target: positionSource
        onPositionChanged: {
            var lat = positionSource.position.coordinate.latitude
            var lng = positionSource.position.coordinate.longitude
            for (var index in path) {
                var _lat = path[index].startLat
                var _lng = path[index].startLng
                var pk = 180 / 3.14169
                var a1 = _lat / pk
                var a2 = _lng / pk
                var b1 = lat / pk
                var b2 = lng / pk
                var t1 = Math.cos(a1) * Math.cos(a2) * Math.cos(b1) * Math.cos(b2)
                var t2 = Math.cos(a1) * Math.sin(a2) * Math.cos(b1) * Math.sin(b2)
                var t3 = Math.sin(a1) * Math.sin(b1)
                var tt = Math.acos(t1 + t2 + t3)
                var l = 6367444.6571225 * tt
                if (!path[index].isCurrent) path[index].isCurrent = l <= 15
            }
        }
    }
}
