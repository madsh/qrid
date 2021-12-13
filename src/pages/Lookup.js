import { useParams } from "react-router-dom";




export const LookupPage = () => {

  let params = useParams();

  const qrid = params.qrid

  

  return (
      <main className="container page-container" id="main-content">
      <h1 className="h2 mt-0">Lookup Item</h1>
      <p className="subheading">name: <br/>qrid: {qrid}</p>
      If there is a public note on an item, this is where it will show up
      </main>
    );

}

export default LookupPage
  