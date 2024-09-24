import { Outlet, Navigate } from 'react-router-dom'


/*const PrivateRoutes = (props) => {
    //let auth = {'token': true }
    //const [auth, setAuth] = useState(false)
    console.log(props.auth)
    return(
        props.auth ? <Outlet /> : < Navigate to="/login" />
    )
}*/
//const auth_display = false;

const PrivateRoutes = (props) => {
    if (props.auth_display) {
        return(
            props.auth ? <Outlet /> : < Navigate to="/login" />
        )
    }
    else {      
        return(
            props.auth ? < Navigate to="/home" /> : <Outlet /> 
        )
    }
    
}

export default PrivateRoutes