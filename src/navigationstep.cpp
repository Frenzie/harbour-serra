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
