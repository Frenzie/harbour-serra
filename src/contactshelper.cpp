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

#include "contactshelper.h"

ContactsHelper::ContactsHelper(QObject *parent) : QObject(parent) {
    _sdb = QSqlDatabase::addDatabase("QSQLITE");
    _sdb.setDatabaseName(QString("%1/.local/share/system/Contacts/qtcontacts-sqlite/contacts.db")
                         .arg(QDir::homePath()));
}

QStringList ContactsHelper::getPhoneNumbers(const QString &name) {
    QStringList numbers;
    if (_sdb.open()) {
        QSqlQuery query;
        query.prepare("SELECT PhoneNumbers.phoneNumber FROM PhoneNumbers JOIN Contacts "
                      "WHERE Contacts.contactId=PhoneNumbers.contactId AND lower(displayLabel)=?");
        query.bindValue(0, name);
        query.exec();
        while (query.next()) numbers.append(query.value(0).toString());
        _sdb.close();
    }
    return numbers;
}

QStringList ContactsHelper::getPhoneNumbers(const QStringList &names) {
    QStringList numbers;
    if (_sdb.open()) {
        QSqlQuery query;
        query.prepare("SELECT PhoneNumbers.phoneNumber FROM PhoneNumbers JOIN Contacts "
                      "WHERE Contacts.contactId=PhoneNumbers.contactId AND "
                      "lower(displayLabel) REGEXP ?");
        query.bindValue(0, "(" + names.join(")|(") + ")");
        query.exec();
        while (query.next()) numbers.append(query.value(0).toString());
        _sdb.close();
    }
    return numbers;
}
