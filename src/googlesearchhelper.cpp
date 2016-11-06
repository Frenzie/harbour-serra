#include "googlesearchhelper.h"

GoogleSearchHelper::GoogleSearchHelper(QObject *parent) : QObject(parent) {
    _manager = new QNetworkAccessManager(this);
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

GoogleSearchHelper::~GoogleSearchHelper() {
    delete _manager;
    _manager = NULL;
}

void GoogleSearchHelper::getSearchPage(QString query) {
    QNetworkRequest request(QUrl("https://www.google.com/search?q=" + query));
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      "Mozilla/5.0 (Android; Mobile; rv:40.0) Gecko/40.0 Firefox/40.0");
    _manager->get(request);
}

void GoogleSearchHelper::requestFinished(QNetworkReply *reply) {
    QUrl url = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    if (url.isEmpty()) {
        QString data = reply->readAll();
        data = data.mid(data.indexOf("<body"));
        data = data.replace("</html>", "");
        data = data.replace(QRegularExpression("<form.*?</form>"), "");
        data = data.replace(QRegularExpression("<script.*?</script>"), "");
        data = data.replace(QRegularExpression("<img.*?>"), "");
        data = data.replace(QRegularExpression("<b.*?>"), "");
        data = data.replace(QRegularExpression("</b>"), "");
        data = data.replace("<wbr>", "");
        data = data.replace("<br>", "");
        data = data.replace("<hr>", "");
        data = data.replace("&raquo;", "");
        data = data.replace("&middot;", "");
        data = data.replace("&nbsp;", " ");
        _parseWebPage(new QXmlStreamReader(data));
    } else {
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::UserAgentHeader,
                          "Mozilla/5.0 (Android; Mobile; rv:40.0) Gecko/40.0 Firefox/40.0");
        _manager->get(request);
    }
}

void GoogleSearchHelper::_parseWebPage(QXmlStreamReader *element) {
    _searchResults.clear();
    bool answerFlag = false;
    bool searchResultFlag = false;
    QString answer = "";
    QString searchUrl = "";

    while (!element->atEnd()) {
        element->readNext();
        if (element->tokenType() == QXmlStreamReader::StartElement) {
            if (element->name() != "div" && element->name() != "a") continue;
            QXmlStreamAttributes attributes = element->attributes();
            foreach (QXmlStreamAttribute attr, attributes) {
                if (attr.name() == "class" && attr.value() == "_o0d") answerFlag = true;
                if (element->name() == "a" && attr.name() == "class" && attr.value() == "fl") {
                    searchResultFlag = false;
                    searchUrl == "";
                    break;
                }
                if (element->name() == "a" && attr.name() == "href" &&
                        attr.value().startsWith("/url?q=")) {
                    searchResultFlag = true;
                    searchUrl = attr.value().mid(7).toString();
                    searchUrl = searchUrl.left(searchUrl.indexOf("&sa=U"));
                }
            }
        } else if (element->tokenType() == QXmlStreamReader::Characters) {
            if (answerFlag) {
                QString data = element->text().toString();
                if (data.replace(QRegularExpression(" *"), "").isEmpty()) continue;
                answerFlag = false;
                if (answer.length() < element->text().length()) answer = element->text().toString();
            } else if (searchResultFlag) {
                QString title = element->text().toString();
                if (!searchUrl.isEmpty() && title.replace(QRegExp(" *"), "").length() != 0) {
                    _searchResults.append(
                                new SearchResultObject(element->text().toString(), searchUrl));
                    searchUrl = "";
                }
                searchResultFlag = false;
            }
        }
    }
    if (element->hasError()) qDebug() << element->errorString();

    emit gotSearchPage(QVariant::fromValue(_searchResults));
    if (!answer.isEmpty()) emit gotAnswer(answer);
}
