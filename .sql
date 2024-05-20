import sqlite3
 
# Function to establish connection to SQLite database
def create_connection(db_file):
	conn = None
	try:
    	conn = sqlite3.connect(db_file)
    	return conn
	except sqlite3.Error as e:
    	print(e)
	return conn
 
# Function to create a new user table in the database
def create_user_table(conn):
	try:
    	cursor = conn.cursor()
    	cursor.execute("""
        	CREATE TABLE IF NOT EXISTS users (
            	id INTEGER PRIMARY KEY,
                username TEXT NOT NULL,
            	password TEXT NOT NULL
        	)
    	""")
    	conn.commit()
	except sqlite3.Error as e:
    	print(e)
 
# Function to fetch user data by username (secure against SQL injection)
def fetch_user_data(conn, username):
	try:
    	cursor = conn.cursor()
    	query = "SELECT * FROM users WHERE username = ?"
    	cursor.execute(query, (username,))
    	return cursor.fetchall()
	except sqlite3.Error as e:
    	print(e)
    	return []
 
# Function to insert new user data (secure against SQL injection)
def insert_user_data(conn, username, password):
	try:
    	cursor = conn.cursor()
    	query = "INSERT INTO users (username, password) VALUES (?, ?)"
    	cursor.execute(query, (username, password))
    	conn.commit()
    	print(f"User '{username}' successfully inserted.")
	except sqlite3.Error as e:
    	print(e)
 
# Main function to demonstrate database operations
def main():
	database_file = "example.db"
 
	# Create a connection to the SQLite database
	conn = create_connection(database_file)
	if conn is None:
    	print("Error: Unable to connect to database.")
    	return
 
	# Create the 'users' table if it doesn't exist
	create_user_table(conn)
 
	# Example: Inserting a new user (secure)
	insert_user_data(conn, "alice", "securepassword")
 
	# Example: Fetching user data (secure)
	username_to_fetch = "alice"
	user_data = fetch_user_data(conn, username_to_fetch)
	if user_data:
    	print("User data found:", user_data)
	else:
    	print(f"No user found with username '{username_to_fetch}'.")
 
	# Close the database connection
	conn.close()
 
# Execute the main function
if __name__ == "__main__":
	main()
