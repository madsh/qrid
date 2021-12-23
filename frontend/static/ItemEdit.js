import AbstractView from './AbstractView.js'
import { getItem } from './APIv1.js'


export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.item = getItem(params.id)
    this.setTitle('qrid.info - add description')
  }




  async getHtml() {
    return `
    <div id="edit" class="mb-2 mt-2 container">
    
    <h1 class="mt-4"><em>${this.item.name}</em></h1>
    <p class="mb-4"><small class="text-muted">${this.item.qrid}</small></p>

    <form id="edit-item-form">
        <input type="hidden" id="form-qrid" value="${this.item.qrid}" />
        <div class="mb-3">
            <label for="form-desc" class="form-label">Description</label>
            <div class="form-hint" id="form-name-hint">
              A short description of your item. 
              <a href="">read more</a>
            </div>
            <textarea class="form-control mt-1" id="form-desc" rows="4">${this.item.desc ? this.item.desc : ""}</textarea>
            <div class="text-end mt-3">
            <button type="button" class="btn btn-outline-secondary">Save and Add more details</button>            
            <button type="button" class="btn btn-primary" onClick="clickedSaveDescription()">Save Description</button>

            </div>
        </div>

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

        <div class="mb-3">
          <button type="button" class="btn btn-secondary" onClick="clickedDeleteItem()">Delete Item</button>
        </div>
    </form>

</div>
    `;
  }
}