#include "googlesearchhelper.h"

GoogleSearchHelper::GoogleSearchHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

GoogleSearchHelper::~GoogleSearchHelper() {
    delete _manager;
    _manager = NULL;
}

void GoogleSearchHelper::getSearchPage(QString query, bool isNews, int offset) {
    QString urlText = "https://www.google.com/search?q=" + query;
    if (isNews) urlText += "&tbm=nws";
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
        QRegularExpression resultRe("<div class=\"g\">.*?</div>");
        QRegularExpressionMatchIterator resultsIterator = resultRe.globalMatch(data);
        while (resultsIterator.hasNext()) {
            QRegularExpressionMatch result = resultsIterator.next();
            QString resultText = result.captured(0);
            resultText = resultText.replace(QRegularExpression("<b.*?>"), "");
            resultText = resultText.replace(QRegularExpression("</b>"), "");
            qDebug() << resultText;
            SearchResultObject *searchResult = _parseSearchResult(new QXmlStreamReader(resultText));
            if (!searchResult->title().isEmpty() && !searchResult->url().isEmpty())
                _searchResults.append(searchResult);
        }
        emit gotSearchPage(QVariant::fromValue(_searchResults));
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
