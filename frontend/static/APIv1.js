
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


function ensureDatabase(userId) {
    let found  = localStorage.getItem(userId);
    if (!found) {
        localStorage.setItem(userId, JSON.stringify([]));
    }
}





export {LOCAL_USER_PARAM, storeItem, getItems}


