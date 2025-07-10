import React from 'react';
import axios from 'axios';

const API = process.env.REACT_APP_API_URL;

function App() {
  const [backendMessage, setBackendMessage] = React.useState('');
  const [testMessage, setTestMessage] = React.useState('');
  const [dbData, setDbData] = React.useState([]);

  const callBackend = async () => {
    const res = await axios.get(`${API}/`);
    setBackendMessage(res.data);
  };

  const callTest = async () => {
    const res = await axios.get(`${API}/test`);
    setTestMessage(res.data);
  };

  const fetchDb = async () => {
    const res = await axios.get(`${API}/db`);
    setDbData(res.data);
  };

  return (
    <div>
      <h1>Frontend - React.js</h1>
      <button onClick={callBackend}>Call `/`</button>
      <p>{backendMessage}</p>

      <button onClick={callTest}>Call `/test`</button>
      <p>{testMessage}</p>

      <button onClick={fetchDb}>Call `/db`</button>
      <ul>
        {dbData.map((item, idx) => <li key={idx}>{item.name}</li>)}
      </ul>
    </div>
  );
}

export default App;
