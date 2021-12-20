import AbstractView from './AbstractView.js';

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle('Home');
  }

  async getHtml() {
    return `
    <div id="profile" class="mb-5 mt-5 container">
    <h1>Profile</h1>
    <p><small>uuid</small></p>
    
    <button type="button" class="btn btn-outline-secondary" onClick="clickedForgetMe()">Forget me</button>
    </div>
    `;
  }
}