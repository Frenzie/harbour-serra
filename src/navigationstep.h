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

private:
    QString _text;
    QString _distance;
    QString _maneuver;
    double _startLat;
    double _startLng;
    double _endLat;
    double _endLng;
};

#endif // NAVIGATIONSTEP_H
