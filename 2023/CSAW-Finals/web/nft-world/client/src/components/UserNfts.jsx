import React from 'react'
import {Row, Col, Button, ListGroup, InputGroup, Form} from 'react-bootstrap';
import { SERVER_URL } from '../util/constants.js';

class UserNfts extends React.Component {
    constructor(){
        super();
    }
    render() {
        let res = []
        res.push(<h2 key='my-nfts'>My Nfts</h2>)
        const ownedNfts = this.props.ownedNfts;
        
        for(let i = 0; i < ownedNfts.length; i ++) {
            let div =
                <ListGroup key={'owned-nft-' + i}>
                    <ListGroup.Item>
                        <div><b>{ownedNfts[i].name} :</b> <a href={SERVER_URL + '/static/' + ownedNfts[i].loc}>view nft</a></div>
                        <InputGroup>
                            <Button 
                                onClick={() => {this.props.handleRename(ownedNfts[i].id)}}
                            >
                            rename
                            </Button>
                            <Form.Control 
                                type='text'
                                onSubmit={() => {this.props.handleRename(ownedNfts[i].id)}}
                                id={'rename-nft-' + ownedNfts[i].id}
                            >
                            </Form.Control>
                        </InputGroup>
                    </ListGroup.Item>
                    
                <div className='error' id={'nft-'+ ownedNfts[i].id + '-rename-status'}></div>

                </ListGroup>
            res.push(div)
        }
        return (res)
        
    }
}

export default UserNfts;