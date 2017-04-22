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
