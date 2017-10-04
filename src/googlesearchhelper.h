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

#ifndef GOOGLESEARCHHELPER_H
#define GOOGLESEARCHHELPER_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QRegularExpression>
#include <QXmlStreamReader>

#include "searchresultobject.h"

class GoogleSearchHelper : public QObject
{
    Q_OBJECT

public:
    explicit GoogleSearchHelper(QObject *parent = 0);
    ~GoogleSearchHelper();

    Q_INVOKABLE void getSearchPage(QString query, bool isNews = false, bool isImages = false, int offset = 0);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotAnswer(QString answer);
    void gotSearchPage(QVariant results);
    void gotImages(QStringList images);

private:
//    void _parseWebPage(QXmlStreamReader *element);
    QString _parseAnswer(QString data);
    SearchResultObject* _parseSearchResult(QXmlStreamReader *data);

    QNetworkAccessManager *_manager;
    QList<QObject*> _searchResults;
    QStringList _imagesResult;
    bool _isImages = false;
};

#endif // GOOGLESEARCHHELPER_H
