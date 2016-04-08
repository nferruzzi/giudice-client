import QtQuick 2.5
import QtQuick.Dialogs 1.2

MessageDialog {
    id: messageDialog

    function show(title, caption) {
        messageDialog.title = title;
        messageDialog.text = caption;
        messageDialog.open();
    }
}

