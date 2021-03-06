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

#include "commandsparser.h"

CommandsParser::CommandsParser(QObject *parent) : QObject(parent)
{}

void CommandsParser::parseCommand(QString command, QString lang) {
//    qDebug() << lang;
    if (lang.isNull() || lang.isEmpty() || lang == "ru-RU") emit finished(_parseRusCommand(command), command);
    else if (lang == "en-US") emit finished(_parseEngCommand(command), command);
}

int CommandsParser::_parseRusCommand(QString command) {
    if (QRegularExpression("^выключи(ть)? звук$").match(command).hasMatch()) return 1;
    else if (QRegularExpression("^громкость на максимум$").match(command).hasMatch()) return 2;
    else if (QRegularExpression("^постав(ь|(ить)) громкость на максимум$").match(command).hasMatch()) return 2;
    else if (QRegularExpression("^сдела(й|(ть)) громкость на максимум$").match(command).hasMatch()) return 2;
    else if (QRegularExpression("^увелич(ь|(ить))? громкост(ь|и)$").match(command).hasMatch()) return 3;
    else if (QRegularExpression("^уменьш(ь|(ить))? громкост(ь|и)$").match(command).hasMatch()) return 4;
    else if (QRegularExpression("^увелич(ь|(ить))? яркост(ь|и)$").match(command).hasMatch()) return 5;
    else if (QRegularExpression("^уменьш(ь|(ить))? яркост(ь|и)$").match(command).hasMatch()) return 6;
    else if (QRegularExpression("^сдела(й|(ть)) селфи$").match(command).hasMatch()) return 7;
    else if (QRegularExpression("^какие новости (о|(об) )?.*$").match(command).hasMatch()) return 8;
    else if (QRegularExpression("^(какая )?погода$").match(command).hasMatch()) return 9;
    else if (QRegularExpression("^(какая )?погода .*$").match(command).hasMatch()) return 10;
    else if (QRegularExpression("^громкост(ь|и) (на )?[0-9]{1,3} процент((ов)|a)?$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^установи(ть)? громкост(ь|и) (на )?[0-9]{1,3} процент((ов)|a)?$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^сдела(й|(ть)) громкост(ь|и) (на )?[0-9]{1,3} процент((ов)|a)?$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^постав(ь|(ить)) громкост(ь|и) (на )?[0-9]{1,3} процент((ов)|a)?$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^громкост(ь|и) (на )?[0-9]{1,3}%$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^установи(ть)? громкост(ь|и) (на )?[0-9]{1,3}%$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^сдела(й|(ть)) громкост(ь|и) (на )?[0-9]{1,3}%$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^постав(ь|(ить)) громкост(ь|и) (на )?[0-9]{1,3}%$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^включи(ть)? ((wi( |-)?fi)|(вай( |-)?фай))$").match(command).hasMatch()) return 12;
    else if (QRegularExpression("^выключи(ть)? ((wi( |-)?fi)|(вай( |-)?фай))$").match(command).hasMatch()) return 13;
    else if (QRegularExpression("^включи(ть)? ((вспышку)|(фонарик))$").match(command).hasMatch()) return 14;
    else if (QRegularExpression("^выключи(ть)? ((вспышку)|(фонарик))$").match(command).hasMatch()) return 15;
    else if (QRegularExpression("^включи(ть)? ((bluetooth)|(бл[ую]ту[зс]))$").match(command).hasMatch()) return 16;
    else if (QRegularExpression("^выключи(ть)? ((bluetooth)|(бл[ую]ту[зс]))$").match(command).hasMatch()) return 17;
    else if (QRegularExpression("^включи(ть)? gps$").match(command).hasMatch()) return 18;
    else if (QRegularExpression("^выключи(ть)? gps$").match(command).hasMatch()) return 19;
    else if (QRegularExpression("^как ((про)|(до))?ехать до .*$").match(command).hasMatch()) return 20;
    else if (QRegularExpression("^начать$").match(command).hasMatch()) return 21;
    else if (QRegularExpression("^((фотографии)|(картинки)) .*$").match(command).hasMatch()) return 22;
    else if (QRegularExpression("^позвони(ть)? .*$").match(command).hasMatch()) return 23;
    else if (QRegularExpression("^включи(ть)? режим в самолете$").match(command).hasMatch()) return 24;
    else if (QRegularExpression("^авто(матическая )?яркость$").match(command).hasMatch()) return 25;
    else if (QRegularExpression("^(постав(ь|(ить)) )?((нормальный)|(обычный)) шрифт$").match(command).hasMatch()) return 26;
    else if (QRegularExpression("^(постав(ь|(ить)) )?большой шрифт$").match(command).hasMatch()) return 27;
    else if (QRegularExpression("^(постав(ь|(ить)) )?огромный шрифт$").match(command).hasMatch()) return 28;
    else if (QRegularExpression("^включи(ть)? точку доступа$").match(command).hasMatch()) return 29;
    else if (QRegularExpression("^выключи(ть)? точку доступа$").match(command).hasMatch()) return 30;
    else if (QRegularExpression("^покажи расписани[еи]$").match(command).hasMatch()) return 31;
    else if (QRegularExpression("^созда(й|(ть)) заметк[ауи]$").match(command).hasMatch()) return 32;
    else if (QRegularExpression("^откр((ыть)|(ой)) настройк[ауи]$").match(command).hasMatch()) return 33;
    else return 0;
}

