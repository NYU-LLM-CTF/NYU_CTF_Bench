import React from 'react'
import {Row, Col, Button, ListGroup} from 'react-bootstrap';
import { SERVER_URL } from '../util/constants.js';

class NftDisplay extends React.Component {
    constructor(){
        super();
    }

    render(){
        const gameState = this.props.gameState;
        let nfts = [];
        if( gameState.nfts != null) {
            for (let i = 0; i < gameState.nfts.length; i ++ ) {
                 let n =
                    <Row key={'nft-' + gameState.nfts[i].id} className='nft-display-row'>
                        <Col className='nft-img-col'>
                            <div>
                                <img  src = {SERVER_URL +'/static/' + gameState.nfts[i].preview_loc} width="400" height="200"/>
                            </div>
                        </Col>
                        <Col>
                            <ListGroup>
                                <ListGroup.Item><b>Name: </b>{gameState.nfts[i].name}</ListGroup.Item>
                                <ListGroup.Item><b>Owner: </b>{gameState.nfts[i].owned_by_name}</ListGroup.Item>
                                <ListGroup.Item><b>Price: </b>{gameState.nfts[i].price} BTC</ListGroup.Item>
                                <Button  onClick={() => this.props.handleBuy(gameState.nfts[i].id)}>buy nft</Button>
                                <p className='error' id={'nft-' + gameState.nfts[i].id + '-buy-status'}></p>
                            </ListGroup>
                        </Col>
                    </Row>
                 // let p = <div>{gameState.nfts[i].price}</div>
                nfts.push(n) 

            }
        }
        return (nfts)
    }

}
export default NftDisplay;