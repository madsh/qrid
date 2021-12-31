import AbstractView from './AbstractView.js';

export default class extends AbstractView {
  constructor(params) {
    super(params);    
    this.setTitle('qrid');    
    if (hasUser()) {
        navigateTo("/list");
    }
  }



  


  async getHtml() {
    return `
    <div id="welcome" class="mb-5 mt-5 container">
    <h1>Welcome back from apple</h1>
    
    </div>
    `;
  }
}


