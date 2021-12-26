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
    return `<div id="add" class="container">

    <div class="card" id="scanner-intro">
        <!--<img src="..." class="card-img-top" alt="...">-->
        <svg class="bd-placeholder-img card-img-top" width="100%" height="85" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Card image cap" preserveAspectRatio="xMidYMid slice" focusable="false"><title>Card image cap</title><rect width="100%" height="100%" fill="#868e96"></rect></svg>
        <div class="card-body">
      
        <p class="card-text text-muted">You are about to start webcamera to scan a QR code. We will ask for permission before turning on your camera. </p>
        <p class="card-text text-muted" id="cameras"></p>
        <p class="text-end">
        <a type="button" class="btn btn-outline-secondary me-3" 
            href="item/new/${uuid()}" data-link>Fake Random</a>

        <a type="button" class="btn btn-outline-primary me-3" 
            href="item/new" data-link>Add Manually</a>

        <button type="button" class="btn btn-primary" 
            onClick="clickedStart();">Start Scanner</button>
        </p>
        </div>        
      </div>
    </div>
  
    </div>`;
  }
}