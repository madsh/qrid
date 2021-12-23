import AbstractView from './AbstractView.js';
import {} from './APIv1.js'


export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle('Scanner');
  }

  async getHtml() {
    // This is hardcoded for now but could be done dynamically using templating
    // and maybe some posts in a posts folder.
    return `
    <div style="position: relative;height: 80vh;width: 100vw;min-width: 375px;min-height: 700px; margin: 30px auto;">
    <qr-scanner style="width: 100%;height: 50%;position: relative;" >
      <div style="position: absolute;top: 0;left: 20%;color: #fff;">
      We are gonna ask for permission to use the camera</div>
    </qr-scanner>
    <div class="text-center ms-5 me-5">
      <p>the start button is to open camera , and stop is close camera</p>
      <button id="start">start</button>
      <button id="stop">stop</button>
      <div>
        <p>use function create simaple full screen QR code reader, before show you shuld click create qr-scanner</p>
        <button id="f-create">create</button>
        <button id="f-show">show</button>
        <button id="f-hidden">hidden</button>
      </div>      
    </div>
  </div>`;
  }
}