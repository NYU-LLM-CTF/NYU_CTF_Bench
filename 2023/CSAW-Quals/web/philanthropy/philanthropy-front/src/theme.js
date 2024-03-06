import { createTheme } from '@mui/material/styles';
import { red } from '@mui/material/colors';

// Create a theme instance.
const theme = createTheme({
  palette: {
    primary: {
      main: '#575a69',
    },
    secondary: {
      main: '#637371',
    },
    error: {
      main: red.A400,
    },
  },
});

export default theme;