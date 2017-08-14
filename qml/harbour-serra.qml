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

import QtMultimedia 5.0
import QtQuick 2.0
import QtPositioning 5.2
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0
import "pages"

ApplicationWindow
{
    id: root
    initialPage: Component { SearchPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    property bool isSimpleCommand: true

    signal recognitionStarted()
    signal recognitionFinished()

    function transliterate(text, engToRus) {
        var rus = "щ   ш  ч  ц  ю  я  ё  ж  ъ  ы  э  а б в г д е з и й к л м н о п р с т у ф х ь".split(/ +/g),
            eng = "shh sh ch cz yu ya yo zh `` y' e` a b v g d e z i j k l m n o p r s t u f x `".split(/ +/g);
        for(var x = 0; x < rus.length; x++) {
            text = text.split(engToRus ? eng[x] : rus[x]).join(engToRus ? rus[x] : eng[x]);
            text = text.split(engToRus ? eng[x].toUpperCase() : rus[x].toUpperCase()).join(engToRus ? rus[x].toUpperCase() : eng[x].toUpperCase());
        }
        return text;
    }

    Audio { id: audio }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
    }

    Timer {
        id: recordTimer
        interval: 6000
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            recorder.stopRecord()
            var lang = settings.value("lang")
            if (!lang) lang = "ru-RU"
            yandexSpeechKitHelper.recognizeQuery(recorder.getActualLocation(), lang, settings.value("yandexskcKey"))
            recognitionStarted()
        }
    }

    Notification {
        id: notification
        expireTimeout: 1500
    }
}
