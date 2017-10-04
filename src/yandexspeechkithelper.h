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

#ifndef YANDEXSPEECHKITHELPER_H
#define YANDEXSPEECHKITHELPER_H

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QUrlQuery>
#include <QXmlStreamReader>

#include <QDebug>

class YandexSpeechKitHelper : public QObject
{
    Q_OBJECT

public:
    explicit YandexSpeechKitHelper(QObject *parent = 0);
    ~YandexSpeechKitHelper();

    Q_INVOKABLE QString generateAnswer(QString text, QString lang, QString key);
    Q_INVOKABLE void recognizeQuery(QString path_to_file, QString lang, QString key);
    Q_INVOKABLE void parseQuery(QString queryText, QString key);
    Q_INVOKABLE void parseName(QString name, QString key);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotResponce(QString query);
    void gotWeatherData(QString city, int day);
    void gotNames(QStringList names);

private:
    QString _buildUniqID();
    void _parseResponce(QXmlStreamReader *element);

    QNetworkAccessManager *_manager;
    bool _isName = false;
    bool _isParsing = false;
};

#endif // YANDEXSPEECHKITHELPER_H
