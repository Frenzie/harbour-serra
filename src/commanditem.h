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

#ifndef COMMANDITEM_H
#define COMMANDITEM_H

#include <QObject>

class CommandItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString key READ key)
    Q_PROPERTY(QString value READ value)

public:
    explicit CommandItem(QObject *parent = 0);
    CommandItem(QString key, QString value);

public slots:
    QString key() { return _key; }
    QString value() { return _value; }

private:
    QString _key;
    QString _value;
};

#endif // COMMANDITEM_H
