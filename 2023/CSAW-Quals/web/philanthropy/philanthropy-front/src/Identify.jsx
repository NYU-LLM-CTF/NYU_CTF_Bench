import React, { useState, useEffect } from 'react';
import { Button, Card, CardActions, CardContent, CardMedia, Typography } from '@mui/material';
import axios from 'axios';
import Grid from '@mui/material/Grid';

export default function Identify() {
  const [images, setImages] = useState([]);
  const [imageIndexes, setImageIndexes] = useState([]);
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [message, setMessage] = useState("Is this a Metal Gear?");
  const [otaconImage, setOtaconImage] = useState("/images/otacon_neutral.png");
  const snakePictures = false;

  useEffect(() => {
    axios.get('/identity/images?user="otacon@protonmail.com"')
      .then(response => {
        const responseData = response.data;
        setImages(responseData.msg);

        const shuffledIndexes = [...Array(responseData.msg.length).keys()];
        shuffleArray(shuffledIndexes);
        setImageIndexes(shuffledIndexes);
      })
      .catch(error => {
        console.error('Error:', error);
      });

    if (snakePictures){
    axios.get('/identity/images?user="solidsnake@protonmail.com"')
    .then(response => {
      const responseData = response.data;
      setImages(responseData.msg);

      const shuffledIndexes = [...Array(responseData.msg.length).keys()];
      shuffleArray(shuffledIndexes);
      setImageIndexes(shuffledIndexes);
    })
    .catch(error => {
      console.error('Error:', error);
    });}
  }, []);

  const shuffleArray = (array) => {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
  };

  const handleNextImage = (success) => {
    if (success) {
      setMessage("Correct! Is this a Metal Gear?");
      setOtaconImage("/images/otacon_correct.png");
    } else {
      setMessage("Sorry... Not quite! Is this a Metal Gear?");
      setOtaconImage("/images/otacon_incorrect.png");
    }

    if (imageIndexes.length === 1) {
      const shuffledIndexes = [...Array(images.length).keys()];
      shuffleArray(shuffledIndexes);
      setImageIndexes(shuffledIndexes);
      setCurrentImageIndex(shuffledIndexes[0]); // Set the new current index
    } else {
      setImageIndexes(prevIndexes => {
        const newIndexes = prevIndexes.filter(index => index !== currentImageIndex);
        setCurrentImageIndex(newIndexes[0]); // Set the new current index
        return newIndexes;
      });
    }
  };

  const handleNoButtonClick = () => {
    if(images[currentImageIndex].mg_model === "NONE"){
      handleNextImage(true);
    }
    else{
      handleNextImage(false);
    }
  };

  const handleYesButtonClick = () => {
    if(images[currentImageIndex].mg_model !== "NONE"){
      handleNextImage(true);
    }
    else{
      handleNextImage(false);
    }
  };

  if (images.length === 0) {
    return <p>Loading...</p>;
  }

  return (
    <Grid container spacing={2}>
    <Grid item xs={8}>
    <Card>
      <CardMedia component="img" height="600" image={`/images/${images[currentImageIndex].filename}`} alt={`Image ${currentImageIndex + 1}`} />
      <CardContent>
        <Typography variant="h5" component="div">
          {message}
        </Typography>
      </CardContent>
      <CardActions>
        <Button onClick={handleNoButtonClick} variant="contained" color="error">
          No
        </Button>
        <Button onClick={handleYesButtonClick} variant="contained" color="success">
          Yes
        </Button>
      </CardActions>
    </Card>
    </Grid>
    <Grid item xs={4}>
      <Card>
        <CardMedia component="img" height="750" image={otaconImage} alt="otacon" />
      </Card>
    </Grid>
    </Grid>
  );
};