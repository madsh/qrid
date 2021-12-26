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
        <label for="form-desc" class="form-label">Name</label>
            <div class="form-hint" id="form-name-hint">
              A friendly name for your item              
            </div>
            <input class="form-control mt-1" id="form-name" value="${this.item.name}" required/>
        </div>
        
        
        <div class="mb-3">
            <label for="form-desc" class="form-label">Description</label>
            <div class="form-hint" id="form-name-hint">
              A short description of your item. 
              <a href="">read more</a>
            </div>
            <textarea class="form-control mt-1" id="form-desc" rows="4">${this.item.desc ? this.item.desc : ""}</textarea>
            <div class="text-end mt-3">
          
            <button type="button" class="btn btn-primary" onClick="clickedSaveDescription()">Save</button>

            </div>
        </div>        

        <div class="text-end mt-3">          
          <a type="button" class="btn btn-outline-secondary" href="/item/more" data-link>Add more</a>            
        </div>


        

        <div class="mb-4 mt-4">
        <label for="form-desc" class="form-label">UUID</label>
            <div class="form-hint" id="form-uuid-hint">
              You can change the UUID if you really need to.                
            </div>
            <input class="form-control mt-1" id="form-uuid" value="${this.item.qrid}" required/>
            <div class="text-end mt-3">                      
            </div>
        </div>        

        <div class="mb-3">
          <button type="button" class="btn btn-secondary me-2" onClick="clickedDeleteItem()">Delete Item</button>          
          
        </div>
        </div>


    </form>

</div>
    `;
  }
}