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

    Q_INVOKABLE void getWeatherByCoords(double lat, double lon);
    Q_INVOKABLE void getWeatherByCityName(QString cityName);
    Q_INVOKABLE void getWeatherByCoordsWithDate(double lat, double lon, int dayOffset);
    Q_INVOKABLE void getWeatherByCityNameWithDate(QString cityName, int dayOffset);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotWeather(QString answer);

private:
    QNetworkAccessManager *_manager;
    int _dayOffset = 0;
};

#endif // WEATHERHELPER_H
