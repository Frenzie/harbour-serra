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

    property var _url

    Image {
        id: imageView
        width: parent.width
        height: width * (sourceSize.height / sourceSize.width)
        fillMode: Image.PreserveAspectFit
        source: _url

        PinchArea {
            anchors.fill: parent
            pinch.target: parent
            pinch.minimumScale: 1
            pinch.maximumScale: 4

            MouseArea {
                anchors.fill: parent
                drag.target: imageView
                drag.axis: Drag.XAndYAxis
                drag.minimumX: (parent.width - imageView.width * imageView.scale) / 2
                drag.minimumY: (parent.height - imageView.height * imageView.scale) / 2
                drag.maximumX: Math.abs(parent.width - imageView.width * imageView.scale) / 2
                drag.maximumY: Math.abs(parent.height - imageView.height * imageView.scale) / 2
                onClicked: drawer.open = !drawer.open
                onPositionChanged: { // TODO
                    console.log(drag.minimumX + " <= " + imageView.x + " <= " + drag.maximumX)
                    console.log(drag.minimumY + " <= " + imageView.y + " <= " + drag.maximumY)
                }
            }
        }
    }
}
