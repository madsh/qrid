import AbstractView from './AbstractView.js';

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.itemID = params.id;
    this.setTitle('qrid.info - public view');
  }
  
  async getHtml() {

    return this.itemID.match("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")?
      this.empty() : this.notFound();
  }

  notFound() {
    return `<div class="mb-5 mt-5 container">
    <h1>Not Found</h1>
    <p><tt>/${this.itemID}</tt> does not match a registered route or the uuid format</p>
    <p><tt>${window.location.search}</tt></p>
    `;



  }

  empty() {
    return `<div class="container-sm">
      <div class="card">
        <!--<img src="..." class="card-img-top" alt="...">-->
        <svg class="bd-placeholder-img card-img-top" width="100%" height="180" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Card image cap" preserveAspectRatio="xMidYMid slice" focusable="false"><title>Card image cap</title><rect width="100%" height="100%" fill="#868e96"></rect></svg>
        <div class="card-body">
        <h5 class="card-title">Public Note</h5>
        <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
        </div>        
      </div>

      <div><small class="text-muted">This is a public note from a user who has registered an item at qrid.info using the uuid: ${this.itemID},<br/>
        If the user has provided some contact information, you can click the button below to get in touch.</small></div>
    </div>`;
  }

}

