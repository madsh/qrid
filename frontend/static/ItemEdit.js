import AbstractView from './AbstractView.js';

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.postID = params.id;
    this.setTitle('Viewing Post');
  }


  async getHtml() {
    return `
    <div id="edit" class="mb-5 mt-5 container">
    <h1>Name of Item</h1>
    <p><small>${this.postID}</small></p>

    <form>
        
        <div class="mb-3">
            <label for="form-desc" class="form-label">Description</label>
            <div class="form-hint" id="form-name-hint">
              A short description of your item. 
              <a href="">read more</a>
            </div>
            <textarea class="form-control mt-1" id="form-desc" rows="2"></textarea>
            <div class="text-end mt-3">
            <button type="button" class="btn btn-outline-secondary">Save and Add more details</button>
            <button type="button" class="btn btn-primary">Save</button>
            </div>
        </div>

        <div class="mb-3">
            <label for="form-uuid" class="form-label">Public Note</label>
            <span class="form-hint" id="form-name-hint">
              This note is shown to everyone scanning the QR code. <a href="">read more</a>
            </span>
            <textarea class="form-control mt-1" id="form-uuid" rows="4"></textarea>
        </div>

        <div class="mb-3">
          Preview of markdown rendering
        </div>

        <div class="text-end">
        <button type="button" class="btn btn-outline-secondary">Delete Public Note</button>
        <button type="button" class="btn btn-primary">Save</button>

        </div>

        <div class="mb-3">
          <button type="button" class="btn btn-secondary">Delete Item</button>
        </div>
    </form>

</div>
    `;
  }
}