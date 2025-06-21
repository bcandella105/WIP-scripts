function play() {
    const url = document.getElementById('url').value;
    if (url) {
        fetch(`https://${GetParentResourceName()}/controlRadio`, {
            method: 'POST',
            body: JSON.stringify({ action: 'play', url: url }),
        });
    }
}

function pause() {
    fetch(`https://${GetParentResourceName()}/controlRadio`, {
        method: 'POST',
        body: JSON.stringify({ action: 'pause' }),
    });
}

function stop() {
    fetch(`https://${GetParentResourceName()}/controlRadio`, {
        method: 'POST',
        body: JSON.stringify({ action: 'stop' }),
    });
}

function setVolume(volume) {
    fetch(`https://${GetParentResourceName()}/controlRadio`, {
        method: 'POST',
        body: JSON.stringify({ action: 'volume', volume: volume }),
    });
}

function setProximity(distance) {
    fetch(`https://${GetParentResourceName()}/controlRadio`, {
        method: 'POST',
        body: JSON.stringify({ action: 'proximity', distance: distance }),
    });
}
