import * as React from "react";
import ReactDOM from 'react-dom';
import { BrowserRouter, Routes, Route} from "react-router-dom";
import Layout from "./pages/Layout";
import List from "./pages/List"
import NewItemPage from './pages/NewItem';
import EditItemPage from "./pages/EditItem"
import ScannerPage from "./pages/Scanner"
import ProfilePage from "./pages/Profile"
import LookupPage from "./pages/Lookup"
import WelcomePage from "./pages/Welcome"
import NoPage from './pages/NoPage';
//import { hasQridUser } from "./QRID";
//import { hasQridUser } from "./QRID";

//const UserContext  = React.createContext();

//const hasUser = hasQridUser();


//function PrivateRoute({ children }) {
//  return hasQridUser() ? children : <Navigate to="/not-welcome-yet" />;
//}


function App() {  
  return (
    
    <BrowserRouter>
      <Routes>
        <Route path="/:qrid" element={<LookupPage />} />
        <Route path="/welcome" element={<WelcomePage />} />

        <Route path="/" element={<Layout />}>
          <Route>
            <Route index element={<List />} />
            <Route path="new" element={<NewItemPage />} />                          
            <Route path="edit/:qrid" element={<EditItemPage />} />           
            <Route path="scan" element={<ScannerPage />} />        
            <Route path="profile" element={<ProfilePage />} />                  
            <Route path="*" element={<NoPage />} />        
          </Route>
        </Route>
      </Routes>
    </BrowserRouter>
  );
}




ReactDOM.render(
  <App />,
  document.getElementById('root')
);



//<Route path="*" element={<NoPage />} />