import AbstractView from './AbstractView.js';

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle('qrid.info - profile');
  }

  async getHtml() {
    return `
    <div id="profile" class="mb-5 mt-5 container">
    <h1>Profile</h1>
    <p><small>uuid</small></p>
    
    <button type="button" class="btn btn-outline-secondary" onClick="clickedForgetMe()">Forget me</button>

    <div id="appleid-signin" class="signin-button" data-color="black" data-mode="left-align" data-border="true" data-type="sign-in"></div>
 
    <script type="text/javascript" src="https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js"></script>

    </div>
    `;
  }
}