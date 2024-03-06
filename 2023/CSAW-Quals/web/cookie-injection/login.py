from app import *
import string, random
from flask import Flask, make_response
import re


def generate_cookie(length = 20):
    characters = string.ascii_letters + string.digits
    random_string = ''.join(random.choice(characters) for _ in range(length))
    return random_string

def validEmail(email):
    regex = "^[a-zA-Z0-9-_!#$%&'*+-/=?^_`{|}~']+@[a-zA-Z0-9]+\.[a-z]{1,3}$"
    return re.search(regex, email)

def isadmin():
    if session and session['email'] not in ['', 'Error']:
        cursor = get_conn().cursor()
        query = 'SELECT privilege FROM users WHERE email=%s'
        cursor.execute(query, (session['email']))
        if cursor.fetchone()['privilege']=='admin':
            cursor.close()
            #test ewr
            return True
    return False

def getPass():
    if session and session['email'] not in ['', 'Error']:
        cursor = get_conn().cursor()
        query = 'SELECT password FROM users WHERE email=%s'
        cursor.execute(query, (session['email']))
        return cursor.fetchone()['password']
    return ''

def authenticate(email = '', password = ''):
    name = ''
    cursor = get_conn().cursor()
    if email and password:
        if validEmail(email):
            query = "SELECT * FROM users WHERE email = %s AND password = %s"
            cursor.execute(query, (email, password))

            user = cursor.fetchone()

            if user:
                name = user['name']
                session['email'] = user['email']
                message = "View Details"
                if isadmin():
                    message = "Edit Details"
                return render_template('userHome.html', welcome = name, flag = True, message=message)
    message = "Sorry, this user is doesn't exist"
    cursor.close()
    return render_template('login.html', error=message)

def injectableFunction():
    cursor = get_conn().cursor()
    cookie = request.cookies.get("trackingID")
    query = f"SELECT * FROM trackingid WHERE cookie='{cookie}';"
    try:
        cursor.execute(query)
        badSQLflag = False      # means the SQL query was good
        result = cursor.fetchone()
    except Exception:
        badSQLflag = True       # means it was bad SQL query
        result = None

    session['trackingID'] = cookie

    # if no results or SQL error
    if not result or badSQLflag:
        session['email'] = 'Error'
    else:
        session['email'] = ''
    cursor.close()
    return 
    

@app.route('/login', methods = ["POST"])
def login():
    injectableFunction()
    return render_template('login.html')



@app.route('/submit', methods = ["POST", "GET"])
def submit():
    if not session or session['email'] in ['', 'Error']:
        email = request.form['email']
        password = request.form['password']
    else:
        email = session['email']
        password = getPass()

    return authenticate(email, password)



