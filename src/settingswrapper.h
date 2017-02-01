#ifndef SETTINGSWRAPPER_H
#define SETTINGSWRAPPER_H

#include <QObject>
#include <QSettings>
#include <QStandardPaths>
#include <QString>

#include "commanditem.h"

#include <QDebug>

class SettingsWrapper : public QObject
{
    Q_OBJECT

public:
    explicit SettingsWrapper(QObject *parent = 0);
    ~SettingsWrapper();

    Q_INVOKABLE void setValue(QString key, QString value);
    Q_INVOKABLE QString value(QString key);

    Q_INVOKABLE QVariant getAllCommads();
    Q_INVOKABLE void removeCommand(QString key);
    Q_INVOKABLE void setCommand(QString key, QString value);
    Q_INVOKABLE QString command(QString key);

private:
    QSettings *_settings;
    QSettings *_commands;
};

#endif // SETTINGSWRAPPER_H
