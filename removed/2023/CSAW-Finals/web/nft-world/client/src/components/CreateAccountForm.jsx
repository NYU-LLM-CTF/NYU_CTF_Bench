import React from 'react';
import PropTypes from 'prop-types';
import {Container, Row, Col, Button, InputGroup, Form, Card} from 'react-bootstrap';

class CreateAccountForm extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <Container >
                <Row>
                    <Col>
                    <h1>Welcome to NFT World</h1>
                    </Col>
                </Row>
                <Row>
                    <Col>
                        <Card style={{ width: '30rem' }}>
                            <Card.Body>
                                <Card.Title>Sign Up</Card.Title>
                                <InputGroup>
                                    <Button onClick={this.props.handleLogin}> Create Account </Button>
                                    <Form.Control
                                        type='text'
                                        id="username-box"
                                        onSubmit={this.props.handleLogin}
                                    />
                                </InputGroup>
                                <Card.Text>
                        Here at NFT World, we believe passwords are antiquated and should be replaced by
                        cyrpto-based authentication. We have fired the entire password team and replaced them 
                        with crypto enthusiasts like ourselves. We hope you enjoy our passowrd-free NFT marketplace

                                </Card.Text>
                                <Card.Text id="error-box" className='error'></Card.Text>
                
                            </Card.Body>
                        </Card>
                    </Col>
                </Row>
            </Container>
        )
    }
}
CreateAccountForm.propTypes = {
    handleLogin: PropTypes.func,
};
export default CreateAccountForm;