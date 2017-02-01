#include "commanditem.h"

CommandItem::CommandItem(QObject *parent) : QObject(parent)
{}

CommandItem::CommandItem(QString key, QString value) {
    _key = key;
    _value = value;
}
