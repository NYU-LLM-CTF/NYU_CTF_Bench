import * as React from 'react';
import CssBaseline from '@mui/material/CssBaseline';
import Container from '@mui/material/Container';
import { createTheme, ThemeProvider } from '@mui/material/styles';
import MainFeaturedPost from './MainFeaturedPost';



const mainFeaturedPost = {
  title: 'Our Mission',
  description:
    "To let the world be.",
  image: '/images/let_world_be.png',
  imageText: 'main image description',
  linkText: 'Continue reading…',
  linkHref: '/about-us'
}; 

export default function Home() {

  const defaultTheme = createTheme();
  
    return (
      <ThemeProvider theme={defaultTheme}>
      <Container component="main" maxWidth="lg">
        <CssBaseline />
        <MainFeaturedPost post={mainFeaturedPost} />
        </Container>
    </ThemeProvider>
    );
  }