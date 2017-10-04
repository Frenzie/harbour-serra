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

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QGuiApplication>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlContext>

#include <QFile>

#include "applicationslistmodel.h"
#include "commandsparser.h"
#include "contactshelper.h"
#include "googlemapshelper.h"
#include "googlesearchhelper.h"
#include "recorder.h"
#include "scriptrunner.h"
#include "settingswrapper.h"
#include "vkstream.h"
#include "weatherhelper.h"
#include "yandexsearchhelper.h"
#include "yandexspeechkithelper.h"


int main(int argc, char *argv[]) {
    QFile localeFile("/var/lib/environment/nemo/locale.conf");
    QString localeName = "";
    if (localeFile.open(QIODevice::ReadOnly)) {
        QStringList lines = QString(localeFile.readAll()).split("LANG=");
        localeName = lines[1].left(5).replace("_", "-");
        if (localeName.startsWith("en-")) localeName = localeName.left(3) + "US";
        localeFile.close();
    }
    qDebug() << localeName;

    QScopedPointer<QGuiApplication> application(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QScopedPointer<ApplicationsListModel> applications(new ApplicationsListModel(view.data()));
    QScopedPointer<ContactsHelper> contactsHelper(new ContactsHelper(view.data()));
    QScopedPointer<CommandsParser> commandsParser(new CommandsParser(view.data()));
    QScopedPointer<GoogleMapsHelper> googleMapsHelper(new GoogleMapsHelper(view.data()));
    QScopedPointer<GoogleSearchHelper> googleSearchHelper(new GoogleSearchHelper(view.data()));
    QScopedPointer<Recorder> recorder(new Recorder(view.data()));
    QScopedPointer<ScriptRunner> scriptRunner(new ScriptRunner(view.data()));
    QScopedPointer<SettingsWrapper> settings(new SettingsWrapper(view.data()));
    QScopedPointer<VkStream> vkStream(new VkStream(view.data()));
    QScopedPointer<WeatherHelper> weatherHelper(new WeatherHelper(view.data()));
    QScopedPointer<YandexSearchHelper> yandexSearchHelper(new YandexSearchHelper(view.data()));
    QScopedPointer<YandexSpeechKitHelper> yandexSpeechKitHelper(new YandexSpeechKitHelper(view.data()));

    view->rootContext()->setContextProperty("applications", applications.data());
    view->rootContext()->setContextProperty("contactsHelper", contactsHelper.data());
    view->rootContext()->setContextProperty("commandsParser", commandsParser.data());
    view->rootContext()->setContextProperty("googleMapsHelper", googleMapsHelper.data());
    view->rootContext()->setContextProperty("googleSearchHelper", googleSearchHelper.data());
    view->rootContext()->setContextProperty("recorder", recorder.data());
    view->rootContext()->setContextProperty("scriptRunner", scriptRunner.data());
    view->rootContext()->setContextProperty("settings", settings.data());
    view->rootContext()->setContextProperty("vkstream", vkStream.data());
    view->rootContext()->setContextProperty("weatherHelper", weatherHelper.data());
    view->rootContext()->setContextProperty("yandexSearchHelper", yandexSearchHelper.data());
    view->rootContext()->setContextProperty("yandexSpeechKitHelper", yandexSpeechKitHelper.data());
    view->rootContext()->setContextProperty("localeString", localeName);

    view->setSource(SailfishApp::pathTo("qml/harbour-serra.qml"));
    view->show();

    return application->exec();
}
