import hashlib
import boto3
import os
from botocore.exceptions import ClientError
from flask import Flask, request, jsonify, render_template_string, redirect, url_for

app = Flask(__name__)

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name=os.environ.get('AWS_REGION', 'us-east-1'))
table_name = os.environ.get('DYNAMODB_TABLE', 'MessageHashStore')
table = dynamodb.Table(table_name)

# HTML template for the web interface
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Hash Service</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .container {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }
        h1 {
            color: #333;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button[type="submit"] {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        /* Submit button styling for Store Message form */
        #Store button[type="submit"] {
            background-color: #4CAF50;
            color: white;
        }
        #Store button[type="submit"]:hover {
            background-color: #45a049;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        /* Submit button styling for Retrieve Message form */
        #Retrieve button[type="submit"] {
            background-color: #2196F3;
            color: white;
        }
        #Retrieve button[type="submit"]:hover {
            background-color: #0b7dda;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        /* Results styling */
        .result {
            margin-top: 20px;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        /* Result styling for Store Message */
        #Store .result:not(.error) {
            background-color: #e8f5e9;
            border-left: 6px solid #4CAF50;
        }
        /* Result styling for Retrieve Message */
        #Retrieve .result:not(.error) {
            background-color: #e3f2fd;
            border-left: 6px solid #2196F3;
        }
        /* Error styling */
        .error {
            background-color: #ffebee;
            border-left: 6px solid #f44336;
        }
        .tab {
            overflow: hidden;
            border: 1px solid #ddd;
            background-color: #f9f9f9;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .tab button {
            float: left;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 12px 20px;
            transition: 0.3s;
            font-size: 16px;
            font-weight: bold;
        }
        /* Store Message tab styling */
        .tab button:nth-child(1) {
            background-color: #4CAF50;
            color: white;
        }
        .tab button:nth-child(1):hover {
            background-color: #45a049;
        }
        .tab button:nth-child(1).active {
            background-color: #2E8B57;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2) inset;
        }
        /* Retrieve Message tab styling */
        .tab button:nth-child(2) {
            background-color: #2196F3;
            color: white;
        }
        .tab button:nth-child(2):hover {
            background-color: #0b7dda;
        }
        .tab button:nth-child(2).active {
            background-color: #0056b3;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2) inset;
        }
        .tabcontent {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-top: none;
        }
        .active-tab {
            display: block;
        }
    </style>
</head>
<body>
    <h1>Message Hash Service</h1>
    
    <div class="tab">
        <button class="tablinks" onclick="openTab(event, 'Store')" id="defaultOpen">Store Message</button>
        <button class="tablinks" onclick="openTab(event, 'Retrieve')">Retrieve Message</button>
    </div>
    
    <div id="Store" class="tabcontent">
        <div class="container">
            <h2>Store a Message</h2>
            <form action="/ui/store" method="POST">
                <label for="message">Message:</label>
                <input type="text" id="message" name="message" required>
                <button type="submit">Generate Hash</button>
            </form>
            
            {% if store_result %}
            <div class="result">
                <h3>Result:</h3>
                <p><strong>Hash:</strong> {{ store_result.hash }}</p>
            </div>
            {% endif %}
            
            {% if store_error %}
            <div class="result error">
                <h3>Error:</h3>
                <p>{{ store_error }}</p>
            </div>
            {% endif %}
        </div>
    </div>
    
    <div id="Retrieve" class="tabcontent">
        <div class="container">
            <h2>Retrieve a Message</h2>
            <form action="/ui/retrieve" method="POST">
                <label for="hash">Hash:</label>
                <input type="text" id="hash" name="hash" required>
                <button type="submit">Retrieve Message</button>
            </form>
            
            {% if retrieve_result %}
            <div class="result">
                <h3>Result:</h3>
                <p><strong>Message:</strong> {{ retrieve_result.message }}</p>
            </div>
            {% endif %}
            
            {% if retrieve_error %}
            <div class="result error">
                <h3>Error:</h3>
                <p>{{ retrieve_error }}</p>
            </div>
            {% endif %}
        </div>
    </div>
    
    <script>
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }
        
        // Set the active tab based on server response or default to Store
        var activeTab = "{{ active_tab or 'Store' }}";
        document.getElementById(activeTab).style.display = "block";
        
        // Activate the corresponding tab button
        var tablinks = document.getElementsByClassName("tablinks");
        for (var i = 0; i < tablinks.length; i++) {
            if (tablinks[i].textContent.trim() === activeTab) {
                tablinks[i].className += " active";
            }
        }
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    """
    Render the web interface for interacting with the API.
    """
    return render_template_string(HTML_TEMPLATE, active_tab="Store")

