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

    Q_INVOKABLE QString generateAnswer(QString text, QString lang);
    Q_INVOKABLE void recognizeQuery(QString path_to_file, QString lang);
    Q_INVOKABLE void parseQuery(QString queryText);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotResponce(QString query);
    void gotWeatherData(QString city, int day);

private:
    QString _buildUniqID();
    void _parseResponce(QXmlStreamReader *element);

    QNetworkAccessManager *_manager;
    bool _isParsing = false;
};

#endif // YANDEXSPEECHKITHELPER_H
