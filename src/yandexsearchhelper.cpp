/*
  Copyright (C) 2016-2017 Petr Vytovtov
  Contact: Petr Vytovtov <osanwevpk@gmail.com>
  All rights reserved.

  This file is part of Serra for Sailfish OS.

  Serra is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Serra is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Serra. If not, see <http://www.gnu.org/licenses/>.
*/

#include "yandexsearchhelper.h"

YandexSearchHelper::YandexSearchHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

YandexSearchHelper::~YandexSearchHelper() {
    delete _manager;
    _manager = NULL;
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
