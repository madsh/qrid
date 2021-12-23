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
    
    <h1 class="mt-4"><em>Testing notes</em></h1>
    
    <div class="mt-4 mb-3">   
    <tt>UUIDv4: <small class="text-muted">${this.qrid}</small></tt><br/>
    <tt>base64: <small class="text-muted">${this.alt}</small></tt><br/>
    <tt>__back: <small class="text-muted">${this.alt2}</small></tt>
    </div>

    <div class="mt-4 mb-3">   
    <tt>hex___: <small class="text-muted">${this.alt3}</small></tt><br/>
    <tt>base64: <small class="text-muted">${this.alt4}</small></tt>
    </div>

    


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
        <button type="button" class="btn btn-primary" onClick="clickedPreviewPublicNote()">Preview Note</button>
        <button type="button" class="btn btn-primary" onClick="clickedSavePublicNote()" disabled>Save Note</button>


        </div>

        
    </form>

</div>
    `;
  }
}