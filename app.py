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
from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__,template_folder='FRONT_END/')
app.config['DEBUG'] = True

# Configure PostgreSQL database connection
conn = psycopg2.connect(
    host="localhost",
    database="test",
    user="postgres",
    password="oarkyud"
)
cursor = conn.cursor()

# Create table for user information if it doesn't exist
cursor.execute('''CREATE TABLE IF NOT EXISTS users
                  (id SERIAL PRIMARY KEY, 
                  name TEXT NOT NULL, 
                  dob DATE NOT NULL,
                  email TEXT NOT NULL, 
                  username TEXT NOT NULL UNIQUE, 
                  password TEXT NOT NULL);''')
conn.commit()

@app.route('/')
def index():
    return render_template('index.html')

# Register endpoint
@app.route('/register', methods=['GET', 'POST'])
def register():
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
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Get form data
        username = request.form['login-username']
        password = request.form['login-password']
        # Check if user exists in database
        cursor.execute("SELECT * FROM users WHERE username=%s AND password=%s;", (username, password))
        user = cursor.fetchone()
        if user:
            return redirect(url_for('dashboard'))
        else:
            return render_template('login.html', error="Invalid username or password")
    else:
        return render_template('login.html')

# Dashboard endpoint
@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html')

if __name__ == '__main__':
    app.run()
