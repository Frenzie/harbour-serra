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

#ifndef COMMANDSPARSER_H
#define COMMANDSPARSER_H

#include <QObject>
#include <QRegularExpression>
#include <QDebug>

class CommandsParser : public QObject
{
    Q_OBJECT

public:
    explicit CommandsParser(QObject *parent = 0);

    Q_INVOKABLE void parseCommand(QString command, QString lang);

signals:
    void finished(int commandCode, QString query);

private:
    int _parseRusCommand(QString command);
    int _parseEngCommand(QString command);
};

#endif // COMMANDSPARSER_H
