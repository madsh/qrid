import AbstractView from './AbstractView.js'
import { getItem } from './APIv1.js'


export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.item = getItem(params.id)
    this.setTitle('qrid.info - add description')

    this.qrid = uuid();

    this.alt = window.btoa(unescape(encodeURIComponent(this.qrid)))

    this.alt2 = decodeURIComponent(escape(window.atob(this.alt)));

    var bin = new Uint8Array(16);

    crypto.getRandomValues(bin);
    
    var a = "";
    for (var i = 0; i < bin.length; i++) {      
      if (bin[i] < 16) a += '0';
      a += bin[i].toString(16);
    }


    this.alt3 = a;

    this.alt4 = 'FyHi4CyALgFjv+Gurm01OA=='
;

  }

  toHexString(bytes){
    return bytes.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '')
  }



  async getHtml() {
    return `
    <div id="edit" class="mb-2 mt-2 container">
    
    <h1 class="mt-4">Public Notes <span class="badge bg-secondary">beta</span></h1>   
    <p class="lead">can be used to display a note to anyone scanning the qr code. 
    Do we require a login to store and display the information? Does that help to get in touch?</p>

    <form id="edit-item-form">
        <div class="mb-3">
            <label for="form-uuid" class="form-label">Public Note</label>
            <span class="form-hint" id="form-name-hint">
              This note is shown to everyone scanning the QR code. <a href="">read more</a>
            </span>
            <span class="form-hint" id="form-name-hint" style="color: #dc2828; font-weight: 600;">
              Warning: Do not expose information, that can make you unsafe. 
            </span>
            <textarea class="form-control mt-1" id="form-uuid" rows="4"></textarea>
        </div>
        <div class="text-end">
        <button type="button" class="btn btn-outline-secondary">Delete Public Note</button>
        <button type="button" class="btn btn-outline-primary" onClick="clickedPreviewPublicNote()">Scan?</button>
        <button type="button" class="btn btn-primary" onClick="clickedSavePublicNote()">Publish</button>
        </div>
    </form>

    <hr class="ms-5 me-5 mt-5 mb-5"/>

    <h1 class="mt-4">Add OTP</h1>   
    <p class="lead">to let user log in at central service without password    
        
    </p>

    <h1 class="mt-4">Add OAuth</h1>   
    <p class="lead">to let users log in with existing credentials    
        
    </p>


    <h1 class="mt-4">Add other serial numbers</h1>   
    <p class="lead">like VIN on bikes, serials on cameras and lenses and a whole lot more    
        
    </p>

    <h1 class="mt-4">Add other model numbers</h1>   
    <p class="lead">like ISBN, EAN and more</p>

    <h1 class="mt-4">Upload Photo</h1>   
    <p class="lead">reciept or purchase/ownership/wherabouts to sign/timestamp</p>

    <h1 class="mt-4">Add collections</h1>   
    <p class="lead">an item can belong to collections</p>


    <h1 class="mt-4"><em>Shorter item ids for better QR codes</em></h1>
    
    <div class="mt-4 mb-3">   
    <tt>UUIDv4: <small class="text-muted">${this.qrid}</small></tt><br/>
    <tt>base64: <small class="text-muted">${this.alt}</small></tt><br/>
    <tt>__back: <small class="text-muted">${this.alt2}</small></tt>
    </div>

    <div class="mt-4 mb-3">   
    <tt>hex___: <small class="text-muted">${this.alt3}</small></tt><br/>
    <tt>base64: <small class="text-muted">${this.alt4}</small></tt>
    </div>


</div>
    `;
  }
}