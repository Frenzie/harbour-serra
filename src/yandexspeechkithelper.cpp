#include "yandexspeechkithelper.h"

YandexSpeechKitHelper::YandexSpeechKitHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

YandexSpeechKitHelper::~YandexSpeechKitHelper() {
    delete _manager;
    _manager = NULL;
}

QString YandexSpeechKitHelper::generateAnswer(QString text, QString lang, QString key) {
    if (key.isNull() || key.isEmpty()) key = "9d7d557a-99dc-44b2-98c8-596cdf3c5dd3";
    return "https://tts.voicetech.yandex.net/generate?text=\"" + text +
            "\"&format=mp3&lang=" + lang + "&speaker=jane&emotion=good&key=" + key;
}

void YandexSpeechKitHelper::recognizeQuery(QString path_to_file, QString lang, QString key) {
    if (key.isNull() || key.isEmpty()) key = "9d7d557a-99dc-44b2-98c8-596cdf3c5dd3";
    _isParsing = false;
    _isName = false;
    QFile *file = new QFile(path_to_file);
    if (file->open(QIODevice::ReadOnly)) {
        QUrlQuery query;
        query.addQueryItem("key", key);
        query.addQueryItem("uuid", _buildUniqID());
        query.addQueryItem("topic", "queries");
        query.addQueryItem("lang", lang);
        QUrl url("https://asr.yandex.net/asr_xml");
        url.setQuery(query);
//        qDebug() << url;
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "audio/x-speex");
        request.setHeader(QNetworkRequest::ContentLengthHeader, file->size());
        _manager->post(request, file->readAll());
        file->close();
    }
    file->remove();
}

void YandexSpeechKitHelper::parseQuery(QString queryText, QString key) {
    if (key.isNull() || key.isEmpty()) key = "9d7d557a-99dc-44b2-98c8-596cdf3c5dd3";
    _isParsing = true;
    QUrlQuery query;
    query.addQueryItem("key", key);
    query.addQueryItem("text", queryText);
    query.addQueryItem("topic", "Date,GeoAddr");
    QUrl url("https://vins-markup.voicetech.yandex.net/markup/0.x/");
    url.setQuery(query);
//    qDebug() << url;
    QNetworkRequest request(url);
    _manager->get(request);
}

void YandexSpeechKitHelper::parseName(QString name, QString key) {
    if (key.isNull() || key.isEmpty()) key = "9d7d557a-99dc-44b2-98c8-596cdf3c5dd3";
    _isName = true;
    QUrlQuery query;
    query.addQueryItem("key", key);
    query.addQueryItem("text", name);
    query.addQueryItem("topic", "Name");
    QUrl url("https://vins-markup.voicetech.yandex.net/markup/0.x/");
    url.setQuery(query);
    QNetworkRequest request(url);
    _manager->get(request);
}

void YandexSpeechKitHelper::requestFinished(QNetworkReply *reply) {
    QUrl url = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    if (url.isEmpty()) {
        QString data = reply->readAll();
//        qDebug() << data;
        qDebug() << reply->errorString();
        if (_isParsing) {
            QJsonDocument jDoc = QJsonDocument::fromJson(data.toUtf8());
            QJsonArray date = jDoc.object().value("Date").toArray();
            int dayOffset = date.at(0).toObject().value("Day").toInt();
            QJsonArray geoAddr = jDoc.object().value("GeoAddr").toArray().at(0).toObject().value("Fields").toArray();
            QString cityName = geoAddr.at(0).toObject().value("Name").toString();
            emit gotWeatherData(cityName, dayOffset);
        } if (_isName) {
            QStringList result;
            QJsonObject jObj = QJsonDocument::fromJson(data.toUtf8()).object();
            /*if (jObj.contains("Fio")) {
                //
            } else*/ if (jObj.contains("Morph")) {
                QJsonArray morphs = jObj.value("Morph").toArray();
                foreach (QJsonValue val1, morphs) {
                    int length = result.size();
                    if (length == 0) foreach (QJsonValue val2, val1.toObject().value("Lemmas").toArray()) result.append(val2.toObject().value("Text").toString());
                    else for (int counter = 0; counter < length; ++counter) {
                        QString name = result.takeFirst();
                        foreach (QJsonValue val2, val1.toObject().value("Lemmas").toArray())
                            result.append(name + " " + val2.toObject().value("Text").toString());
                    }
                }
            } else result.append(jObj.value("OriginalRequest").toString());
            emit gotNames(result);
        } else {
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
