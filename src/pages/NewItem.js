import React from 'react';
import {useForm} from "react-hook-form";
import { v4 as uuidv4 } from "uuid";
import { validate as uuidValidate } from "uuid";
import { addQridItem } from "../QRID"
import { useNavigate } from "react-router-dom";


const NewItemPage = () => {

    return (
      <main className="container page-container" id="main-content">
      <h1 className="h2">Register Item</h1>
      <NewItemForm />
      </main>
    );

  }

  
const NewItemForm = () => {
  const navigate = useNavigate();
  const { handleSubmit, register, setValue, getValues, formState: { errors } } = useForm();
  
  
  const onSubmit = values => {
    console.log(values);
    addQridItem(values['name']);    
    //addQridItemToLocal(values['name'],values['qrid']);
    navigate('/');
  }
  

  function newQRID() {
      const uuid = uuidv4();
      return uuid;      
  }
 
  return (
    <form onSubmit={handleSubmit(onSubmit)}>

      <div className={"form-group name" + ((errors.firstname) ? " form-error" : "")}>
        <label className="form-label" htmlFor="name">
          Name
        </label>
        <span className="form-hint" id="name-hint">
            A friendly label to recognize the item
        </span>        
        {errors.name && <span className="form-error-message" id="name-error">The name must be at least 4 characters long</span>}        
        <input className="form-input input input-width-xl" {...register("name", { required: true, minLength: 4})} />
      </div>


      <div className={"form-group qrid" + ((errors.qrid) ? " form-error" : "")}>
        <label className="form-label" htmlFor="qrid">
          UUID
        </label>
        <span className="form-hint" id="qrid-hint">
            A universially unique id to store the item under. <br /> 
            If you can't scan one or type one, just leave it blank.               
        </span>
        <span className="form-error-message" id="qrid-error">
          {errors.qrid && <span>The name must be a valid UUID</span>}
        </span>
        <input className="form-input input input-width-xl" 
          {...register("qrid", {
              minLength: 8,
              validate: () => ( getValues('qrid') === '' || uuidValidate(getValues('qrid')) )
              })} />
      </div>

      <div className="mt-6">
      
      <input className="button button-primary" type="submit" value="Save"/>
      <div className="button button-secondary" 
           onClick={() => 
            setValue('qrid',newQRID()
            , { shouldValidate: true}
            )
            }>Generate UUID</div>
      </div>
    </form>
  );
}




export default NewItemPage

