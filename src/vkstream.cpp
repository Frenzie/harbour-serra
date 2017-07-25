#include "vkstream.h"

VkStream::VkStream(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

VkStream::~VkStream() {
    delete _manager;
    _manager = NULL;
}

void VkStream::openStream() {
    _mode = OPEN;
    QUrlQuery query;
    query.addQueryItem("access_token", ACCESS_TOKEN);
    query.addQueryItem("v", "5.67");
    QUrl url("https://api.vk.com/method/streaming.getServerUrl");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));
}

void VkStream::getRules() {
    _mode = GET;
    QUrlQuery query;
    query.addQueryItem("key", _key);
    QUrl url("https://" + _endpoint + "/rules");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));
}

void VkStream::setRule() {
    _mode = SET;
    QUrlQuery query;
    query.addQueryItem("key", _key);
    QUrl url("https://" + _endpoint + "/rules");
    url.setQuery(query);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    _manager->post(request, QString("{\"rule\": {\"value\": \"machine learning\", \"tag\": \"1\"}}").toUtf8());
}

void VkStream::getStream() {
    _mode = STREAM;
    QUrlQuery query;
    query.addQueryItem("key", _key);
    QUrl url("wss://" + _endpoint + "/stream");
    url.setQuery(query);
    QNetworkRequest request(url);
    request.setRawHeader(QString("Connection").toUtf8(), QString("upgrade").toUtf8());
    request.setRawHeader(QString("Upgrade").toUtf8(), QString("websocket").toUtf8());
    request.setRawHeader(QString("Sec-Websocket-Version").toUtf8(), QString("13").toUtf8());
    _manager->get(QNetworkRequest(url));
}

void VkStream::requestFinished(QNetworkReply *reply) {
    QString data = reply->readAll();
    QJsonDocument jDoc = QJsonDocument::fromJson(data.toUtf8());
    switch (_mode) {
    case OPEN: {
        QJsonObject response = jDoc.object().value("response").toObject();
        _endpoint = response.value("endpoint").toString();
        _key = response.value("key").toString();
        emit endpointChanged(_endpoint);
        emit keyChanged(_key);
        getRules();
        break;
    }

    case GET: {
        QJsonArray rules = jDoc.object().value("rules").toArray();
        qDebug() << rules << rules.size();
        if (rules.size() == 0) setRule();
        else getStream();
        break;
    }

    case SET: {
        qDebug() << jDoc;
        getRules();
        break;
    }

    case DELETE: {
        break;
    }

    case STREAM: {
        qDebug() << jDoc;
        break;
    }

    default:
        break;
    }
}
