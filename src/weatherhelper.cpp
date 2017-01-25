#include "weatherhelper.h"

WeatherHelper::WeatherHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

WeatherHelper::~WeatherHelper() {
    delete _manager;
    _manager = NULL;
}

void WeatherHelper::setLang(QString lang) {
    _lang = lang;
}

void WeatherHelper::getWeatherByCoords(double lat, double lon) {
    QUrlQuery query;
    query.addQueryItem("lat", QString::number(lat));
    query.addQueryItem("lon", QString::number(lon));
    query.addQueryItem("units", "metric");
    query.addQueryItem("lang", _lang.left(2));
    query.addQueryItem("appid", "7b545fb22f8f624ed18b410c964d9c31");
    QUrl url("http://api.openweathermap.org/data/2.5/weather");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));
}

void WeatherHelper::getWeatherByCityName(QString cityName) {
    QUrlQuery query;
    query.addQueryItem("q", cityName);
    query.addQueryItem("units", "metric");
    query.addQueryItem("lang", _lang.left(2));
    query.addQueryItem("appid", "7b545fb22f8f624ed18b410c964d9c31");
    QUrl url("http://api.openweathermap.org/data/2.5/weather");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));
}

void WeatherHelper::getWeatherByCoordsWithDate(double lat, double lon, int dayOffset) {
    _dayOffset = dayOffset;
    QUrlQuery query;
    query.addQueryItem("lat", QString::number(lat));
    query.addQueryItem("lon", QString::number(lon));
    query.addQueryItem("units", "metric");
    query.addQueryItem("lang", _lang.left(2));
    query.addQueryItem("appid", "7b545fb22f8f624ed18b410c964d9c31");
    QUrl url("http://api.openweathermap.org/data/2.5/forecast");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));
}

void WeatherHelper::getWeatherByCityNameWithDate(QString cityName, int dayOffset) {
    _dayOffset = dayOffset;
    QUrlQuery query;
    query.addQueryItem("q", cityName);
    query.addQueryItem("units", "metric");
    query.addQueryItem("lang", _lang.left(2));
    query.addQueryItem("appid", "7b545fb22f8f624ed18b410c964d9c31");
    QUrl url("http://api.openweathermap.org/data/2.5/forecast");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));
}

void WeatherHelper::requestFinished(QNetworkReply *reply) {
//    QString answer = QString("%1 %2 %3. Температура %4 по Цельсию. Ветер %5 м/с. Влажность %6\%");
    QString answer = _lang == "ru-RU" ? _answerRus : _answerEng;
    QString data = reply->readAll();
    QJsonDocument jDoc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject jObj = jDoc.object();
    if (_dayOffset == 0) {
        QString cityName = jObj.value("name").toString();
        QString weatherDescription = jObj.value("weather").toArray().at(0).toObject().value("description").toString();
        if (_lang == "en-US") weatherDescription = "is " + weatherDescription;
        int temp = round(jObj.value("main").toObject().value("temp").toDouble());
        int windSpeed = round(jObj.value("wind").toObject().value("speed").toDouble());
        int humidity = round(jObj.value("main").toObject().value("humidity").toDouble());
        answer = answer.arg(_lang == "ru-RU" ? _inRus : _inEng).arg(cityName)
                .arg(weatherDescription).arg(temp).arg(windSpeed).arg(humidity);
    } else {
        QString cityName = jObj.value("city").toObject().value("name").toString();
        answer = answer.arg(_dayOffset == 1 ?
                                (_lang == "ru-RU" ? _tommorowRus : _tommorowEng) :
                                (_lang == "ru-RU" ? _dayAfterTommorowRus : _dayAfterTommorowEng)).arg(cityName);
        int dateForSearch = QDateTime::currentDateTime().addDays(_dayOffset).toMSecsSinceEpoch() / 1000;
        int dateDelta = dateForSearch;
        QJsonArray list = jObj.value("list").toArray();
        foreach (QJsonValue el, list) {
            int weatherDate = el.toObject().value("dt").toInt();
            if (dateDelta < abs(weatherDate - dateForSearch)) {
                QString weatherDescription = el.toObject().value("weather").toArray().at(0).toObject().value("description").toString();
                int temp = round(el.toObject().value("main").toObject().value("temp").toDouble());
                int windSpeed = round(el.toObject().value("wind").toObject().value("speed").toDouble());
                int humidity = round(el.toObject().value("main").toObject().value("humidity").toDouble());
                if (_lang == "en-US") weatherDescription = "will be " + weatherDescription;
                answer = answer.arg(weatherDescription).arg(temp).arg(windSpeed).arg(humidity);
                break;
            } else dateDelta = abs(weatherDate - dateForSearch);
        }
        _dayOffset = 0;
    }
    emit gotWeather(answer);
}
