#ifndef CONTACTSHELPER_H
#define CONTACTSHELPER_H

#include <QStandardPaths>
#include <QObject>
#include <QtSql>

#include <QDebug>

class ContactsHelper : public QObject
{
    Q_OBJECT

public:
    explicit ContactsHelper(QObject *parent = 0);

    Q_INVOKABLE QStringList getPhoneNumbers(const QString& name);
    Q_INVOKABLE QStringList getPhoneNumbers(const QStringList& names);

private:
    QSqlDatabase _sdb;
};

#endif // CONTACTSHELPER_H
