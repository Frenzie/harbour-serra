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
