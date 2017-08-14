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

#ifndef WEATHERHELPER_H
#define WEATHERHELPER_H

#include <QDateTime>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QUrlQuery>
#include <QtMath>

class WeatherHelper : public QObject
{
    Q_OBJECT

public:
    explicit WeatherHelper(QObject *parent = 0);
    ~WeatherHelper();

    Q_INVOKABLE void setLang(QString lang);

    Q_INVOKABLE void getWeatherByCoords(double lat, double lon, QString key);
    Q_INVOKABLE void getWeatherByCityName(QString cityName, QString key);
    Q_INVOKABLE void getWeatherByCoordsWithDate(double lat, double lon, int dayOffset, QString key);
    Q_INVOKABLE void getWeatherByCityNameWithDate(QString cityName, int dayOffset, QString key);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotWeather(QString answer);

private:
    QNetworkAccessManager *_manager;
    int _dayOffset = 0;
    QString _lang = "ru-RU";

    QString _answerRus = "%1 %2 %3. Температура %4 по Цельсию. Ветер %5 м/с. Влажность %6\%";
    QString _answerEng = "%1 %2 %3. Temperature is %4 Celsius. Wind speed is %5 mps. Humidity is %6\%";
    QString _inRus = "В";
    QString _inEng = "In";
    QString _tommorowRus = "Завтра в";
    QString _tommorowEng = "Tomorrow in";
    QString _dayAfterTommorowRus = "Послезавтра в";
    QString _dayAfterTommorowEng = "The day after tomorrow in";
};

#endif // WEATHERHELPER_H
