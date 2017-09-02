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

#include "navigationstep.h"

NavigationStep::NavigationStep(QObject *parent) : QObject(parent)
{}

NavigationStep::NavigationStep(QString text, QString distance, double startLat, double startLng,
                               double endLat, double endLng, QString maneuver) {
    _text = text;
    _distance = distance;
    _startLat = startLat;
    _startLng = startLng;
    _endLat = endLat;
    _endLng = endLng;
    _maneuver = maneuver;
}

QString NavigationStep::text() const {
    return _text;
}

QString NavigationStep::distance() const {
    return _distance;
}

QString NavigationStep::maneuver() const {
    return _maneuver;
}

double NavigationStep::startLat() const {
    return _startLat;
}

double NavigationStep::startLng() const {
    return _startLng;
}

double NavigationStep::endLat() const {
    return _endLat;
}

double NavigationStep::endLng() const {
    return _endLng;
}

bool NavigationStep::isCurrent() const {
    return _isCurrent;
}

void NavigationStep::setIsCurrent(bool isCurrent) {
    _isCurrent = isCurrent;
    emit isCurrentChanged(_isCurrent);
}
