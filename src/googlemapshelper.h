#ifndef GOOGLEMAPSHELPER_H
#define GOOGLEMAPSHELPER_H

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QUrlQuery>

#include "navigationstep.h"

#include <QDebug>

class GoogleMapsHelper : public QObject
{
    Q_OBJECT

public:
    explicit GoogleMapsHelper(QObject *parent = 0);
    ~GoogleMapsHelper();

    Q_INVOKABLE void getDistance(QString origins, QString destinations, QString lang, QString key);
    Q_INVOKABLE void getDirection(QString origins, QString destinations, QString lang, QString key);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotResponce(QString answer);
    void gotPath(QVariant path);

private:
    QNetworkAccessManager *_manager;

    QString _lang;
    QString _dest;
    bool _isDistance;
};

#endif // GOOGLEMAPSHELPER_H
