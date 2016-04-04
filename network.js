
function checkConnection() {
    print("Check connection");

    var xhr = new XMLHttpRequest();

    var timer = Qt.createQmlObject("import QtQuick 2.3; Timer {interval: 2000; repeat: false; running: true;}",root,"MyTimer");
    timer.triggered.connect(function(){
        console.log("abort");
        xhr.abort();
        statusBar.state = "disconnected";
    });

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
        }
        else
        if (xhr.readyState === XMLHttpRequest.DONE) {
            console.log("on ready state change:" + xhr.readyState + " " + xhr.status);
            if (xhr.status === 200) {
                statusBar.state = "connected";
                timer.running = false;
            } else {
                statusBar.state = "disconnected";
            }
        }
        else
        if (xhr.readyState === 4) {
            console.log("on ready state change:" + xhr.readyState);
            statusBar.state = "disconnected";
        }
    }

    var s = "http://%1/".arg(settings.serverAddress);
    xhr.open("GET", s);
    xhr.send();
}
