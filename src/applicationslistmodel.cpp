#include "applicationslistmodel.h"

ApplicationsListModel::ApplicationsListModel(QObject *parent) : QAbstractListModel(parent) {
    buildList();
}

int ApplicationsListModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return _ids.size();
}

QVariant ApplicationsListModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= _ids.size()) return QVariant();
    switch (role) {
    case IdRole:
        return QVariant(_ids.at(index.row()));
    case IconRole:
        return QVariant(_icons.at(index.row()));
    case NameRole:
        return QVariant(_names.at(index.row()));
    case ExecRole:
        return QVariant(_execs.at(index.row()));
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ApplicationsListModel::roleNames() const {
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[IdRole] = "appId";
    roles[IconRole] = "appIcon";
    roles[NameRole] = "appName";
    roles[ExecRole] = "appExec";
    return roles;
}

void ApplicationsListModel::buildList() {
    _clear();
    QDir dir("/usr/share/applications");
    if (!dir.exists()) return;
    QStringList files = dir.entryList();
    if (!files.isEmpty()) files.removeFirst();
    if (!files.isEmpty()) files.removeFirst();
    foreach (QString filename, files) {
        QFile file("/usr/share/applications/" + filename);
        if (file.open(QIODevice::ReadOnly)) {
            QStringList fileLines = QString(file.readAll()).split("\n");
            if (!fileLines.contains("NoDisplay=true")) {
                QString name = "";
                QString exec = "";
                QString icon = "";
                foreach (QString line, fileLines) {
                    if (line.startsWith("Name=")) name = line.mid(5);
                    if (line.startsWith("Exec=")) exec = line.mid(5);
                    if (line.startsWith("Icon=")) icon = line.mid(5);
                }
                if (!name.isEmpty() && !exec.isEmpty() && !icon.isEmpty()) {
                    _ids.append(_currentId++);
                    _names.append(name);
                    _execs.append(exec);
                    _icons.append(icon);
                }
            }
            file.close();
        }
    }
    QModelIndex index = createIndex(0, 0, static_cast<void*>(0));
    emit dataChanged(index, index);
}

void ApplicationsListModel::_clear() {
    _currentId = 0;
    _ids.clear();
    _icons.clear();
    _names.clear();
    _execs.clear();
}
