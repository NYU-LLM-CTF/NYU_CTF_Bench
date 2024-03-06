import React, { useState, useEffect } from 'react';
import { Button, Card, CardActions, CardContent, CardMedia, Typography } from '@mui/material';
import axios from 'axios';
import Container from '@mui/material/Container';

//const Identify = () => {
export default function Flag() {

    const [flagImage, setFlagImage] = useState("");

    useEffect(() => {
        axios.get('/identity/get_flag')
        .then(response => {
        // Handle the response data
        const responseData = response.data;
        setFlagImage(responseData.msg);
        })
        .catch(error => {
        setFlagImage("unauthorized")
        });
    }, []);

  if (flagImage === "") {
    return <p>Loading...</p>;
  }

  if (flagImage === "unauthorized") {
    return (
    <Container maxWidth="sm">
      <Typography variant="h3">Sorry... You're not supposed to be here...</Typography>
      <Card>
        <CardMedia component="img" width="100" height="800" image="/images/unauthorized.png" alt="flag" />
      </Card>
    </Container>
    )
  }

  return (
    <Card>
      <CardMedia component="img" height="800" image={flagImage} alt="flag" />
    </Card>
  );
};