#include "recorder.h"

Recorder::Recorder(QObject *parent) : QObject(parent) {
    _settings.setCodec("audio/PCM");
    _settings.setQuality(QMultimedia::NormalQuality);
    _audioRecorder.setEncodingSettings(_settings);
    _audioRecorder.setContainerFormat("wav");
}

void Recorder::startRecord() {
    _recording = true;
    _audioRecorder.record();
}

void Recorder::stopRecord() {
    _recording = false;
    _audioRecorder.stop();
}

QUrl Recorder::getActualLocation() {
    return _audioRecorder.actualLocation();
}

bool Recorder::isRecording() {
    return _recording;
}
