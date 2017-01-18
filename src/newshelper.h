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
