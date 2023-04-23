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

# Create table for user information if it doesn't exist
# cursor.execute('''CREATE TABLE IF NOT EXISTS users
#                   (id SERIAL PRIMARY KEY,
#                   name TEXT NOT NULL, 
#                   dob DATE NOT NULL,
#                   email TEXT NOT NULL, 
#                   username TEXT NOT NULL UNIQUE, 
#                   password TEXT NOT NULL,
#                   role VARCHAR(255) NOT NULL DEFAULT 'user');''')
# conn.commit()



def authenticate(username, password):
    # conn = psycopg2.connect(database="mydatabase", user="myuser", password="mypassword", host="localhost", port="5432")
    # cur = conn.cursor()
    cursor.execute("SELECT id, username, role FROM users WHERE username=%s AND password=%s", (username, password))
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
    # options = ['Option 1', 'Option 2', 'Option 3']
    if request.method == 'POST':
        # Get form data
        
        name = request.form['full-name']
        dob = request.form['date-of-birth']
        email = request.form['email']
        username = request.form['username']
        password = request.form['password']
        # Insert user information into database
        cursor.execute("INSERT INTO users (name, dob, email, username, password) VALUES (%s, %s, %s, %s, %s);", (name, dob, email, username, password))
        conn.commit()
        return redirect(url_for('login'))
    else:
        return render_template('register.html')

# Login endpoint
@app.route("/login")
def login():
    return render_template("login.html")

@app.route('/login', methods=['GET', 'POST'])
def do_login():
    username = request.form["login-username"]
    password = request.form["login-password"]
    if authenticate(username, password):
        return redirect(url_for("dashboard"))
    else:
        return render_template("login.html", error="Invalid username or password")




@app.route("/dashboard")
def dashboard():
    if "user_id" in session and authorize("user"):
        user_id = session["user_id"]
        # conn = psycopg2.connect(database="mydatabase", user="myuser", password="mypassword", host="localhost", port="5432")
        # cur = conn.cursor()
        cursor.execute("SELECT username, email FROM users WHERE id=%s", (user_id,))
        row = cursor.fetchone()
        # cursor.close()
        # conn.close()
        if row is not None:
            return render_template("dashboard.html", username=row[0], email=row[1])
    else:
        return redirect(url_for("login"))

@app.route("/logout")
# def logout():
#     session.pop("user_id", None)
#     session.pop("username", None)
#     session.pop("role", None)
#     return redirect(url_for("home"))

def logout():
    session.clear()
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run()
