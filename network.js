
function request(verb, endpoint, obj, cb) {
    var BASE = 'http://%1'.arg(settings.serverAddress)
    print('request: ' + verb + ' ' + BASE + (endpoint?'/' + endpoint:''))

    var timer = Qt.createQmlObject("import QtQuick 2.3; Timer {interval: 2000; repeat: false; running: true;}",root,"MyTimer");
    timer.triggered.connect(function(){
        console.log("abort");
        xhr.abort();
        statusBar.state = "disconnected";
    });

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        //print('xhr: on ready state change: ' + xhr.readyState)
        if (xhr.readyState === XMLHttpRequest.DONE) {
            timer.running = false;
            if(cb) {
                var res = JSON.parse(xhr.responseText.toString())
                cb(xhr, res);
            }
        }
    }

    xhr.open(verb, BASE + (endpoint?'/' + endpoint:''));
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Accept', 'application/json');
    var data = obj?JSON.stringify(obj):''
    xhr.send(data)
}

function checkConnection(cb) {
    print("Check connection");

    request('GET', null, null, function (xhr, res) {
        print("Callback");
        if (xhr.status === 200) {
            statusBar.state = "connected";
            if (cb) cb(res);
        } else {
            statusBar.state = "disconnected";
            if (cb) cb(null);
        }
    });
}

function sendVote(trial, user, vote, judge, cb) {
    print("Send vote");

    var obj = {'trial': trial, 'user': user, 'vote': vote, 'judge': judge};
    request('POST', 'vote', obj, function(xhr, resp) {
        print("Response: ", resp);
    });
}
