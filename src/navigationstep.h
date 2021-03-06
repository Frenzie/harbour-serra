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

#ifndef NAVIGATIONSTEP_H
#define NAVIGATIONSTEP_H

#include <QObject>

class NavigationStep : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text CONSTANT)
    Q_PROPERTY(QString distance READ distance CONSTANT)
    Q_PROPERTY(QString maneuver READ maneuver CONSTANT)
    Q_PROPERTY(double startLat READ startLat CONSTANT)
    Q_PROPERTY(double startLng READ startLng CONSTANT)
    Q_PROPERTY(double endLat READ endLat CONSTANT)
    Q_PROPERTY(double endLng READ endLng CONSTANT)
    Q_PROPERTY(bool isCurrent READ isCurrent WRITE setIsCurrent NOTIFY isCurrentChanged)

public:
    explicit NavigationStep(QObject *parent = 0);
    NavigationStep(QString text, QString distance, double startLat, double startLng, double endLat,
                   double endLng, QString maneuver);

    QString text() const;
    QString distance() const;
    QString maneuver() const;
    double startLat() const;
    double startLng() const;
    double endLat() const;
    double endLng() const;

    bool isCurrent() const;
    void setIsCurrent(bool isCurrent);

signals:
    void isCurrentChanged(bool isCurrent);

private:
    QString _text;
    QString _distance;
    QString _maneuver;
    double _startLat;
    double _startLng;
    double _endLat;
    double _endLng;
    bool _isCurrent = false;
};

#endif // NAVIGATIONSTEP_H
