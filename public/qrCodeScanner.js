const video = document.createElement("video");
const canvasElement = document.getElementById("qr-canvas");
const canvas = canvasElement.getContext("2d");

const qrResult = document.getElementById("qr-result");
const qrLink = document.getElementById("qr-link");
const outputData = document.getElementById("outputData");
const outputLink = document.getElementById("outputLink");

const btnScanQR = document.getElementById("btn-scan-qr");

let scanning = false;

qrcode.callback = res => {
    if (res) {
        outputData.innerText = res;

        scanning = false;

        video.srcObject.getTracks().forEach(track => {
            track.stop();
        });
        testData(res);

        qrResult.hidden = false;
        qrLink.hidden = false;
        canvasElement.hidden = true;
        btnScanQR.hidden = false;
    }
};

btnScanQR.onclick = () => {
    navigator.mediaDevices
        .getUserMedia({ video: { facingMode: "environment" } })
        .then(function(stream) {
            scanning = true;
            qrResult.hidden = true;
            qrLink.hidden = true;
            btnScanQR.hidden = true;
            canvasElement.hidden = false;
            video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
            video.srcObject = stream;
            video.play();
            tick();
            scan();
        });
};

function tick() {
    canvasElement.height = video.videoHeight;
    canvasElement.width = video.videoWidth;
    canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);

    scanning && requestAnimationFrame(tick);
}

function scan() {
    try {
        qrcode.decode();
    } catch (e) {
        setTimeout(scan, 300);
    }
}

function testData(data) {
    const url = new URL(data);
    console.log("hostname: " + url.hostname);
    if (url.hostname == "qr.id") {
        outputLink.style.backgroundColor = "green";
        window.location = "http://localhost:1234/item" + url.pathname;
    } else {
        // deal with pure uuids
        outputLink.style.backgroundColor = "red";
    }

    outputLink.innerText = url.hostname + " (tested) " + url.pathname;
}