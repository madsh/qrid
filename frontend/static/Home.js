import AbstractView from './AbstractView.js';

export default class extends AbstractView {
  constructor(params) {
    super(params);    
    this.setTitle('qrid');

    if (window.hasUser()) {
        console.log("Found one....");        
    }
  }



  


  async getHtml() {
    return `
    <div id="welcome" class="mb-5 ms-3 mt-5 container">
    <h1>Welcome</h1>
    Lets get a UUID, store it and go to the list....
    <br/>

    <button id="button-welcome" onClick="clickedWelcome()" type="button" class="btn btn-primary mt-3">Jump right in</button>

    <h1 class="mt-4">...or welcome back</h1>
    You have registered, lets recognize you
    <br/>
    <button type="button-login" class="btn btn-outline-primary mt-3" disabled>Log in</button>
</div>
    `;
  }
}


