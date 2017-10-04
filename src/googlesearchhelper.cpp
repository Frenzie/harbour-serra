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

#include "googlesearchhelper.h"

GoogleSearchHelper::GoogleSearchHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

GoogleSearchHelper::~GoogleSearchHelper() {
    delete _manager;
    _manager = NULL;
}

void GoogleSearchHelper::getSearchPage(QString query, bool isNews, bool isImages, int offset) {
    QString urlText = "https://www.google.com/search?q=" + query;
    if (isNews) urlText += "&tbm=nws";
    else if (isImages) urlText += "&tbm=isch";
    _isImages = isImages;
    if (offset > 0) urlText += QString("&start=%1").arg(offset);
    QUrl url(urlText);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      "Mozilla/5.0 (Android; Mobile; rv:50.0) Gecko/50.0 Firefox/50.0");
    _manager->get(request);
}

void GoogleSearchHelper::requestFinished(QNetworkReply *reply) {
    QUrl url = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    if (url.isEmpty()) {
        QString data = reply->readAll();

        QRegularExpression answerRe("<div class=\"_tXc\">.*?</div>");
        QRegularExpressionMatch answer = answerRe.match(data);
        if (!answer.captured(0).isEmpty()) emit gotAnswer(_parseAnswer(answer.captured(0)));

        _searchResults.clear();
        _imagesResult.clear();
        QRegularExpression resultRe(_isImages ? "ct=.*?;" : "<div class=\"g\">.*?</div>");
//        QRegularExpression resultRe("ct=.*?;");
        QRegularExpressionMatchIterator resultsIterator = resultRe.globalMatch(data);
        while (resultsIterator.hasNext()) {
            QRegularExpressionMatch result = resultsIterator.next();
            QString resultText = result.captured(0);
            /*resultText = resultText.replace(QRegularExpression("<b.*?>"), "");
            resultText = resultText.replace(QRegularExpression("</b>"), "");*/
            resultText = resultText.replace(QRegularExpression(_isImages ? "^.*?\\\\x3d" : "<b.*?>"), "");
            resultText = resultText.replace(QRegularExpression(_isImages ? "\\\\.*$" : "</b>"), "");
//            qDebug() << resultText;
            if (_isImages) {
                if (resultText.startsWith("http")) _imagesResult.append(resultText);
            } else {
                SearchResultObject *searchResult = _parseSearchResult(new QXmlStreamReader(resultText));
                if (!searchResult->title().isEmpty() && !searchResult->url().isEmpty())
                    _searchResults.append(searchResult);
            }
        }
        if (_isImages) emit gotImages(_imagesResult);
        else emit gotSearchPage(QVariant::fromValue(_searchResults));
    } else {
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::UserAgentHeader,
                          "Mozilla/5.0 (Android; Mobile; rv:50.0) Gecko/50.0 Firefox/50.0");
        _manager->get(request);
    }
}

QString GoogleSearchHelper::_parseAnswer(QString data) {
    data = data.mid(data.indexOf("<span>"));
    data = data.replace("<span>", "");
    data = data.left(data.indexOf("<a"));
    return data;
}

SearchResultObject* GoogleSearchHelper::_parseSearchResult(QXmlStreamReader *data) {
    bool isTitle = false;
    QString title = "";
    QString url = "";
    while (!data->atEnd()) {
        data->readNext();
        switch (data->tokenType()) {
        case QXmlStreamReader::StartElement:
            if (data->name() == "a") {
                QXmlStreamAttributes attributes = data->attributes();
                foreach (QXmlStreamAttribute attr, attributes) {
                    if (attr.name() == "href" && attr.value().startsWith("/url?q=")) {
                        isTitle = true;
                        url = attr.value().mid(7).toString();
                        url = url.left(url.indexOf("&sa=U"));
                        break;
                    }
                }
            }
            break;
        case QXmlStreamReader::Characters:
            if (isTitle) {
                isTitle = false;
                if (title.isEmpty()) title = data->text().toString();
            }
            break;
        default:
            break;
        }
    }
    if (data->hasError()) qDebug() << data->errorString();
    return new SearchResultObject(title, url);
}
