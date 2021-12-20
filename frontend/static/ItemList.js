import AbstractView from './AbstractView.js';
import {getItems} from './APIv1.js'

const maybePluralize = (count, noun, suffix = 's') =>
  `${count} ${noun}${count !== 1 ? suffix : ''}`;

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle('Posts');
  }

  async getHtml() {
    // This is hardcoded for now but could be done dynamically using templating
    // and maybe some posts in a posts folder.
    let list = getItems()
    console.log(list)


    if (list.length < 1) {
      return `<div id="list" class="mb-5 mt-5 container">
              <h1>No Items, Yet!</h1>
              <p>If you have a qrid tag around, click the camera icon above to scan it</p>
              <p>or<p>
              <p>go ahead an register your first item manually, by pressing the button below. </p>
              <a href="/item/new" type="button" class="btn btn-secondary" data-link>Add</a>
              </div>`
    }
 
    var html = `
    <div id="list" class="mb-5 mt-5 container">
    <h1>List</h1>
    You have ${maybePluralize(list.length, 'item')} stored locally. 
    <table class="table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>`

    for (const item in list) {
      console.log("loogin at ", item);

      html += `<tr>
                <td><a href="/item/${list[item].qrid}" data-link>${list[item].name}</a></td>
                <td>${list[item].desc || "<small class='text-muted text'><em>no description</em></small>"}</td>
              </tr>       
      `
    }
    
    html += `</tbody></table>
             <a href="/item/new" type="button" class="btn btn-secondary" data-link>Add</a>
             </div>`

    return html    
  }
}