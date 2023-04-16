from flask import Flask, render_template
app = Flask(__name__,template_folder='FRONT_END/')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/products')
def products():
    return "this is blash!"

if __name__ == "__main__":
    app.run(debug = True, port = 8000)