@app.route('/ui/store', methods=['POST'])
def ui_store_message():
    """
    UI endpoint for storing a message.
    """
    message = request.form.get('message')
    
    if not message:
        return render_template_string(
            HTML_TEMPLATE, 
            store_error="No message provided",
            active_tab="Store"
        )
    
    # Calculate SHA256 hash
    message_hash = hashlib.sha256(message.encode('utf-8')).hexdigest()
    
    # Store message in DynamoDB
    try:
        table.put_item(
            Item={
                'hash': message_hash,
                'message': message
            }
        )
        return render_template_string(
            HTML_TEMPLATE, 
            store_result={"hash": message_hash},
            active_tab="Store"
        )
    except ClientError as e:
        return render_template_string(
            HTML_TEMPLATE, 
            store_error=f"Database error: {str(e)}",
            active_tab="Store"
        )

@app.route('/ui/retrieve', methods=['POST'])
def ui_retrieve_message():
    """
    UI endpoint for retrieving a message.
    """
    hash_value = request.form.get('hash')
    
    if not hash_value:
        return render_template_string(
            HTML_TEMPLATE, 
            retrieve_error="No hash provided",
            active_tab="Retrieve"
        )
    
    try:
        response = table.get_item(
            Key={
                'hash': hash_value
            }
        )
    except ClientError as e:
        return render_template_string(
            HTML_TEMPLATE, 
            retrieve_error=f"Database error: {str(e)}",
            active_tab="Retrieve"
        )
    
    # Check if the item was found
    if 'Item' not in response:
        return render_template_string(
            HTML_TEMPLATE, 
            retrieve_error="Message not found",
            active_tab="Retrieve"
        )
    
    return render_template_string(
        HTML_TEMPLATE,
        retrieve_result={"message": response['Item']['message']},
        active_tab="Retrieve"
    )

# Original API endpoints

@app.route('/messages', methods=['POST'])
def store_message():
    """
    Store a message and return its SHA256 hash.
    
    Request body: 
        JSON with 'message' field
    Response:
        JSON with 'hash' field
    """
    data = request.get_json()
    
    if not data or 'message' not in data:
        return jsonify({"error": "No message provided"}), 400
    
    message = data['message']
    
    # Calculate SHA256 hash
    message_hash = hashlib.sha256(message.encode('utf-8')).hexdigest()
    
    # Store message in DynamoDB
    try:
        table.put_item(
            Item={
                'hash': message_hash,
                'message': message
            }
        )
    except ClientError as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500
    
    return jsonify({"hash": message_hash}), 201

@app.route('/messages/<hash_value>', methods=['GET'])
def retrieve_message(hash_value):
    """
    Retrieve a message by its SHA256 hash.
    
    Path parameter: 
        hash_value - SHA256 hash of the message
    Response:
        JSON with 'message' field if found
        404 if not found
    """
    try:
        response = table.get_item(
            Key={
                'hash': hash_value
            }
        )
    except ClientError as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500
    
    # Check if the item was found
    if 'Item' not in response:
        return jsonify({"error": "Message not found"}), 404
    
    return jsonify({"message": response['Item']['message']}), 200

@app.route('/health', methods=['GET'])
def health_check():
    """
    Simple health check endpoint.
    """
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)