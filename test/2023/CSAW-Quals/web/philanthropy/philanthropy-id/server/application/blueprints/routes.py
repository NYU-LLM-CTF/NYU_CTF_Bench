from flask import Blueprint, jsonify, current_app, request
from application.database import Account, Image, db
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity, set_access_cookies, unset_jwt_cookies

identity = Blueprint('identity', __name__)

def response(message):
    return jsonify({'msg': message})

@identity.route("/register",methods=["POST"])
def register():

    if not request.is_json:
        return response('Missing required parameters!'), 401
    
    username = request.json.get("username",None)
    password = request.json.get("password",None)
    first_name = request.json.get("first_name", None)
    last_name = request.json.get("last_name", None)

    if not username or not password:
        return response('Missing required parameters!'), 401
    
    account = Account.query.filter_by(username=username).first()

    if account:
        return response('User already exists!'), 401
    
    new_user = Account(username=username, password=password, first_name=first_name, last_name=last_name)
    db.session.add(new_user)
    db.session.commit()

    return response('User registered successfully!')

@identity.route('/login',methods=["POST"])
def login():

    if not request.is_json:
        return response('Missing required parameters!'), 401

    username = request.json.get("username", None)
    password = request.json.get("password", None)

    if not username or not password:
        return response('Missing required parameters!'), 401

    account = Account.query.filter_by(username=username).first()

    if not account or not account.password == password:
        return response('Invalid username or password!'), 403
    
    

    if account.member:
        add_claims = {"member": True}
    
    else:
        add_claims = {"member": False}

    access_token = create_access_token(identity=username, additional_claims=add_claims)

    resp = jsonify({'login':True})

    set_access_cookies(resp, access_token)

    return resp, 200

@identity.route("/verify",methods=["GET"])
@jwt_required(locations='cookies')
def verify():

    username = get_jwt_identity()

    account = Account.query.filter_by(username=username).first()

    resp = {"Valid":True, "Username": username, "Member": account.member}

    return response(resp), 200

@identity.route('/account',methods=["GET"])
@jwt_required(locations='cookies')
def get_account():
    
    username = get_jwt_identity()
    account = Account.query.filter_by(username=username).first()

    resp = {}
    
    for col in account.__table__.columns:
        if col.name != "id" and col.name != "password":
            resp[col.name] = getattr(account, col.name)

    return response(resp),200

@identity.route('/logout',methods=["POST"])
@jwt_required(locations='cookies')
def logout():
    
    resp = jsonify({'logout': True})
    unset_jwt_cookies(resp)
    return resp, 200

@identity.route('/update',methods=["POST"])
@jwt_required(locations='cookies')
def update_account():
    
    username = get_jwt_identity()

    if not request.is_json:
        return response('Missing required parameters!'), 401
    
    account = Account.query.filter_by(username=username).first()

    print(request.json)

    for key in request.json:
        if key not in ["id","username"]:
            setattr(account,key,request.json[key])

    db.session.commit()

    return response("Success"), 200


@identity.route("/upgrade",methods=["POST"])
@jwt_required(locations='cookies')
def membership():

    username = get_jwt_identity()

    if not request.is_json:
        return response('Missing required parameters!'), 401
    
    account = Account.query.filter_by(username=username).first()

    code = request.json.get("code", None)

    if not code:
        return response('Missing required parameters!'), 401
    
    return response("Incorrect code!"), 401

@identity.route("/get_flag", methods=["GET"])
@jwt_required(locations='cookies')
def get_flag():

    username = get_jwt_identity()

    if username != "solidsnake@protonmail.com":
        return response("Unauthorized!"), 403
    
    return response("/images/3f9148b5-22da-48e8-b36e-fa9a2c723b81.png"), 200

@identity.route("/images",methods=["GET"])
def images():

    username = request.args.get('user')[1:-1]
    
    images = Image.query.filter_by(submitter=username).all()

    def custom_serializer(obj):
        if isinstance(obj, Image):
            return {
                "filename": obj.filename,
                "submitter": obj.submitter,
                "credit": obj.credit,
                "mg_model": obj.mg_model
            }
        raise TypeError("Object of unsupported type")

    resp = []

    for image in images:
            resp.append(custom_serializer(image))


    return response(resp), 200

#Upgrade someone to a member
@identity.route("/verify_code",methods=["POST"])
@jwt_required()
def member():
    return response("Incorrect code"), 401