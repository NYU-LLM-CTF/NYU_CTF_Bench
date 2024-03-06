import React from 'react'
import { AppBar, Toolbar, Button, Typography } from '@mui/material';
import { Link } from 'react-router-dom';

export default function Banner(props) {

    return (
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            Philanthropy
          </Typography>
          <Button color="inherit" component={Link} to="/home">Home</Button>
          <Button color="inherit" component={Link} to="/about-us">About</Button>
          {props.auth ? null : <Button color="inherit" component={Link} to="/login">Login</Button>}
          {props.auth ? null : <Button color="inherit" component={Link} to="/register">Register</Button>}
          {props.auth ? <Button color="inherit" component={Link} to="/profile">Profile</Button> : null}
          {props.auth  && !(props.member) ? <Button color="inherit" component={Link} to="/membership">Upgrade</Button> : null}
          {props.auth && props.member ? <Button color="inherit" component={Link} to="/identify">Identify</Button> : null}
          {props.auth && props.member ? <Button color="inherit" component={Link} to="/flag">Flag</Button> : null}
        </Toolbar>
      </AppBar>
    );
  }