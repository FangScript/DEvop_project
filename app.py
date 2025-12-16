"""
Simple Flask Application for CI/CD Pipeline Demo
"""
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    """Home endpoint"""
    return jsonify({
        'message': 'Welcome to DevOps CI/CD Pipeline Demo',
        'status': 'success',
        'version': '1.0.0'
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'service': 'devops-demo-app'
    })

@app.route('/api/info')
def info():
    """Application info endpoint"""
    return jsonify({
        'app_name': 'DevOps CI/CD Demo Application',
        'version': '1.0.0',
        'environment': os.getenv('ENVIRONMENT', 'development'),
        'host': os.getenv('HOST', 'localhost')
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)

