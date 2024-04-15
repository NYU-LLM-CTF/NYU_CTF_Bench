#![allow(non_snake_case)]
#[macro_use] extern crate rocket;

use std::collections::HashMap;

use rocket::request::{Request, FromRequest, Outcome};
use rocket::response::Redirect;
use rocket::form::{Form, FromForm};
use rocket_dyn_templates::Template;
use rocket::fs::{FileServer, relative};

use getrandom::getrandom;
use aes_gcm::{NewAead, AeadInPlace};
use block_modes::BlockMode;
type Aes128Cbc = block_modes::Cbc<aes::Aes128, block_modes::block_padding::Pkcs7>;

use iBad::{SECRET_KEY, FLAG};

struct Admin ();

#[rocket::async_trait]
impl<'r> FromRequest<'r> for Admin {
    type Error = &'static str;

    async fn from_request(req: &'r Request<'_>) -> Outcome<Self, Self::Error> {
        match req.cookies().get("auth") {
            Some(auth) => {
                let parts = auth.value().split(".").collect::<Vec<&str>>();
                let mut decrypted = match parts.len() {
                    2 => { // Legacy path
                        let iv = base64::decode(parts[0]).unwrap();
                        let ciphertext = base64::decode(parts[1]).unwrap();

                        let cipher = Aes128Cbc::new_from_slices(SECRET_KEY.as_ref(), &iv).unwrap();

                        cipher.decrypt_vec(ciphertext.as_ref()).unwrap()
                    },
                    3 => { // Upgraded encryption
                        let key = aes_gcm::Key::from_slice(SECRET_KEY);
                        let cipher = aes_gcm::Aes128Gcm::new(key);

                        let tag_raw = base64::decode(parts[0]).unwrap();
                        let tag = aes_gcm::Tag::from_slice(tag_raw.as_slice());
                        let nonce_raw = base64::decode(parts[1]).unwrap();
                        let nonce = aes_gcm::Nonce::from_slice(nonce_raw.as_slice());
                        let mut plaintext = base64::decode(parts[2]).unwrap();

                        cipher.decrypt_in_place_detached(nonce, b"", plaintext.as_mut_slice(), tag).unwrap();
                        plaintext
                    },
                    _ => return Outcome::Failure((rocket::http::Status::Unauthorized, "invalid cookie format"))
                };

                for _ in 0..decrypted.len() {
                    if decrypted.starts_with(b"|admin|") {
                        return Outcome::Success(Admin());
                    }
                    decrypted.rotate_left(1);
                }
                Outcome::Forward(())
            },
            None => Outcome::Failure((rocket::http::Status::Unauthorized, "No cookie"))
        }
    }
}

#[get("/")]
fn index() -> Template {
    Template::render("index", HashMap::<(), ()>::new())
}

#[get("/login")]
fn login_page() -> Template {
    Template::render("login", HashMap::<(), ()>::new())
}

#[derive(FromForm)]
struct LoginData<'r> {
    username: &'r str
}

#[post("/login", data="<data>")]
fn login_submit(data: Form<LoginData<'_>>, cookies: &rocket::http::CookieJar<'_>) -> rocket::response::Redirect {

    let key = aes_gcm::Key::from_slice(SECRET_KEY);
    let cipher = aes_gcm::Aes128Gcm::new(key);
    
    let mut nonce_raw: [u8; 12] = [0; 12];
    let _ = getrandom(&mut nonce_raw).unwrap();
    let nonce = aes_gcm::Nonce::from_slice(&nonce_raw);

    let mut ciphertext = format!("{}|regular|{}", data.username, FLAG).bytes().collect::<Vec<u8>>();

    let tag = cipher.encrypt_in_place_detached(nonce, b"", ciphertext.as_mut_slice()).unwrap();

    cookies.add(rocket::http::Cookie::new("auth", format!("{}.{}.{}", base64::encode(tag), base64::encode(nonce), base64::encode(ciphertext))));
    Redirect::to(uri!(profile()))
}

#[catch(401)]
fn unauth() -> Redirect {
    Redirect::to(uri!(login_page()))
}

#[get("/profile")]
fn profile(_admin : Admin) -> Template {
    Template::render("admin_profile", HashMap::<(), ()>::new())
}

#[get("/profile", rank=2)]
fn regular_profile() -> Template {
    Template::render("profile", HashMap::<(), ()>::new())
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes![
            index,
            login_page,
            login_submit,
            profile,
            regular_profile])
        .mount("/", FileServer::from(relative!("static")))
        .register("/", catchers![unauth])
        .attach(Template::fairing())
        .configure(rocket::Config {
            address: std::net::IpAddr::V4(std::net::Ipv4Addr::UNSPECIFIED),
            ..rocket::Config::release_default()
        })
}
