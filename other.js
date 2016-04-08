
function ShowDialog(title, caption) {
    var timer = Qt.createQmlObject("import QtQuick 2.3; Timer {interval: 100; repeat: false; running: true;}", root, "MsgDialogTimer");
    timer.triggered.connect(function(){
        var component = Qt.createComponent("messageDialog.qml");
        var dlg = component.createObject(root);
        dlg.show(title, caption);
    });
}

var gCallback;
var gComponent;

function ShowGiudiceDialog(callback) {
    gCallback = callback;
    gComponent = Qt.createComponent("giudiceServerDialog.qml");

    if (gComponent.status === Component.Ready || gComponent.status === Component.Error) {
        showGiudiceDialogCompleted();
    } else {
        component.statusChanged.connect(showGiudiceDialogCompleted);
    }
}

function showGiudiceDialogCompleted() {
    var dlg = gComponent.createObject(root);
    dlg.callback = gCallback;
    dlg.open();
}

function ShowServerDialog(callback) {
    gCallback = callback;
    gComponent = Qt.createComponent("configServerDialog.qml");

    if (gComponent.status === Component.Ready || gComponent.status === Component.Error) {
        showServerDialogCompleted();
    } else {
        component.statusChanged.connect(showServerDialogCompleted);
    }
}

function showServerDialogCompleted() {
    var dlg = gComponent.createObject(root);
    dlg.callback = gCallback;
    dlg.open();
}
