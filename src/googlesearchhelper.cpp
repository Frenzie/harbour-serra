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

//        data = data.mid(data.indexOf("<body"));
//        data = data.replace("</html>", "");
//        data = data.replace(QRegularExpression("<form.*?</form>"), "");
//        data = data.replace(QRegularExpression("<script.*?</script>"), "");
//        data = data.replace(QRegularExpression("<img.*?>"), "");
//        data = data.replace("<wbr>", "");
//        data = data.replace("<br>", "");
//        data = data.replace("<hr>", "");
//        data = data.replace("&raquo;", "");
//        data = data.replace("&middot;", "");
//        data = data.replace("&nbsp;", " ");
//        _parseWebPage(new QXmlStreamReader(data));
    } else {
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::UserAgentHeader,
                          "Mozilla/5.0 (Android; Mobile; rv:40.0) Gecko/40.0 Firefox/40.0");
        _manager->get(request);
    }
}

//void GoogleSearchHelper::_parseWebPage(QXmlStreamReader *element) {
//    _searchResults.clear();
//    bool answerFlag = false;
//    bool searchResultFlag = false;
//    QString answer = "";
//    QString searchUrl = "";

//    while (!element->atEnd()) {
//        element->readNext();
//        if (element->tokenType() == QXmlStreamReader::StartElement) {
//            if (element->name() != "div" && element->name() != "a") continue;
//            QXmlStreamAttributes attributes = element->attributes();
//            foreach (QXmlStreamAttribute attr, attributes) {
//                if (attr.name() == "class" && attr.value() == "_o0d") answerFlag = true;
//                if (element->name() == "a" && attr.name() == "class" && attr.value() == "fl") {
//                    searchResultFlag = false;
//                    searchUrl == "";
//                    break;
//                }
//                if (element->name() == "a" && attr.name() == "href" &&
//                        attr.value().startsWith("/url?q=")) {
//                    searchResultFlag = true;
//                    searchUrl = attr.value().mid(7).toString();
//                    searchUrl = searchUrl.left(searchUrl.indexOf("&sa=U"));
//                }
//            }
//        } else if (element->tokenType() == QXmlStreamReader::Characters) {
//            if (answerFlag) {
//                QString data = element->text().toString();
//                if (data.replace(QRegularExpression(" *"), "").isEmpty()) continue;
//                answerFlag = false;
//                if (answer.length() < element->text().length()) answer = element->text().toString();
//            } else if (searchResultFlag) {
//                QString title = element->text().toString();
//                if (!searchUrl.isEmpty() && title.replace(QRegExp(" *"), "").length() != 0) {
//                    _searchResults.append(
//                                new SearchResultObject(element->text().toString(), searchUrl));
//                    searchUrl = "";
//                }
//                searchResultFlag = false;
//            }
//        }
//    }
//    if (element->hasError()) qDebug() << element->errorString();

//    emit gotSearchPage(QVariant::fromValue(_searchResults));
//    if (!answer.isEmpty()) emit gotAnswer(answer);
//}

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
