#ifndef YANDEXSEARCHHELPER_H
#define YANDEXSEARCHHELPER_H

#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QUrlQuery>

class YandexSearchHelper : public QObject
{
    Q_OBJECT

public:
    explicit YandexSearchHelper(QObject *parent = 0);
    ~YandexSearchHelper();

    Q_INVOKABLE void getHints(QString text);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotHints(QVariantList data);

private:
    QNetworkAccessManager *_manager;
};

#endif // YANDEXSEARCHHELPER_H
