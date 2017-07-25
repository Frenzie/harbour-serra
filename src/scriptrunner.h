#ifndef SCRIPTRUNNER_H
#define SCRIPTRUNNER_H

#include <QObject>
#include <QProcess>

class ScriptRunner : public QObject
{
    Q_OBJECT

public:
    explicit ScriptRunner(QObject *parent = 0);

    Q_INVOKABLE void runScript(QString script);
};

#endif // SCRIPTRUNNER_H
