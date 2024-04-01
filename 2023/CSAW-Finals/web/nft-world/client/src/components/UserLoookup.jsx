import React from 'react'
import {Row, Col, Button, InputGroup, Form} from 'react-bootstrap';
import { SERVER_URL } from '../util/constants.js';
import { getAccount} from '../util/actions.js';

class UserLookup extends React.Component {
    constructor(){
        super();
    }
    userLookup() {
        const userName = document.getElementById('userlookup').value
        getAccount(userName)
        .then((resp) => {
            if(resp.respCode != 0 ) {
                document.getElementById("lookup-res-username").innerHTML = ''
                document.getElementById("lookup-res-id").innerHTML = ''
                document.getElementById("lookup-res-balance").innerHTML = ''
                document.getElementById("lookup-res-error").innerHTML = resp.message
            }else {

                const respJson = JSON.parse(resp.message)
                document.getElementById("lookup-res-username").innerHTML = 'Username: ' + respJson.UserName
                document.getElementById("lookup-res-id").innerHTML = 'ID: ' + respJson.Id
                document.getElementById("lookup-res-balance").innerHTML = 'Account Balance: ' + respJson.AccountBalance + ' BTC'
                document.getElementById("lookup-res-error").innerHTML = ''

            }
        })
        .catch((error) => console.log(error))
        
    }

    render() {
        return (
            <Row>
                <Col className='user-lookup'>
                    <h2>User Lookup</h2>
                    <InputGroup>
                        <Button onClick={this.userLookup}>Search</Button>
                        <Form.Control
                            type='text'
                            id='userlookup'
                        ></Form.Control>
                    </InputGroup>
                        <div id='lookup-res-id'></div>
                        <div id='lookup-res-username'></div>
                        <div id='lookup-res-balance'></div>
                        <div id='lookup-res-creation-time'></div>
                        <div className='error' id='lookup-res-error'></div>
                </Col>
            </Row>
        )
    }
}

export default UserLookup;