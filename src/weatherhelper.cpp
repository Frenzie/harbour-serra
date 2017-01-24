#include "weatherhelper.h"

WeatherHelper::WeatherHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

WeatherHelper::~WeatherHelper() {
    delete _manager;
    _manager = NULL;
}

void WeatherHelper::getWeatherByCoords(double lat, double lon) {
    QUrlQuery query;
    query.addQueryItem("lat", QString::number(lat));
    query.addQueryItem("lon", QString::number(lon));
    query.addQueryItem("units", "metric");
    query.addQueryItem("lang", "ru");
    query.addQueryItem("appid", "7b545fb22f8f624ed18b410c964d9c31");
    QUrl url("http://api.openweathermap.org/data/2.5/weather");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));

}

void WeatherHelper::requestFinished(QNetworkReply *reply) {
    QString data = reply->readAll();
    QJsonDocument jDoc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject jObj = jDoc.object();
    QString cityName = jObj.value("name").toString();
    QString weatherDescription = jObj.value("weather").toArray().at(0).toObject().value("description").toString();
    int temp = round(jObj.value("main").toObject().value("temp").toDouble());
    int windSpeed = round(jObj.value("wind").toObject().value("speed").toDouble());
    int humidity = round(jObj.value("main").toObject().value("humidity").toDouble());
    QString answer = QString("В %1 %2. Температура %3 по Цельсию. Ветер %4 м/с. Влажность %5\%")
            .arg(cityName).arg(weatherDescription).arg(temp).arg(windSpeed).arg(humidity);
    emit gotWeather(answer);
}
