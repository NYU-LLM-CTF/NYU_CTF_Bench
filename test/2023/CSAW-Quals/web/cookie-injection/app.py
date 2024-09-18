# Import Flask Library
import string, random
from flask import Flask, render_template, request, session, url_for, redirect, make_response
import pymysql.cursors

app = Flask(__name__)

# Configure MySQL
def get_conn():
    return pymysql.connect(
        host="127.0.0.1",
        user='usrrr',
        passwd='password',
        db='email_sqli_ctf',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor)

    # return pymysql.connect(
    #     host="127.0.0.1",
    #     user='root',
    #     passwd='',
    #     db='email_sqli_ctf',
    #     charset='utf8mb4',
    #     cursorclass=pymysql.cursors.DictCursor)


