import React from 'react';
import { useNavigate } from "react-router-dom";
import {getQridItemsFromLocal} from "../QRID"

const ListItems = () => {
    const navigate = useNavigate();
    return (
      <main className="container page-container" id="main-content">
      <h1 className="h2">List Items</h1>      

      <ItemTable />

      <div className="button button-secondary mt-9" 
           onClick={() => navigate('/new') }
      >
        Add Item
      </div>

      </main>
    );

  }
  

const ItemTable = () => {
  const list = getQridItemsFromLocal()
               .sort( (a,b) => { return b.time - a.time;});

  

  if (list.length === 0) {
    return (<div className="mt-9">No items in local storage</div>)
  } else
  return (
    <table className="table table--extracompact mt-9">
      <thead>
        <tr>
          <th>Name</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
      {list.map((i) => (
          <ItemRow key={i.qrid} qrid={i.qrid} name={i.name} />
      ))}
      </tbody>
    </table>
  );
}


const ItemRow = ({qrid, name}) => {
  const navigate = useNavigate();

  return (
    <tr onClick={() => navigate('/edit/'+qrid) } >
    <td>{name}</td>
    <td></td>
  </tr>  
  );


}
  

  export default ListItems;