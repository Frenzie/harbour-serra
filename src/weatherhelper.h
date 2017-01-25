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
