#include "newshelper.h"

NewsHelper::NewsHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

NewsHelper::~NewsHelper() {
    delete _manager;
    _manager = NULL;
}

void NewsHelper::getNews() {

}

void NewsHelper::requestFinished(QNetworkReply *reply) {

}
