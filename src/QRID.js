import { v4 as uuidv4 } from "uuid"; 

const LIST_NAME = "qrids"
const USER_ID = "qrid-for-user"


export const PLAN0 = "plan0";

// how about letting each CRUd operation take a "plan" parameter. Maybe even factor out each plans operation to files. 



export function delQridItem(id, plan) {
    console.log("deleting " + id + " with " + plan);
    var list = JSON.parse(localStorage.getItem(LIST_NAME))
    // remove element with matching qrid
    list.splice(list.findIndex(item => item.qrid === id), 1)
    localStorage.setItem(LIST_NAME, JSON.stringify(list));
}

export function getQridItem(id, plan) {
    var list = JSON.parse(localStorage.getItem(LIST_NAME))
    // find poistion of element with matching qrid
    var i = list.findIndex(item => item.qrid === id);
    return list[i];
}

export function addQridItem(formName, formId) {
    // add uuid if not provided
    const  item  = {
        name: formName,        
        time: Date.now(),
        qrid: (formId) ? formId : uuidv4(),
        modi: Date.now(),
    }

    var list = JSON.parse(localStorage.getItem(LIST_NAME))

    // add list if not found
    if (!list) { list = [] } 
    list.push(item);
    localStorage.setItem(LIST_NAME, JSON.stringify(list));
}

export function getQridItemsFromLocal() {
    if (!localStorage.getItem(LIST_NAME)) {        
        return [];
    } else {
        const stored = localStorage.getItem(LIST_NAME)
        // make sure we have array of items? or just handle exceptions?
        //console.log("TODO: check for malformed local storage")
        const list = JSON.parse(stored)
        // parseexceptions?
        return list;
    }
}

export function purgeQridItemsFromLocal() {
    localStorage.setItem(LIST_NAME, JSON.stringify([]));
}


export function getQridUser() {    
    return localStorage.getItem(USER_ID);
}

export function hasQridUser() {
    const stored = localStorage.getItem(USER_ID);
    if (stored == null) return false;
    console.log("TODO: should check for valid uuid");
    console.log(stored);
    return true;
}

export function setQridUser(id, name) {    
    localStorage.setItem(USER_ID, id);
}

export function delQridUser() {    
    localStorage.removeItem(USER_ID);    
}

