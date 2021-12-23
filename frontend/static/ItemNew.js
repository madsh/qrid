import AbstractView from './AbstractView.js';


export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.uuid = (params['id']) ? params['id'] : '';
    this.setTitle('qrid.info - add new');
  }

  async getHtml() {
    // This is hardcoded for now but could be done dynamically using templating
    // and maybe some posts in a posts folder.
    return `<div id="add" class="container mb-5 mt-5">
    <h1 class="mb-4">Register Item</h1>

    <form id="register-item-form" onSubmit="submittedAdd()">
        
        <div class="mb-3 form-group" id="form-name-group">
            <label for="form-name" class="form-label">Name</label>
            <span class="form-hint" id="form-name-hint">
                A friendly name for your item.
            </span>
            <span class="form-error-message" id="form-name-error"></span>                               
            <input type="text" class="form-control" id="form-name" required>
        </div>

        <div class="mb-3 form-group" id="form-uuid-group">
            <label for="form-uuid" class="form-label">UUID (optional)</label>
            <span class="form-hint" id="form-uuid-hint">
                If you can't scan or type one, just leave it blank.
            </span>
            <span class="form-error-message" id="form-uuid-error"></span>                               
            <input type="text" class="form-control" id="form-uuid"
                   pattern="^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"                   
                   title="most follow uuid form: 8-4-4-4-12" value="${this.uuid}">
        </div>
        <p class="text-end">
        <a onClick="(function(){document.getElementById('form-uuid').value = uuid();})()" class="me-3 btn btn-outline-secondary">Generate a UUID</a>      
        <button type="submit" class="btn btn-primary">Add to list</button>

        </p>
        
    </form>
    
      

</div>
    `;
  }
}