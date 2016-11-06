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

    Q_INVOKABLE void getSearchPage(QString query);

public slots:
    void requestFinished(QNetworkReply *reply);

signals:
    void gotAnswer(QString answer);
    void gotSearchPage(QVariant results);

private:
    void _parseWebPage(QXmlStreamReader *element);

    QNetworkAccessManager *_manager;
    QList<QObject*> _searchResults;
};

#endif // GOOGLESEARCHHELPER_H
