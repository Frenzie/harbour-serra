#include "commandsparser.h"

CommandsParser::CommandsParser(QObject *parent) : QObject(parent)
{}

void CommandsParser::parseCommand(QString command, QString lang) {
    if (lang == "ru-RU") emit finished(_parseRusCommand(command), command);
    else if (lang == "en-US") emit finished(_parseEngCommand(command), command);
}

int CommandsParser::_parseRusCommand(QString command) {
    if (QRegularExpression("^выключи(ть)? звук$").match(command).hasMatch()) return 1;
    else if (QRegularExpression("^((постав(ь|(ить)))|(сдела(й|(ть))) )?громкость на максимум$").match(command).hasMatch()) return 2;
    else if (QRegularExpression("^увеличи(ть)? громкость$").match(command).hasMatch()) return 3;
    else if (QRegularExpression("^уменьши(ть)? громкость$").match(command).hasMatch()) return 4;
    else if (QRegularExpression("^увеличи(ть)? яркость$").match(command).hasMatch()) return 5;
    else if (QRegularExpression("^уменьши(ть)? яркость$").match(command).hasMatch()) return 6;
    else if (QRegularExpression("^сдела(й|(ть)) селфи$").match(command).hasMatch()) return 7;
    else if (QRegularExpression("^какие новости (о|(об) )?.*$").match(command).hasMatch()) return 8;
    else if (QRegularExpression("^(какая )?погода$").match(command).hasMatch()) return 9;
    else if (QRegularExpression("^(какая )?погода .*$").match(command).hasMatch()) return 10;
    else if (QRegularExpression("^((постав(ь|(ить)))|(сдела(й|(ть)))|(установи(ть)?) )?громкость (на )?[0-9]{1,3} процент((ов)|a)?$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^включи(ть)? ((wi( |-)?fi)|(вай фай))$").match(command).hasMatch()) return 12;
    else if (QRegularExpression("^выключи(ть)? ((wi( |-)?fi)|(вай фай))$").match(command).hasMatch()) return 13;
    else return 0;
}

int CommandsParser::_parseEngCommand(QString command) {
    if (QRegularExpression("^turn off volume$").match(command).hasMatch()) return 1;
    else if (QRegularExpression("^(set )?volume to maximum$").match(command).hasMatch()) return 2;
    else if (QRegularExpression("^increase volume$").match(command).hasMatch()) return 3;
    else if (QRegularExpression("^decrease volume$").match(command).hasMatch()) return 4;
    else if (QRegularExpression("^increase brightness$").match(command).hasMatch()) return 5;
    else if (QRegularExpression("^decrease brightness$").match(command).hasMatch()) return 6;
    else if (QRegularExpression("^((make)|(do)|(take)) (a)?selfie$").match(command).hasMatch()) return 7;
    else if (QRegularExpression("^what(('|( i))?s)? news (about )?.*$").match(command).hasMatch()) return 8;
    else if (QRegularExpression("^(what(('|( i))?s)? )?weather$").match(command).hasMatch()) return 9;
    else if (QRegularExpression("^(what(('|( i))?s)? )?weather .*$").match(command).hasMatch()) return 10;
    else if (QRegularExpression("^(set )?volume (to )?[0-9]{1,3} percent(s)?$").match(command).hasMatch()) return 11;
    else if (QRegularExpression("^turn( |-)?on wi( |-)?fi$").match(command).hasMatch()) return 12;
    else if (QRegularExpression("^turn( |-)?off wi( |-)?fi$").match(command).hasMatch()) return 13;
    else return 0;
}
