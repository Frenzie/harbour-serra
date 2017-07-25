#include "recorder.h"

Recorder::Recorder(QObject *parent) : QObject(parent) {
    _settings.setCodec("audio/speex");
    _settings.setQuality(QMultimedia::NormalQuality);
    _audioRecorder.setEncodingSettings(_settings);
    _audioRecorder.setContainerFormat("ogg");
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
