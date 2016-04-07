#include <QUuid>
#include "externals.h"

Externals::Externals(QObject *parent) : QObject(parent)
{
    QUuid uuid = QUuid::createUuid();
    m_uuid = uuid.toString();
}
