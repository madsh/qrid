import { Outlet} from "react-router-dom";
import { hasQridUser } from "../QRID";




const Layout = () => {
  //const navigate = useNavigate()

  console.log("laying out " + hasQridUser());

  return (
    <>
    <header style={{fontWeight: 700, fontSize: "18px", color: "#aaa"}} className="mx-4 mt-4">
    
    <div>

    <div style={{float: "left",}} ><a href="/" className="logo">qrid.info</a></div>
    <div style={{float: "right"}}>
      <a href="/profile"><svg className="icon-svg" >
        <svg viewBox="0 0 24 24">
          <path d="M0 0h24v24H0V0z" fill="none"/>
          <path fill="#aaa" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM7.07 18.28c.43-.9 3.05-1.78 4.93-1.78s4.51.88 4.93 1.78C15.57 19.36 13.86 20 12 20s-3.57-.64-4.93-1.72zm11.29-1.45c-1.43-1.74-4.9-2.33-6.36-2.33s-4.93.59-6.36 2.33C4.62 15.49 4 13.82 4 12c0-4.41 3.59-8 8-8s8 3.59 8 8c0 1.82-.62 3.49-1.64 4.83zM12 6c-1.94 0-3.5 1.56-3.5 3.5S10.06 13 12 13s3.5-1.56 3.5-3.5S13.94 6 12 6zm0 5c-.83 0-1.5-.67-1.5-1.5S11.17 8 12 8s1.5.67 1.5 1.5S12.83 11 12 11z"/>
        </svg>
      </svg></a>        
    </div>
    <div style={{margin: "0 auto", width: "300px", textAlign: "center"}}>
    ...
      <a href="/scan"><svg className="icon-svg">
      <svg viewBox="0 0 24 24" >
        <path d="M0 0h24v24H0z" fill="none"/>
        <path fill="#aaa" d="M21 6h-3.17L16 4h-6v2h5.12l1.83 2H21v12H5v-9H3v9c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zM8 14c0 2.76 2.24 5 5 5s5-2.24 5-5-2.24-5-5-5-5 2.24-5 5zm5-3c1.65 0 3 1.35 3 3s-1.35 3-3 3-3-1.35-3-3 1.35-3 3-3zM5 6h3V4H5V1H3v3H0v2h3v3h2z"/>
      </svg>
      </svg></a>        
    ... 
    </div>


    </div>



    </header>
      
      <Outlet />
    </>
  )
};
  
export default Layout;