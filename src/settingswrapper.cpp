#include "settingswrapper.h"

SettingsWrapper::SettingsWrapper(QObject *parent) : QObject(parent) {
    _settings = new QSettings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) +
                              "/harbour-serra/harbour-serra.conf", QSettings::NativeFormat);
    _commands = new QSettings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) +
                              "/harbour-serra/harbour-serra-commands.conf", QSettings::NativeFormat);
}

SettingsWrapper::~SettingsWrapper() {
    delete _settings;
    delete _commands;
}

void SettingsWrapper::setValue(QString key, QString value) {
    _settings->setValue(key, value);
}

QString SettingsWrapper::value(QString key) {
    return _settings->value(key).toString();
}

QVariant SettingsWrapper::getAllCommads() {
    QStringList keys = _commands->allKeys();
    QList<QObject*> data;
    foreach (QString key, keys) data.append(new CommandItem(key, _commands->value(key).toString()));
    return QVariant::fromValue(data);
}

void SettingsWrapper::removeCommand(QString key) {
    _commands->remove(key);
}

void SettingsWrapper::setCommand(QString key, QString value) {
    _commands->setValue(key, value);
}

QString SettingsWrapper::command(QString key) {
    return _commands->value(key).toString();
}
