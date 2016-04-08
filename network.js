var userUUID = null;

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
                var res = null;
                try {
                    console.log(xhr.responseText);
                    res = JSON.parse(xhr.responseText.toString());
                }
                catch(e) {
                    console.log("Errore:", e);
                }
                cb(xhr, res);
            }
        }
    }

    xhr.open(verb, BASE + (endpoint?'/' + endpoint:''));
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.setRequestHeader('X-User-auth', userUUID);

    var data = obj?JSON.stringify(obj):''
    xhr.send(data)
}

function checkConnection(judge, cb) {
    print("Check connection");

    request('GET', "keepAlive/"+judge, null, function (xhr, res) {
        if (cb) cb(xhr, res);
    });
}

function sendVote(trial, user, vote, judge, cb) {
    print("Send vote");

    var obj = {'trial': trial, 'user': user, 'vote': vote, 'judge': judge};
    request('POST', 'vote', obj, function(xhr, resp) {
        print("Response: ", resp);
        if (cb) cb(xhr, resp);
    });
}
