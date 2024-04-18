import mysql.connector

#test import
import unittest
from unittest.mock import patch
from io import StringIO

def connect_to_database():
    username = input("Enter MySQL username: ")
    password = input("Enter MySQL password: ")
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='musicxuc',
            user=username,
            password=password
        )
        print("Connected to the database successfully.")
        return connection
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

def get_genres_from_db(cursor):
    query = "SELECT genre_name FROM genres"
    cursor.execute(query)
    return [row[0].lower() for row in cursor.fetchall()]

def prompt_user_for_genre(genres_list):
    print("\nAvailable genres:")
    for genre in genres_list:
        print(genre.capitalize())
    genre = input("\nPlease enter a genre name from the list above: ").lower()
    return genre

def execute_procedure(connection, genre):
    cursor = connection.cursor()
    try:
        cursor.callproc('song_has_genre', [genre])
        for result in cursor.stored_results():
            print("\nSongs within the selected genre:")
            for row in result.fetchall():
                print(row)
    except mysql.connector.Error as err:
        print(f"Error: {err}")



class TestDatabaseFunctions(unittest.TestCase):
    @classmethod
    @patch('builtins.input', side_effect=['root', 'Xx223322'])
    def setUpClass(cls, mock_input):
        cls.connection = connect_to_database()
        cls.cursor = cls.connection.cursor()
        
    @classmethod
    def tearDownClass(cls):
        cls.cursor.close()
        cls.connection.close()

    
    def test_connect_to_database(self):
        
        self.assertIsNotNone(self.connection, "database connection should not be None.")

    def test_get_genres_from_db(self):
        genres = get_genres_from_db(self.cursor)
        self.assertGreater(len(genres), 0, "At least one genre should be retrieved.")

    @patch('builtins.input', side_effect=['Rock'])
    def test_prompt_user_for_genre(self, mock_input):
        with patch('sys.stdout', new_callable = StringIO) as mock_stdout:
            user_genre = prompt_user_for_genre(['rock', 'pop'])
            self.assertEqual(user_genre, 'rock', "Prompted user genre should be 'rock'.")
            output = mock_stdout.getvalue().strip()
            self.assertIn("Rock", output, "Prompt should display available genres.")
            
    @patch('sys.stdout', new_callable=StringIO)
    def test_execute_procedure(self, mock_stdout):
        execute_procedure(self.connection, 'rock')
        output = mock_stdout.getvalue().strip()
        self.assertIn("Songs within the selected genre:", output, "Procedure execution should display songs.")
 
    
        

    










def main():
    #username = input("Enter MySQL username: ")
    #password = input("Enter MySQL password: ")

    connection = connect_to_database()
    if connection:
        try:
            cursor = connection.cursor()
            genres_list = get_genres_from_db(cursor)
            while True:
                user_genre = prompt_user_for_genre(genres_list)
                if user_genre in genres_list:
                    execute_procedure(connection, user_genre)
                    break
                else:
                    print("Invalid genre, please retry.")

        finally:
            connection.close()
            print("Disconnected from the database, program ended.")
    else:
        print("Failed.")

if __name__ == "__main__":
    #main()
    unittest.main()
            


                

    
    
    
        
    
        
