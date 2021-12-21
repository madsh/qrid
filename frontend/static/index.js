import Home from './Home.js';
import List from './ItemList.js';
import ItemEdit from './ItemEdit.js';
import ItemList from './ItemList.js';
import ItemNew from './ItemNew.js';
import Profile from './Profile.js';
import ItemViewPublic from './ItemViewPublic.js';
//import Settings from './views/Settings.js';
import {LOCAL_USER_PARAM, storeItem, setDesc, delItem} from './APIv1.js'




// Single Page Application based on https://github.com/MichaelCurrin/single-page-app-vanilla-js.git

const navigateTo = url => {
  history.pushState(null, null, url);
  router();
};

const router = async () => {
  const routes = [
    { path: '/', view: Home },
    { path: '/list', view: ItemList },
    { path: '/item/new', view: ItemNew },
    { path: '/item/:id', view: ItemEdit },
    { path: '/profile', view: Profile }, 
    { path: '/:id', view: ItemViewPublic },
  ];

  // Test each route for a potential match.
  const potentialMatches = routes.map(route => {
    return {
      route: route,
      result: location.pathname.match(pathToRegex(route.path))
    };
  });

  let match = potentialMatches.find(potentialMatch => potentialMatch.result !== null);

  if (!match) {
    match = {
      // just picking the first matching route. Depends on ordering in 'const routes'
      route: routes[0],
      result: [
        location.pathname
      ]
    };
  }

  const view = new match.route.view(getParams(match));

  // TODO: Find a more secure way of doing this
  document.querySelector('#app').innerHTML = await view.getHtml();
};

const pathToRegex = path =>
  new RegExp('^' + path.replace(/\//g, '\\/').replace(/:\w+/g, '(.+)') + '$');

const getParams = match => {
  const values = match.result.slice(1);

  const keys = Array.from(
    match.route.path
      .matchAll(/:(\w+)/g))
      .map(result => result[1]
  );

  return Object.fromEntries(
    keys.map((key, i) => {
      return [
        key,
        values[i]
      ];
    })
  );
};


window.addEventListener('popstate', router);

document.addEventListener('DOMContentLoaded', () => {
  document.body.addEventListener('click', e => {
    if (e.target.matches('[data-link]')) {
      e.preventDefault();
      navigateTo(e.target.href);
    }
  });

  router();
});



/////////////////////////////////////////////////////////////////////////////////////////////////


// crypto.randomUUID() was not in Safari IOS. So we need a more general method
// a more widespread api actually does have a UUID per spec. 
window.uuid = () => {
  const url_with_uuid = URL.createObjectURL(new Blob())
  const uuid = url_with_uuid.split('/').pop()
  URL.revokeObjectURL(url_with_uuid)  
  return uuid
}

window.clickedWelcome = () => {
  if (hasUser()) {
    navigateTo('/list');
  } else {    
    localStorage.setItem(LOCAL_USER_PARAM, uuid());
    navigateTo('/list');
  }  
}

window.hasUser = () => {  
  let stored = localStorage.getItem(LOCAL_USER_PARAM);  
  if (!stored) return false;
  if (!stored.match("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")) return false;
  return stored;
}

window.clickedForgetMe = () => { 
  localStorage.removeItem(hasUser());         // 
  localStorage.removeItem(LOCAL_USER_PARAM);
  navigateTo('/');
}

window.submittedAdd = () => {  
  const form = document.getElementById("register-item-form");
  if (form.checkValidity()) {
    let name = document.getElementById("form-name").value
    let uuid = document.getElementById("form-uuid").value
    if (!uuid) { uuid = window.uuid()}    
    storeItem({ name: name, qrid: uuid});        
    navigateTo('/list');
  } 
}

window.clickedSaveDescription = () => {
  const form = document.getElementById("edit-item-form");
  if (form.checkValidity()) {    
    setDesc(
      document.getElementById("form-qrid").value,
      document.getElementById("form-desc").value,  
    );  
    navigateTo('/list');
  } 
}

window.clickedDeleteItem = () => {
  console.log("clicked Delete");
  delItem(document.getElementById("form-qrid").value);
  navigateTo('/list');
}


