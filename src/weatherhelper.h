#ifndef WEATHERHELPER_H
#define WEATHERHELPER_H

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

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotWeather(QString answer);

private:
    QNetworkAccessManager *_manager;
};

#endif // WEATHERHELPER_H
