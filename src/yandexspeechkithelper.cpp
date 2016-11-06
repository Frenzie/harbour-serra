#include "yandexspeechkithelper.h"

YandexSpeechKitHelper::YandexSpeechKitHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

YandexSpeechKitHelper::~YandexSpeechKitHelper() {
    delete _manager;
    _manager = NULL;
}

void YandexSpeechKitHelper::recognizeQuery(QString path_to_file) {
    QFile *file = new QFile(path_to_file);
    if (file->open(QIODevice::ReadOnly)) {
        QUrlQuery query;
        query.addQueryItem("key", "");
        query.addQueryItem("uuid", _buildUniqID());
        query.addQueryItem("topic", "queries");
        QUrl url("https://asr.yandex.net/asr_xml");
        url.setQuery(query);
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "audio/x-wav");
        request.setHeader(QNetworkRequest::ContentLengthHeader, file->size());
        _manager->post(request, file->readAll());
        file->close();
    }
    file->remove();
}

void YandexSpeechKitHelper::requestFinished(QNetworkReply *reply) {
    QUrl url = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    if (url.isEmpty()) {
        QString data = reply->readAll();
        data = data.replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
        qDebug() << data;
        _parseResponce(new QXmlStreamReader(data));
    } else {
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::UserAgentHeader,
                          "Mozilla/5.0 (Android; Mobile; rv:40.0) Gecko/40.0 Firefox/40.0");
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
        if (attr.value().toDouble() > idealConfidence) {
            idealConfidence = attr.value().toDouble();
            element->readNext();
            idealQuery = element->text().toString();
        }
    }
    if (element->hasError()) qDebug() << element->errorString();
    emit gotResponce(idealQuery);
}
