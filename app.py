# app.py
from flask import Flask, render_template_string

app = Flask(__name__)

@app.route('/')
def home():
    # Returning a simple HTML string directly
    return render_template_string('''
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>My Portfolio</title>
            <style>
                body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
                h1 { color: #919191; }
                p { color: #666; }
            </style>
        </head>
        <body>
            <h1>Hello from my Flask App!</h1>
            <p>This is your local development environment.</p>
        </body>
        </html>
    ''')

if __name__ == '__main__':
    # When running locally with 'python app.py'
    # debug=True provides helpful error messages in the browser
    # and automatically reloads the server on code changes.
    app.run(debug=True, port=5001)