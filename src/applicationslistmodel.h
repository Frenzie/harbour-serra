#ifndef APPLICATIONSLISTMODEL_H
#define APPLICATIONSLISTMODEL_H

#include <QAbstractListModel>
#include <QDir>
#include <QFile>

#include <QDebug>

class ApplicationsListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum {
        IdRole = Qt::UserRole + 1,
        IconRole,
        NameRole,
        ExecRole
    };

    explicit ApplicationsListModel(QObject *parent = 0);

    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void buildList();

private:
    int _currentId = 0;
    QList<int> _ids;
    QList<QString> _icons;
    QList<QString> _names;
    QList<QString> _execs;

    void _clear();
};

#endif // APPLICATIONSLISTMODEL_H
