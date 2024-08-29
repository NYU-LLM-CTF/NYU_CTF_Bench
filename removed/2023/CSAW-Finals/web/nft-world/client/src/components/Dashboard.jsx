import React from 'react';
import { getGamestate } from '../util/actions.js';
import { getAccount, buyNft, getNftLoc, renameNft } from '../util/actions.js';
import { SERVER_URL } from '../util/constants.js';
import {Row, Col, Nav, Container} from 'react-bootstrap';
import NftDisplay from './NftDisplay.jsx'
import UserNfts from './UserNfts.jsx'
import UserLookup from './UserLoookup.jsx'
class Dashboard extends React.Component {
    constructor(){
        super();
        this.state = {
            gameState: {},
            clock: 1000 * 30,
            accountBalance: localStorage.getItem("accountBalance"),
            ownedNfts: []
        }
        this.handleBuy = this.handleBuy.bind(this)
        this.handleRename = this.handleRename.bind(this)
    }
    componentDidMount() {
        getGamestate()
        .then((gameState) => {
            this.setState({gameState: gameState}, () => {
                this.updateOwnedNfts();
                this.updateAccountBalance();
            })
        })
        .catch((error) => {
            console.log(error)
        })
        this.interval = setInterval(() => {
            getGamestate()
            .then((gameState) => {
                this.setState({gameState: gameState})
            })
            .catch((error) => {
                console.log(error)
            })
        }, this.state.clock );

    }
    componentWillUnmount() {
        clearInterval(this.interval);
    }
    updateAccountBalance() {
        const users = this.state.gameState.users;
        for (let i = 0; i < users.length; i ++){
            if (users[i].Id == localStorage.getItem("userId")){
                this.setState({accountBalance: users[i].AccountBalance})
                return
            }
        }
    }
    updateOwnedNfts(){
        const nftIsOwned = (id) => {
            for (let i = 0; i < this.state.ownedNfts.length; i ++ ) {
                if (id == this.state.ownedNfts[i].id){
                    return true
                }
                return false
            }
        };
        if( this.state.gameState.nfts != null) {
            const nfts = this.state.gameState.nfts;
            for (let i = 0; i < nfts.length; i ++ ) {
                if(nfts[i].owned_by == localStorage.getItem("userId") && !nftIsOwned(nfts[i].id)){
                    getNftLoc(nfts[i].id)
                    .then((resp) => {
                        if(resp.respCode == 0) {
                            const nft = {id: nfts[i].id, name: nfts[i].name, loc: resp.message}
                            this.setState({ownedNfts: [...this.state.ownedNfts, nft]})
                        }else {
                            console.log(resp.message)
                        }
                    })
                    .catch((error) => {
                        console.log(error)
                    })
                }
            }
        }
    }
    handleBuy(id) {
        for(let i = 0; i < this.state.gameState.nfts.length; i++) {
            document.getElementById('nft-' + this.state.gameState.nfts[i].id + '-buy-status').innerHTML = ''
        }
        buyNft(id)
        .then((resp) => {
            console.log(resp);
            if (resp.respCode != 0) {
                document.getElementById('nft-' + id + '-buy-status').innerHTML = resp.message;
            }else {
                document.getElementById('nft-' + id + '-buy-status').innerHTML = 'success';
                this.updateOwnedNfts()
                window.location.reload(false);
            }
        })
    }
    handleRename(id){
        for(let i = 0; i < this.state.ownedNfts.length; i++) {
            document.getElementById('nft-' + this.state.ownedNfts[i].id + '-rename-status').innerHTML = ''
        }
        console.log(id)
        const newName = document.getElementById('rename-nft-' + id).value
        console.log(newName)
        renameNft(id, newName)
        .then((resp) => {
            if (resp.respCode != 0) {
                document.getElementById('nft-' + id + '-rename-status').innerHTML = resp.message
            }else {
                document.getElementById('nft-' + id + '-rename-status').innerHTML = 'success'
                window.location.reload(false);
            }
        }

        )
    }
    displayAccountInfo() {
        const name = localStorage.getItem("userName");
        const balance = this.state.accountBalance;
        return (
            <p>{name} - {balance} BTC</p>
        )
    }
    render() {
        return (
            <Container >
                <h1>NFT World</h1>
                <Row className="justify-content-md-center">
                    <Col xs='8' className='nft-display-col'>
                        <NftDisplay gameState={this.state.gameState} handleBuy={this.handleBuy}/>
                    </Col>
                    <Col className='action-col' md='auto'>
                        <h2>My Account</h2>
                        <div>{this.displayAccountInfo()}</div>
                        {this.state.ownedNfts.length > 0 ?<UserNfts ownedNfts={this.state.ownedNfts} handleRename={this.handleRename} /> : <div></div>}
                        <UserLookup />

                    </Col>
                </Row>
            </Container>
            )
        }
    }

export default Dashboard;