@app.route('/displaydetails', methods = ['POST'])
def display():

    single = {
        'name' : "Pay-Per-Ride",
        'details' : """The MTA (Metropolitan Transportation Authority) single ride pass is a type of ticket that allows you to take a single ride on the New York City subway system or buses. Here are some key details about the MTA single ride pass:
                Validity: The single ride pass is valid for one subway ride or one bus ride within the New York City transit system. It does not allow for transfers between different subway lines or buses.
                Duration: The pass is typically valid for a limited time, usually about two hours from the time it is first used. During this period, you can make transfers between subway lines or buses as long as you stay within the system.
                Purchasing: You can purchase a single ride pass at subway station vending machines, from authorized retailers, or by using the MTA's mobile apps. The payment methods accepted may include cash, credit/debit cards, and mobile payment options.
                Features: The single ride pass is a convenient option for individuals who don't use the subway or buses regularly or for tourists visiting New York City for a short period. It provides a one-time entry to the transit system.
                No Reuse: It's important to note that the single ride pass is typically for one-time use only. Once you've used it for a ride, it cannot be reused.
                Fare Options: The MTA offers various fare options, including daily and weekly unlimited MetroCards for frequent riders. These options may be more cost-effective for individuals who plan to use public transportation multiple times in a day or week.""",
        'price' : "$2.90"

    }

    week = {
        'name' : "7-Day Pass",
        'details' : """The Metropolitan Transportation Authority (MTA) in New York City offered various types of passes and fare options for public transportation, including subway and buses. One of these options is the "7-Day Unlimited MetroCard," often referred to as a "Weekly Pass."
                Unlimited Rides: With the 7-Day Unlimited MetroCard, you can take an unlimited number of subway and local bus rides within New York City during the seven consecutive days after the first use.
                Convenience: This pass is convenient for residents and visitors who plan to use public transportation frequently within a week, as it provides unlimited access to the subway and buses.
                Express Buses and Reduced Fare Options: It's important to note that the 7-Day Unlimited MetroCard does not include express buses, which require an additional fare. Additionally, there are reduced fare options available for senior citizens, people with disabilities, and qualifying individuals.
                Validity Period: The 7-Day Unlimited MetroCard becomes active the first time you use it in a subway turnstile or on a bus and remains valid for seven consecutive days.
                Refunds and Replacement: In case your MetroCard is lost or stolen, it is typically non-refundable. However, if you have registered your MetroCard on the MTA's website and report it, you may be eligible for a replacement with the remaining value transferred to a new card.""",
        'price' : "$34"

    }

    month = {
        'name' : "30-Day Pass",
        'details' : """The Metropolitan Transportation Authority (MTA) in New York City offers a "Monthly Unlimited MetroCard," which is commonly referred to as a "Month Pass." Please note that details, prices, and availability may have changed since then, so it's important to check the MTA's official website or contact them for the most up-to-date information.
                Unlimited Rides: The Monthly Unlimited MetroCard allows unlimited rides on the New York City subway system and local buses within the five boroughs (Manhattan, Brooklyn, Queens, The Bronx, and Staten Island) for an entire calendar month.
                Convenience: This pass is particularly useful for regular commuters and residents who rely on public transportation for daily travel within New York City. It eliminates the need to purchase individual subway and bus fares.
                Express Buses and Reduced Fare Options: It's important to note that the Monthly Unlimited MetroCard does not include express bus service, which requires an additional fare. Reduced fare options may be available for eligible individuals, such as senior citizens, people with disabilities, and qualifying students.
                Activation and Expiration: The Monthly Unlimited MetroCard is typically activated upon the first use and remains valid for 30 consecutive days. For example, if you start using it on the 15th of a month, it will be valid until the end of the 14th of the following month.
                Refunds and Replacement: If your MetroCard is lost or stolen, it is generally non-refundable. However, if you have registered your MetroCard on the MTA's website and report it, you may be eligible for a replacement with the remaining value transferred to a new card.""",
        'price' : "$132"

    }

    pass_type = request.form.get('passType')
    if pass_type == 'single':
        return render_template('displaydetails.html', product=single, isadmin=isadmin())
    elif pass_type == 'week':
        return render_template('displaydetails.html', product=week, isadmin=isadmin())
    else:
        return render_template('displaydetails.html', product=month, isadmin=isadmin())



@app.route('/changeprice', methods = ['POST'])
def changeprice():
    flag = """flag{cheaper_prices_in_NYC_PLZ}"""
    if 'Price' in request.form and request.form['Price'].strip():
        if request.form['Price'] in ['2.75', '$2.75', '2.75$']:
            return render_template('changeprice.html', isadmin=isadmin(), showflag=flag)
    else:
        return render_template('changeprice.html', isadmin=isadmin(), showflag='')



@app.route('/login', methods = ["POST"])
def loginPage():
    return render_template('login.html')

@app.route('/logout', methods = ["POST"])
def logout():
    message = "View Details"
    try:
        session['email'] = ''
        name = 'You have Successfully Logged Out'
    except Exception:
        ...
    return render_template('userHome.html', welcome = name, flag = False, message=message)