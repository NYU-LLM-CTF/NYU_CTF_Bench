import React from 'react';
import { Typography, Container, Paper, Box, Button } from '@mui/material';
import { makeStyles } from '@mui/styles';
import { Link as RouterLink } from 'react-router-dom'; // Import RouterLink

const useStyles = makeStyles((theme) => ({
  paper: {
    padding: theme.spacing(4),
    backgroundColor: theme.palette.background.secondary,
    boxShadow: '0px 4px 10px rgba(0, 0, 0, 0.1)',
    borderRadius: '12px',
  },
  heading: {
    fontWeight: 'bold',
    marginBottom: theme.spacing(2),
  },
  joinButton: {
    marginTop: theme.spacing(3),
    padding: theme.spacing(1, 3),
    fontWeight: 'bold',
    backgroundColor: theme.palette.primary.main,
    color: theme.palette.common.white,
    '&:hover': {
      backgroundColor: theme.palette.primary.dark,
    },
  },
}));

export default function AboutUs() {
  const classes = useStyles();

  return (
    <Container maxWidth="md" sx={{ mt: 4 }}>
      <Paper elevation={3} className={classes.paper}>
        <Typography variant="h3" className={classes.heading} gutterBottom>
          About Us
        </Typography>
        <Typography variant="body1" paragraph>
          Welcome to Philanthropy, a dedicated organization working to address the challenges posed by Metal Gear technology.
          In a world where these powerful machines have the potential to disrupt global stability, our mission is to spread
          awareness and foster a safer future.
        </Typography>
        <Typography variant="body1" paragraph>
          Philanthropy is committed to educating the public about the implications of Metal Gear. Our website serves as a
          hub of information, providing insights into the risks associated with these advanced machines and their potential
          for misuse.
        </Typography>
        <Typography variant="h4" paragraph>
          What is a Metal Gear?
        </Typography>
        <Typography variant="body2" paragraph>
          A Metal Gear is a colossal, bipedal, nuclear-armed mech with the potential to wreak havoc on a global scale.
          Often used as a tool of warfare, its formidable power can disrupt the balance of world affairs. Identifying
          one requires vigilance and knowledge.
        </Typography>
        <Typography variant="h4" paragraph>
          How to Identify a Metal Gear?
        </Typography>
        <Typography variant="body2" paragraph>
          Metal Gears are characterized by their massive size, armored structure, and advanced weaponry. They are designed
          for both land and water operations. Vigilance is key; be on the lookout for unusual military developments,
          secret research facilities, and unexplained disappearances that could indicate the presence of a Metal Gear.
        </Typography>
        <Typography variant="h4" paragraph>
          How Can I Help?
        </Typography>
        <Typography variant="body2" paragraph>
          You can contribute to our cause in various ways. Start by spreading awareness about the potential dangers of
          Metal Gear technology in your community. Engage in discussions, share our resources, and collaborate with
          like-minded individuals to create a collective voice against these threats.
        </Typography>
        <Typography variant="body2" paragraph>
          Additionally, consider joining Philanthropy as a member or volunteer. Your passion and expertise can help us
          further our mission to safeguard global security. Together, we can work towards a safer and more secure world for
          all.
        </Typography>
        <Box sx={{ mt: 3 }}>
          <Typography variant="body2" color="text.secondary">
            Join us in spreading awareness and contributing to the conversation. Together, we can work towards a world where
            the potential dangers of Metal Gear are acknowledged and addressed, ensuring a safer and more informed society.
            Contact us at otacon@protonmail.com{/*or solidsnake@protonmail.com*/} / click the button below!
          </Typography>

          <RouterLink to="/register" style={{ textDecoration: 'none' }}>
            <Button className={classes.joinButton}>Join Us</Button>
          </RouterLink>

        </Box>
      </Paper>
    </Container>
  );
}