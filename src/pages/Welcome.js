import { v4 as uuidv4 } from "uuid"; 
import { useNavigate } from "react-router-dom";
import { setQridUser } from "../QRID"

const WelcomePage = () => {
  const navigate = useNavigate();
  const qrid = uuidv4();

    function jumpIn() {
      console.log("let's go " + qrid);
      // set user in local storage....            
      setQridUser(qrid, "jumper");
      navigate('/');
    }
 
    

    return (
      <main className="container page-container" id="main-content">
      <h1 className="h2">Welcome</h1>      
      <p className="subheading">new: {qrid}</p>
      

      <div className="button button-secondary mt-9" onClick={jumpIn}>
        Jump right in
      </div>


      <hr className="mt-9"/>
      <h1 className="h2 mt-9">Welcome back</h1>      

      <button className="button button-secondary mt-9" disabled>
        Recognize me...and let me in...
      </button>

      </main>
    );

  }


export default WelcomePage
