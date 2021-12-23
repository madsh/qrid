
const LOCAL_USER_PARAM = "qrid-user";


function storeItem(item_) {
    let userId = localStorage.getItem(LOCAL_USER_PARAM)    
    ensureDatabase(userId);
    var list = JSON.parse(localStorage.getItem(userId))

    let now = Date.now()
    const item = {
        name: item_.name,
        qrid: item_.qrid,
        time: now, 
        modi: now
    }

    list.push(item);
    localStorage.setItem(userId, JSON.stringify(list));
}  

function getItems() {
    let userId = localStorage.getItem(LOCAL_USER_PARAM)    
    ensureDatabase(userId);
    return JSON.parse(localStorage.getItem(userId))
}

function getItem(id) {
    let item = getItems().find( item => item.qrid === id)    
    return item;
}

function setItem(id, name, desc, newId) {
    let userId = localStorage.getItem(LOCAL_USER_PARAM)    
    let list = getItems()
    let index = getItems().findIndex( item => item.qrid === id)    
    list[index]['name'] = name;
    list[index]['desc'] = desc;
    list[index]['qrid'] = newId;    
    localStorage.setItem(userId, JSON.stringify(list));    
}

function delItem(id) {    
    let list = getItems()
    console.log("before ", list);
    var newList = list.filter( item => item.qrid !== id);
    console.log("after ", newList);
    setItems(newList);
}

function setItems(list) {
    let userId = localStorage.getItem(LOCAL_USER_PARAM);
    localStorage.setItem(userId, JSON.stringify(list));            
}


function ensureDatabase(userId) {
    let found  = localStorage.getItem(userId);
    if (!found) {
        localStorage.setItem(userId, JSON.stringify([]));
    }
}





export {LOCAL_USER_PARAM, storeItem, getItems, getItem, setItem, delItem}


