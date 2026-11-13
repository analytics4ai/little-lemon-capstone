# Little Lemon: Relational Database Management, Booking System, and Sales Analytics

## Project Overview
This repository contains the Database Engineering Capstone Project for **Little Lemon**, implementing a normalized 3NF relational database in MySQL, automated table booking procedures via Python, and sales analytics visualizations in Tableau based on the provided `LittleLemon_data.xlsx` dataset.

## Repository Contents
- `README.md`: Project architecture, setup instructions, and documentation.
- `LittleLemonDB.sql`: Complete MySQL schema creation script, seed data, and all five required stored procedures (`GetMaxQuantity`, `ManageBooking`, `AddBooking`, `UpdateBooking`, `CancelBooking`).
- `little_lemon_client.py`: Python client application connecting to MySQL via `mysql-connector-python` to execute booking procedures and query sales data.
- `er_diagram.html`: Visual Entity-Relationship (ER) diagram illustrating table relationships and keys (open in any browser or screenshot as PNG for review).
- `LittleLemon_data.xlsx`: Source dataset used to design the database schema, populate initial records, and build Tableau dashboards.

## Stored Procedures Implemented
1. **`GetMaxQuantity()`**: Retrieves the maximum order quantity from the `Orders` table.
2. **`ManageBooking(booking_date, table_no)`**: Checks if a table is already reserved on a specific date.
3. **`AddBooking(booking_id, customer_id, booking_date, table_no)`**: Adds a new customer reservation.
4. **`UpdateBooking(booking_id, booking_date)`**: Modifies the date of an existing booking.
5. **`CancelBooking(booking_id)`**: Deletes a booking record from the database.

## Setup & Execution
1. Run `LittleLemonDB.sql` in MySQL Workbench or the MySQL CLI to create the database and procedures.
2. Install the Python connector: `pip install mysql-connector-python`
3. Update your local MySQL password in `little_lemon_client.py` and run `python little_lemon_client.py`.