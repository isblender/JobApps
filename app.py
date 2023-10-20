from flask import Flask, request, jsonify, g
import mysql.connector
import configparser

app = Flask(__name__)

c = configparser.ConfigParser()
c.read('config.ini')

db_config = {
    'host': c['info']['host'],
    'user': c['info']['user'],
    'password': c['info']['password'],
    'database': c['info']['db'],
}

def get_db():
    if 'db' not in g:
        g.db = mysql.connector.connect(**db_config)
    return g.db

@app.teardown_appcontext
def close_db(e=None):
    db = g.pop('db', None)
    if db is not None:
        db.close()
        
@app.route('/job_applications', methods=['GET'])
def get_job_applications():
    cursor = get_db().cursor(dictionary=True)
    cursor.execute("SELECT * FROM apps")  # Updated table name to 'apps'
    data = cursor.fetchall()
    cursor.close()
    return jsonify(data)

@app.route('/add_company', methods=['POST'])
def add_company():
    data = request.get_json()
    if 'companyName' in data and 'jobTitle' in data:
        company_name = data['companyName']
        job_title = data['jobTitle']
        try:
            cursor = get_db().cursor()
            cursor.execute("INSERT INTO apps (cName, pName) VALUES (%s, %s)", (company_name, job_title))
            get_db().commit()
            cursor.close()
            return jsonify({'message': 'Company added successfully'})
        except mysql.connector.Error as err:
            return jsonify({'error': f"Error adding company: {err}"})
    else:
        return jsonify({'error': 'Invalid data format'})

if __name__ == '__main__':
    app.run()

@app.teardown_appcontext
def close_db(exception):
    connection.close()
