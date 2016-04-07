#ifndef EXTERNALS_H
#define EXTERNALS_H

#include <QObject>

class Externals : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString UUID READ UUID WRITE setUUID NOTIFY UUIDChanged)
public:
    Externals(QObject *parent);

    void setUUID(const QString &a) {
        if (a != m_uuid) {
            m_uuid = a;
            emit UUIDChanged();
        }
    }
    QString UUID() const {
        return m_uuid;
    }
signals:
    void UUIDChanged();
private:
    QString m_uuid;
};

#endif // EXTERNALS_H
