import { useState } from 'react'
import './App.css'

function App() {
  const [username,setUsername] = useState('');
  const [password,setPassword] = useState('');
  const [msg,setMsg] = useState(null);

  const submit = async()=>{
    const loc = document.location.href
    const url = new URL(loc)
    const fin = 'http://'+url.hostname+':3000'+'/login'
    console.log(fin)
    const res = await fetch(fin,{
      method:"POST",
      headers:{
        'content-type': 'application/json',
      },
      body:JSON.stringify({
        username:username,
        password:password,
      })
    })
    const data = await res.json()
    setMsg(data.msg)
    setPassword('')
    setUsername('')
  }

  return(
    <div>
      <div>
        <h1>Login Portal</h1>
        <div style={{}}>
          <input placeholder='Username' value={username} onChange={(e)=>setUsername(e.target.value)}/>
          <br/>
          <input placeholder='Password' value={password} onChange={(e)=>setPassword(e.target.value)}/>
          <button onClick={submit}>Login</button>
        </div>
      </div>
        {msg && <div>
          <h3>{msg}</h3>
        </div>}
    </div>
  )
}

export default App

