import mysql.connector as connector

def get_connection():
    """Establish connection to the LittleLemonDB MySQL database."""
    return connector.connect(
        user="root",
        password="your_password",  # Replace with your local MySQL password
        host="127.0.0.1",
        database="LittleLemonDB"
    )

def main():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        print("Connected to LittleLemonDB successfully.\n")

        # 1. Show all tables in the database
        cursor.execute("SHOW TABLES;")
        print("Tables in LittleLemonDB:")
        for table in cursor.fetchall():
            print(f" - {table[0]}")

        # 2. Query customers with orders exceeding $60
        query_high_value = """
        SELECT c.CustomerName, c.City, c.Country, o.OrderID, o.Sales
        FROM Customers c
        INNER JOIN Orders o ON c.CustomerID = o.CustomerID
        WHERE o.Sales > 60;
        """
        cursor.execute(query_high_value)
        print("\nCustomers with Sales > $60:")
        for row in cursor.fetchall():
            print(row)

        # 3. Call Stored Procedures
        print("\n--- Testing Stored Procedures ---")
        
        cursor.callproc("GetMaxQuantity")
        for result in cursor.stored_results():
            print("GetMaxQuantity:", result.fetchall())

        cursor.callproc("ManageBooking", ("2022-10-10", 5))
        for result in cursor.stored_results():
            print("ManageBooking:", result.fetchall())

        cursor.callproc("AddBooking", (4, "72-055-7985", "2022-12-15", 6))
        conn.commit()
        for result in cursor.stored_results():
            print("AddBooking:", result.fetchall())

        cursor.callproc("UpdateBooking", (4, "2022-12-20"))
        conn.commit()
        for result in cursor.stored_results():
            print("UpdateBooking:", result.fetchall())

        cursor.callproc("CancelBooking", (4,))
        conn.commit()
        for result in cursor.stored_results():
            print("CancelBooking:", result.fetchall())

    except connector.Error as err:
        print(f"Database Error: {err}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("\nMySQL connection closed.")

if __name__ == "__main__":
    main()