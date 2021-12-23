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
    <h1>Welcome</h1>
    Lets get a UUID, store it and go to the list....
    <br/>

    <div id="button-welcome" onClick="clickedWelcome()" class="btn btn-primary mt-3">Jump right in</div>

    <h1 class="mt-4">...or welcome back</h1>
    You have registered, lets recognize you
    <br/>
    <button type="button-login" class="btn btn-outline-primary mt-3">Log in</button>
</div>
    `;
  }
}


