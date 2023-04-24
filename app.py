# from flask import Flask, render_template
# app = Flask(__name__,template_folder='FRONT_END/')

# @app.route('/')
# def index():
#     return render_template('index.html')

# @app.route('/products')
# def products():
#     return "this is blash!"

# if __name__ == "__main__":
#     app.run(debug = True, port = 8000)
from flask import Flask, render_template, request, session, redirect, url_for
import psycopg2


app = Flask(__name__,template_folder='FRONT_END/')
app.config['DEBUG'] = True
app.secret_key = "mysecretkey"

# Configure PostgreSQL database connection
conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="oarkyud"
)
cursor = conn.cursor()




def authenticate(username, password):
    # conn = psycopg2.connect(database="mydatabase", user="myuser", password="mypassword", host="localhost", port="5432")
    # cur = conn.cursor()
    cursor.execute("SELECT customerID, username, user_role FROM users WHERE username=%s AND u_password=%s", (username, password))
    row = cursor.fetchone()
    # cursor.close()
    # conn.close()
    if row is not None:
        session["user_id"] = row[0]
        session["username"] = row[1]
        session["role"] = row[2]
        return True
    else:
        return False

def authorize(role):
    if "role" in session and session["role"] == role:
        return True
    else:
        return False

@app.route('/')
def index():
    return render_template('index.html')

# Register endpoint
@app.route('/register', methods=['GET', 'POST'])
def register():
    cursor.execute("select * from broker_details; ")
    broker_list = cursor.fetchall()
    broker_names = [name for id,name in broker_list]
    # print(broker_names)
    # print(broker_list)
    broker_id_map = {key : value for value,key in broker_list }
    # print(broker_id_map)
    # options = ['Option 1', 'Option 2', 'Option 3']
    if request.method == 'POST':
        # Get form data
        
        name = request.form['full-name']
        dob = request.form['date-of-birth']
        email = request.form['email']
        broker_name = request.form['broker-name']
        broker_id = broker_id_map[broker_name]
        username = request.form['username']
        password = request.form['password']
        # Insert user information into database
        cursor.execute("INSERT INTO users (fullname, dob, email, username, u_password, brokerid) VALUES (%s, %s, %s, %s, %s, %s);", (name, dob, email, username, password, broker_id))
        conn.commit()
        return redirect(url_for('login'))
    else:
        return render_template('register.html',options=broker_names)

# Login endpoint
@app.route("/login")
def login():
    return render_template("login.html")

@app.route('/login', methods=['GET', 'POST'])
def do_login():
    username = request.form["login-username"]
    password = request.form["login-password"]
    if authenticate(username, password):
        return redirect(url_for("dashboard", page=1))
    else:
        return render_template("login.html", error="Invalid username or password")

def get_data_transacs(page):
    # Calculate the offset and limit values for pagination
    limit = 10
    offset = (page - 1) * limit
    
    # Write a SQL query to fetch the data with pagination
    sql_query = f"SELECT * FROM orderbook LIMIT {limit} OFFSET {offset}"

    # Execute the query using psycopg2
    # cursor = conn.cursor()
    cursor.execute(sql_query)
    data = cursor.fetchall()
    
    # Calculate the total number of pages
    cursor.execute("SELECT COUNT(*) FROM orderbook")
    count = cursor.fetchone()[0]
    total_pages = int(count / limit) + (count % limit > 0)
    
    # Return the data and pagination links
    return data, total_pages

def get_data_portfolio(page):
    # Calculate the offset and limit values for pagination
    limit = 10
    offset = (page - 1) * limit
    
    # Write a SQL query to fetch the data with pagination
    sql_query = f"SELECT * FROM portfolio LIMIT {limit} OFFSET {offset}"

    # Execute the query using psycopg2
    # cursor = conn.cursor()
    cursor.execute(sql_query)
    data = cursor.fetchall()
    
    # Calculate the total number of pages
    cursor.execute("SELECT COUNT(*) FROM portfolio")
    count = cursor.fetchone()[0]
    total_pages = int(count / limit) + (count % limit > 0)
    
    # Return the data and pagination links
    return data, total_pages

def get_data_exchange(page,exchangename):
    # Calculate the offset and limit values for pagination
    limit = 10
    offset = (page - 1) * limit
    
    # Write a SQL query to fetch the data with pagination
    sql_query = f"SELECT * FROM company LIMIT {limit} OFFSET {offset}"

    # Execute the query using psycopg2
    # cursor = conn.cursor()
    cursor.execute(sql_query)
    data = cursor.fetchall()
    
    # Calculate the total number of pages
    cursor.execute("SELECT COUNT(*) FROM portfolio")
    count = cursor.fetchone()[0]
    total_pages = int(count / limit) + (count % limit > 0)
    
    # Return the data and pagination links
    return data, total_pages


@app.route("/dashboard/<int:page>")
def dashboard(page):
    if "user_id" in session and authorize("user"):
        user_id = session["user_id"]

        cursor.execute("SELECT username, email FROM users WHERE customerID=%s", (user_id,))
        row = cursor.fetchone()

        data, total_pages = get_data_portfolio(page)

        if row is not None:
            return render_template('dashboard.html', data=data, total_pages=total_pages, current_page=page)
            
    else:
        return redirect(url_for("login"))
    
@app.route("/nasdaq/<int:page>")
def nasdaq(page):
    if "user_id" in session and authorize("user"):
        user_id = session["user_id"]

        cursor.execute("SELECT username, email FROM users WHERE customerID=%s", (user_id,))
        row = cursor.fetchone()

        data, total_pages = get_data_portfolio(page)

        if row is not None:
            return render_template('nasdaq.html', data=data, total_pages=total_pages, current_page=page)
            
    else:
        return redirect(url_for("login")) 
    
@app.route("/account", methods=['GET', 'POST'])
def account():
    if "user_id" in session and authorize("user"):
        user_id = session["user_id"]
        cursor.execute("SELECT *, date_part('year',AGE(CURRENT_DATE, dob)) as age FROM users JOIN broker_details ON broker_details.brokerid = users.brokerid AND customerID=%s", (user_id,))
        row = cursor.fetchone()
        print(row)
        if row is not None:
                
                if request.method == 'POST':
                # Get form data
                    
                    add_balance = request.form['wallet-balance']                    
                    cursor.execute("UPDATE users SET wallet = wallet + %s WHERE customerID = %s;", (add_balance,user_id))
                    conn.commit()
                    return redirect(url_for('account'))
                else:                    
                    return render_template('account.html', data=row)
            
    else:
        return redirect(url_for("login"))
    
@app.route("/transactions/<int:page>")
def transacs(page):
    if "user_id" in session and authorize("user"):
        user_id = session["user_id"]

        cursor.execute("SELECT username, email FROM users WHERE customerID=%s", (user_id,))
        row = cursor.fetchone()

        data, total_pages = get_data_transacs(page)

        if row is not None:
            return render_template('transacs.html', data=data, total_pages=total_pages, current_page=page)
            
    else:
        return redirect(url_for("login"))

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for('login'))



if __name__ == '__main__':
    app.run()
