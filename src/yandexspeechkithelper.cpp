#include "yandexspeechkithelper.h"

YandexSpeechKitHelper::YandexSpeechKitHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

YandexSpeechKitHelper::~YandexSpeechKitHelper() {
    delete _manager;
    _manager = NULL;
}

void YandexSpeechKitHelper::recognizeQuery(QString path_to_file, QString lang) {
    _isParsing = false;
    QFile *file = new QFile(path_to_file);
    if (file->open(QIODevice::ReadOnly)) {
        QUrlQuery query;
        query.addQueryItem("key", "9d7d557a-99dc-44b2-98c8-596cdf3c5dd3");
        query.addQueryItem("uuid", _buildUniqID());
        query.addQueryItem("topic", "queries");
        query.addQueryItem("lang", lang);
        QUrl url("https://asr.yandex.net/asr_xml");
        url.setQuery(query);
        qDebug() << url;
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "audio/x-wav");
        request.setHeader(QNetworkRequest::ContentLengthHeader, file->size());
        _manager->post(request, file->readAll());
        file->close();
    }
    file->remove();
}

void YandexSpeechKitHelper::parseQuery(QString queryText) {
    _isParsing = true;
    QUrlQuery query;
    query.addQueryItem("key", "9d7d557a-99dc-44b2-98c8-596cdf3c5dd3");
    query.addQueryItem("text", queryText);
    query.addQueryItem("topic", "Date,GeoAddr");
    QUrl url("https://vins-markup.voicetech.yandex.net/markup/0.x/");
    url.setQuery(query);
    QNetworkRequest request(url);
    _manager->get(request);
}

void YandexSpeechKitHelper::requestFinished(QNetworkReply *reply) {
    QUrl url = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    if (url.isEmpty()) {
        QString data = reply->readAll();
        qDebug() << data;
        if (_isParsing) {} else {
            data = data.replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
            _parseResponce(new QXmlStreamReader(data));
        }
    } else {
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::UserAgentHeader,
                          "Mozilla/5.0 (Android; Mobile; rv:50.0) Gecko/50.0 Firefox/50.0");
        _manager->get(request);
    }
}

QString YandexSpeechKitHelper::_buildUniqID() {
    const QString possibleChars("0123456789abcdef");
    const int length = 32;
    QString randomString;
    for (int i = 0; i < length; ++i) {
        int index = qrand() % possibleChars.length();
        QChar nextChar = possibleChars.at(index);
        randomString.append(nextChar);
    }
    return randomString;
}

void YandexSpeechKitHelper::_parseResponce(QXmlStreamReader *element) {
    double idealConfidence = 0;
    QString idealQuery;
    while (!element->atEnd()) {
        element->readNext();
        if (element->tokenType() != QXmlStreamReader::StartElement) continue;
        if (element->name() != "variant") continue;
        QXmlStreamAttribute attr = element->attributes().at(0);
        double confidence = attr.value().toDouble() > 0 ? attr.value().toDouble() : -attr.value().toDouble();
        if (confidence > idealConfidence) {
            idealConfidence = confidence;
            element->readNext();
            idealQuery = element->text().toString();
        }
    }
    if (element->hasError()) qDebug() << element->errorString();
    emit gotResponce(idealQuery);
}
