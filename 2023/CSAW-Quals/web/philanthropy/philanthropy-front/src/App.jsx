import * as React from 'react';
import Container from '@mui/material/Container';
import Box from '@mui/material/Box';
import SignIn from './SignIn';
import SignUp from './SignUp';
import Banner from './Banner';
import Home from './Home'
import AboutUs from './AboutUs'
import Profile from './Profile'
import Membership from './Membership'
import Identify from './Identify'
import Flag from './Flag'
import {Routes, Route } from 'react-router-dom';
import PrivateRoutes from './utils/PrivateRoutes';
import { useState, useEffect } from 'react';
import axios from 'axios'

export default function App() {

  const [auth, setAuth] = useState(false);
  const [member, setMember] = useState(false);

  useEffect(() => {

    axios.get('/identity/verify')
      .then(response => {
        // Handle the response data
        const responseData = response.data;
        console.log(responseData);
        setAuth(true)
        setMember(responseData.msg.Member)
        console.log(member)
      })
      .catch(error => {
        setAuth(false)
        setMember(false)
      });  
    
  }, [auth]);

  return (
    <Container maxWidth="lg">
      <Banner auth={auth} member={member}/>
      <Box sx={{ my: 4 }}>
        <Routes>
          <Route path="/home" element={<Home />} />
          <Route path="/about-us" element={<AboutUs />} />
          <Route element={<PrivateRoutes auth={auth} auth_display={false}/>}>
            <Route path="/register" element={<SignUp />} />
            <Route path="/login" element={<SignIn setAuth={setAuth}/>} />
          </Route>
          <Route element={<PrivateRoutes auth={auth} auth_display={true}/>}>
            <Route path="/profile" element={<Profile />} exact/>
            <Route path="/membership" element={<Membership />} exact/>
            <Route path="/identify" element={<Identify />} exact />
            <Route path="/flag" element={<Flag />} exact />
          </Route>
          
        </Routes>
      </Box>
      
    </Container>
    
  );
}
