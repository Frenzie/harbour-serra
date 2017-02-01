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
