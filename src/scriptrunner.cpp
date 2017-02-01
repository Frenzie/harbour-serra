#include "scriptrunner.h"

ScriptRunner::ScriptRunner(QObject *parent) : QObject(parent)
{}

void ScriptRunner::runScript(QString script) {
    QProcess process;
    process.startDetached(QString("/bin/bash -c \"%1\"").arg(script));
}