int CommandsParser::_parseEngCommand(QString command) {
    if (QRegularExpression("^turn off volume$").match(command).hasMatch()) return 1;
    else if (QRegularExpression("^(set )?volume to maximum$").match(command).hasMatch()) return 2;
    else if (QRegularExpression("^increase volume$").match(command).hasMatch()) return 3;
    else if (QRegularExpression("^decrease volume$").match(command).hasMatch()) return 4;
    else if (QRegularExpression("^increase brightness$").match(command).hasMatch()) return 5;
    else if (QRegularExpression("^decrease brightness$").match(command).hasMatch()) return 6;
    else if (QRegularExpression("^((make)|(do)|(take)) (a )?selfie$").match(command).hasMatch()) return 7;
    else if (QRegularExpression("^what(('|( i))?s)? news (about )?.*$").match(command).hasMatch()) return 8;
    else if (QRegularExpression("^(what(('|( i))?s)? )?weather$").match(command).hasMatch()) return 9;
    else if (QRegularExpression("^(what(('|( i))?s)? )?weather .*$").match(command).hasMatch()) return 10;
    else if (QRegularExpression("^(set )?volume (to )?[0-9]{1,3} percent(s)?$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^(set )?volume (to )?[0-9]{1,3}%$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^turn( |-)?on wi( |-)?fi$").match(command).hasMatch()) return 12;
    else if (QRegularExpression("^turn( |-)?off wi( |-)?fi$").match(command).hasMatch()) return 13;
    else if (QRegularExpression("^turn( |-)?on ((flash( |-)?light)|(torch))$").match(command).hasMatch()) return 14;
    else if (QRegularExpression("^turn( |-)?off ((flash( |-)?light)|(torch))$").match(command).hasMatch()) return 15;
    else if (QRegularExpression("^turn( |-)?on blue( |-)?tooth$").match(command).hasMatch()) return 16;
    else if (QRegularExpression("^turn( |-)?off blue( |-)?tooth$").match(command).hasMatch()) return 17;
    else if (QRegularExpression("^turn( |-)?on gps$").match(command).hasMatch()) return 18;
    else if (QRegularExpression("^turn( |-)?off gps$").match(command).hasMatch()) return 19;
    else if (QRegularExpression("^navigate to .*$").match(command).hasMatch()) return 20;
    else if (QRegularExpression("^start$").match(command).hasMatch()) return 21;
    else if (QRegularExpression("^((photos)|(images)) .*$").match(command).hasMatch()) return 22;
    else if (QRegularExpression("^call .*$").match(command).hasMatch()) return 23;
    else if (QRegularExpression("^turn( |-)?on flight( |-)?mode$").match(command).hasMatch()) return 24;
    else if (QRegularExpression("^auto( )?brightness$").match(command).hasMatch()) return 25;
    else if (QRegularExpression("^(set )?((standard)|(common)) font( |-)?size$").match(command).hasMatch()) return 26;
    else if (QRegularExpression("^(set )?large font( |-)?size$").match(command).hasMatch()) return 27;
    else if (QRegularExpression("^(set )?huge font( |-)?size$").match(command).hasMatch()) return 28;
    else if (QRegularExpression("^turn( |-)?on tethering$").match(command).hasMatch()) return 29;
    else if (QRegularExpression("^turn( |-)?off tethering$").match(command).hasMatch()) return 30;
    else if (QRegularExpression("^show agenda$").match(command).hasMatch()) return 31;
    else if (QRegularExpression("^create ((a )|(the ))?note(s)?$").match(command).hasMatch()) return 32;
    else if (QRegularExpression("^open setting(s)?$").match(command).hasMatch()) return 33;
    else return 0;
}
