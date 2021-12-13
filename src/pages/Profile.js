import {getQridItemsFromLocal, purgeQridItemsFromLocal, getQridUser, delQridUser} from "../QRID"
import { useNavigate } from "react-router-dom";


export const ProfilePage = () => {
  const navigate = useNavigate();

  var items = getQridItemsFromLocal().length;
  function purge() {
    console.log("purging");
    purgeQridItemsFromLocal();
    navigate('/');
  }
  
  const forget = () => {
    delQridUser();
    navigate("/welcome");
  };

  return (
      <main className="container page-container" id="main-content">
      <h1 className="h2">Profile</h1>
      <p className="subheading">        
        qrid: {getQridUser()}<br/>
        name: <br/>        
        items: {items}
      </p>

      <div className="button button-secondary mt-6" onClick={purge}>Delete Items</div>
      <div className="button button-secondary mt-6" style={{color: "red"}} onClick={forget}>Forget me</div>
      </main>
    );

}


export default ProfilePage
