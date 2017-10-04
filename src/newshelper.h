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

#ifndef NEWSHELPER_H
#define NEWSHELPER_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>

class NewsHelper : public QObject
{
    Q_OBJECT

public:
    explicit NewsHelper(QObject *parent = 0);
    ~NewsHelper();

    Q_INVOKABLE void getNews();

public slots:
    void requestFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *_manager;
};

#endif // NEWSHELPER_H
