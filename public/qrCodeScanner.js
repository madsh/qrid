const video = document.createElement("video");
const canvasElement = document.getElementById("qr-canvas");
const canvas = canvasElement.getContext("2d");

const qrResult = document.getElementById("qr-result");
const qrLink = document.getElementById("qr-link");
const outputData = document.getElementById("outputData");
const outputLink = document.getElementById("outputLink");

const btnScanQR = document.getElementById("btn-scan-qr");

document.body.style.backgroundColor = "black";

let scanning = false;

qrcode.callback = res => {
    if (res) {
        console.log("Got a call back with " + res)
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
    try {

        console.log("Testing " + data);
        const url = new URL(data);
        console.log("Got parst parse with : " + url)



        qrResult.hidden = false;
        qrLink.hidden = false;
        console.log("hostname: " + url.hostname);
        if (url.hostname == "qr.id") {
            outputLink.style.backgroundColor = "green";
            console.log("Got green and forwarding")
            outputLink.innerText = url.hostname + " (tested good) " + url.pathname;
            window.location = "./?qrid=" + url.pathname;
        } else {
            // deal with pure uuids
            outputLink.style.backgroundColor = "red";
            outputLink.innerText = url + " (tested bad) ";
            console.log("Got red and forwarding")
            window.location = "./?qrid=" + url;
        }


    } catch (error) {
        console.log("Caught error parsing url " + error)
        qrLink.hidden = false;
        outputLink.style.backgroundColor = "red";
        outputLink.innerText = "Failed to parse " + data + " as an URL";
        return;
    }
}