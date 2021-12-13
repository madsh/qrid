import { useParams } from "react-router-dom";
import { useNavigate } from "react-router-dom";
import { getQridItem, delQridItem, PLAN0 } from "../QRID"


export const EditItemPage = () => {
  const navigate = useNavigate();

  let params = useParams();

  const qrid = params.qrid

  const item = getQridItem(qrid, PLAN0);
  
  function deleteClicked() {
    delQridItem(qrid);    
    navigate("/");
  }

  return (
      <main className="container page-container" id="main-content">
      <h1 className="h2">Edit Item</h1>
      <p className="subheading">name: {item.name}<br/>qrid: {qrid}</p>

      <div className="button button-secondary mt-6" onClick={deleteClicked}>Delete</div>
      </main>
    );

}

export default EditItemPage
 