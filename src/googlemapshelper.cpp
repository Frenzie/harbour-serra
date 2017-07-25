#include "googlemapshelper.h"

GoogleMapsHelper::GoogleMapsHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

GoogleMapsHelper::~GoogleMapsHelper() {
    delete _manager;
    _manager = NULL;
}

void GoogleMapsHelper::getDistance(QString origins, QString destinations, QString lang, QString key) {
    _isDistance = true;
    _dest = destinations;
    _lang = lang;
    if (key.isNull() || key.isEmpty()) key = "AIzaSyCo_K5-fAHFVokpCor5NqUB_MpAZcxVHIQ";
    QUrlQuery query;
    query.addQueryItem("origins", origins);
    query.addQueryItem("destinations", destinations);
    query.addQueryItem("language", lang);
    query.addQueryItem("key", key);
    QUrl url("https://maps.googleapis.com/maps/api/distancematrix/json");
    url.setQuery(query);
//    qDebug() << url;
    QNetworkRequest request(url);
    _manager->get(request);
}

void GoogleMapsHelper::getDirection(QString origins, QString destinations, QString lang, QString key) {
    _isDistance = false;
    _dest = destinations;
    _lang = lang;
    if (key.isNull() || key.isEmpty()) key = "AIzaSyDsxLhHB7irwg7PKQBn19syy0BwbMRDfmE";
    QUrlQuery query;
    query.addQueryItem("origin", origins);
    query.addQueryItem("destination", destinations);
    query.addQueryItem("language", lang);
    query.addQueryItem("key", key);
    QUrl url("https://maps.googleapis.com/maps/api/directions/json");
    url.setQuery(query);
//    qDebug() << url;
    QNetworkRequest request(url);
    _manager->get(request);
}

void GoogleMapsHelper::requestFinished(QNetworkReply *reply) {
    QString data = reply->readAll();
//    qDebug() << data;
//    qDebug() << reply->errorString();
    QJsonDocument jDoc = QJsonDocument::fromJson(data.toUtf8());
    if (_isDistance) {
        QJsonArray rows = jDoc.object().value("rows").toArray().at(0).toObject().value("elements").toArray();
        int duration = 0;
        QString text = "";
        foreach (QJsonValue value, rows) {
            QJsonObject jObj = value.toObject();
            int newDuration = jObj.value("duration").toObject().value("value").toInt();
            if (newDuration < duration || duration == 0) {
                duration = newDuration;
                text = jObj.value("duration").toObject().value("text").toString();
            }
        }
        if (duration > 0) {
            QString answer;
            if (_lang == "ru-RU") {
                answer = QString("Дорога до %1 займёт %2\nСкажите \"Начать\" для навигации.").arg(_dest).arg(text);
            } else if (_lang == "en-US") {
                answer = QString("The road to %1 required %2\nSay \"Start\" for navigation.").arg(_dest).arg(text);
            }
            emit gotResponce(answer);
        }
    } else {
        QList<QObject*> navigation;
        QJsonArray legs = jDoc.object().value("routes").toArray().at(0).toObject().value("legs").toArray();
        foreach (QJsonValue value, legs) {
            QJsonArray steps = value.toObject().value("steps").toArray();
            foreach (QJsonValue val2, steps) {
                QJsonObject step = val2.toObject();
                navigation.append(new NavigationStep(step.value("html_instructions").toString(),
                                                     step.value("distance").toObject().value("text").toString(),
                                                     step.value("start_location").toObject().value("lat").toDouble(),
                                                     step.value("start_location").toObject().value("lng").toDouble(),
                                                     step.value("end_location").toObject().value("lat").toDouble(),
                                                     step.value("end_location").toObject().value("lng").toDouble(),
                                                     step.contains("maneuver") ? step.value("maneuver").toString() : ""));
            }
        }
        emit gotPath(QVariant::fromValue(navigation));
    }
}
