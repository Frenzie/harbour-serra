#ifndef VKSTREAM_H
#define VKSTREAM_H

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QUrlQuery>

#include <QDebug>

class VkStream : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString endpoint READ endpoint NOTIFY endpointChanged)
    Q_PROPERTY(QString key READ key NOTIFY keyChanged)

    enum RequestMode {OPEN, GET, SET, DELETE, STREAM};

public:
    explicit VkStream(QObject *parent = 0);
    ~VkStream();

    Q_INVOKABLE void openStream();
    Q_INVOKABLE void getRules();
    Q_INVOKABLE void setRule();
//    Q_INVOKABLE void deleteRule();
    Q_INVOKABLE void getStream();

    Q_INVOKABLE QString endpoint() { return _endpoint; }
    Q_INVOKABLE QString key() { return _key; }

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void endpointChanged(QString endpoint);
    void keyChanged(QString key);

private:
    const QString ACCESS_TOKEN = "fe9ed733fe9ed733fe9ed7334ffec39deeffe9efe9ed733a7f7d09e07a49dd44635b101";

    QNetworkAccessManager *_manager;
    QString _endpoint;
    QString _key;
    RequestMode _mode;
};

#endif // VKSTREAM_H
