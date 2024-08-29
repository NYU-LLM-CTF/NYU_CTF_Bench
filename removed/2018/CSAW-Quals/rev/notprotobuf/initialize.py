#!/usr/bin/env python3
import pickle

from OpenSSL import crypto
from PIL import Image
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from library import CERTFILE, KEYFILE, Base, Pixel


def pickle_image():
    pixels = dict()
    img = Image.open('CSLLC_Logo_Block.png').convert('RGBA').load()
    for x in range(288):
        for y in range(288):
            pixels[(x, y)] = img[x, y][:3]
    assert len(pixels) == 288 * 288
    with open('goodpixels.pickle', 'wb') as f:
        pickle.dump(pixels, f, 4)


def create_certs():
    k = crypto.PKey()
    k.generate_key(crypto.TYPE_RSA, 4096)

    cert = crypto.X509()
    cert.get_subject().C = "US"
    cert.get_subject().ST = "NY"
    cert.get_subject().O = "Carve Systems, LLC"
    cert.get_subject().OU = "CTF division"
    cert.get_subject().CN = "challenge name here"
    cert.set_serial_number(0)
    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(10 * 365 * 24 * 60 * 60)
    cert.set_issuer(cert.get_subject())
    cert.set_pubkey(k)
    cert.sign(k, 'sha512')

    with open(CERTFILE, "wb") as f:
        f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert))
    with open(KEYFILE, "wb") as f:
        f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, k))


def create_db():
    engine = create_engine('sqlite:///pixels.db')
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()

    session.query(Pixel).delete()
    session.add_all(
        [
            Pixel(x=x_, y=y_, r=0, g=0, b=0)
            for y_ in range(288)
            for x_ in range(288)
        ]
    )
    assert session.query(Pixel).count() == 288 * 288

    session.commit()
    session.close()


if __name__ == '__main__':
    pickle_image()
    create_certs()
    create_db()
