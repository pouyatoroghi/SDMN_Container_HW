from flask import Flask, request, jsonify, Response

# Create an instance of the Flask class
app = Flask(__name__)

# Initialize the current status to "OK"
current_status = {"status": "OK"}

# Define the route for the /api/v1/status endpoint that supports both GET and POST methods
@app.route('/api/v1/status', methods=['GET', 'POST'])
def status():
    global current_status
    # Handle GET requests
    if request.method == 'GET':
        # Return the current status with a 200 OK status code
        return jsonify(current_status), 200
    # Handle POST requests
    elif request.method == 'POST':
        # Update the current status with the JSON body of the request
        current_status = request.json
        # Return the updated status with a 201 Created status code
        return jsonify(current_status), 201

# Before each request, ensure the current status is maintained correctly for GET requests
@app.before_request
def before_request():
    global current_status
    # Check if the request method is GET
    if request.method == 'GET':
        # Ensure that if the current status is "not OK", it remains "not OK"
        if current_status.get('status') == 'not OK':
            current_status = {"status": "not OK"}

# After each request, ensure POST responses have a 201 status code
@app.after_request
def after_request(response):
    # Check if the response status code is 200 and the request method was POST
    if response.status_code == 200 and request.method == 'POST':
        # Modify the response to have a 201 Created status code
        return Response(response.data, status=201, mimetype='application/json')
    # Return the response unmodified for other cases
    return response

# Run the Flask application if this script is executed directly
if __name__ == '__main__':
    # Make the server publicly available and listen on port 8000
    app.run(host='0.0.0.0', port=8000)


