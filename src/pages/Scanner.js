import QrScanner from "qr-scanner";
import React, { useEffect } from "react";

QrScanner.WORKER_PATH = './qr-scanner-worker.min.js';



export const ScannerPage = () => {
  useEffect(() => {
    console.log("Effect");
    const elem = document.getElementById("scanner");
    const qrScanner = new QrScanner(elem, result => console.log('decoded qr code:', result));
    qrScanner.start();
    qrScanner.turnFlashOn(); // turn the flash on if supported; async

  }, []);

    
    

    console.log("rendered");


    
return (
  <main className="container page-container" id="main-content">
  <h1 className="h2">Scanner</h1>
  <p className="subheading">her?</p>
  
    <video id="scanner" className=" w-percent-100">{console.log("UI rendered")}</video>
  
  </main>
);

}

export default ScannerPage
