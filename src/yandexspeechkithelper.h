#ifndef YANDEXSPEECHKITHELPER_H
#define YANDEXSPEECHKITHELPER_H

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

    Q_INVOKABLE void recognizeQuery(QString path_to_file, QString lang);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotResponce(QString query);

private:
    QString _buildUniqID();
    void _parseResponce(QXmlStreamReader *element);

    QNetworkAccessManager *_manager;
};

#endif // YANDEXSPEECHKITHELPER_H
