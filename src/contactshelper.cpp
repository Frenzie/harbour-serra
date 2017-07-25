#include "contactshelper.h"

ContactsHelper::ContactsHelper(QObject *parent) : QObject(parent) {
    _sdb = QSqlDatabase::addDatabase("QSQLITE");
    _sdb.setDatabaseName("/home/nemo/.local/share/system/Contacts/qtcontacts-sqlite/contacts.db");
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
