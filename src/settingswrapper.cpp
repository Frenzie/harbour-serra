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
