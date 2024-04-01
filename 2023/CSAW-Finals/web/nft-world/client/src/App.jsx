import React  from 'react'
import CreateAccountForm  from './components/CreateAccountForm.jsx';
import Dashboard from './components/Dashboard.jsx';
import {createAccount, getCaptcha } from './util/actions.js';
import "./css/style.css"

class App extends React.Component {
    constructor() {
        super();
        this.state = {
            logedIn: false,
            time: Date.now(),
            clock: 10,
            error: '',
        };
        this.handleLogin = this.handleLogin.bind(this);
        if (localStorage.getItem("creationTime") != null) {
            this.state.logedIn = true;
        }
    }
    handleLogin() {
        this.setState({error: ''})
        const textBox = document.getElementById("username-box");
        const username  = textBox.value;
        console.log(username);
        getCaptcha().then((token) => {
            createAccount(username, token).then((resp) => {
                if (resp.respCode == 0) {
                    const user = JSON.parse(resp.message);
                    console.log(user);
                    localStorage.setItem("userId", user.Id);
                    localStorage.setItem("creationTime", user.CreatedAt);
                    localStorage.setItem("userName", user.UserName);
                    localStorage.setItem("accountBalance", user.AccountBalance);
                    this.setState({logedIn: true});
                }else {
                    document.getElementById("error-box").innerHTML = resp.message
                }
            }).catch((error) => {
                console.log(error)
            })
        })
    }
    render () {
        return(
            <div>
                <div>
                    {this.state.logedIn ? <Dashboard /> : <CreateAccountForm handleLogin={this.handleLogin} />}
                </div>
            </div>
        )
    }
}
export default App;