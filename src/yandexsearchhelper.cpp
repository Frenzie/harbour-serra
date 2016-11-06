#include "yandexsearchhelper.h"

YandexSearchHelper::YandexSearchHelper(QObject *parent) : QObject(parent)
{}

void YandexSearchHelper::setNetworkAccessManager(QNetworkAccessManager *mng) {
    _manager = mng;
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

void YandexSearchHelper::getHints(QString text) {
    QUrlQuery query;
    query.addQueryItem("part", text);
    query.addQueryItem("_", QString::number(qrand()));
    QUrl url("https://suggest.yandex.ru/suggest-ya.cgi");
    url.setQuery(query);
    _manager->get(QNetworkRequest(url));
}

void YandexSearchHelper::requestFinished(QNetworkReply *reply) {
    QString data = reply->readAll();
    if (data.startsWith("suggest.apply(")) {
        data = data.replace("suggest.apply(", "").replace(")", "").replace(",[]", "");
        QJsonDocument jDoc = QJsonDocument::fromJson(data.toUtf8());
        QJsonArray jArray = jDoc.array().at(1).toArray();
        emit gotHints(jArray.toVariantList());
    }
}
