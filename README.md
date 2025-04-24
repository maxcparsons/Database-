# Uptown Rentals SQL Database Project

## Overview
This project is part of the BUS 440 Database Management course at NC State University. It presents a fully normalized relational database design and implementation for a fictional startup, **Uptown Rentals**, which rents musical instruments to individual customers.

The goal was to develop a scalable, structured, and query-ready SQL database system from a raw data format (e.g., spreadsheets) into a fully functional schema hosted in MySQL.

## Business Use Case
Uptown Rentals tracks a variety of business operations:
- Rentals of instruments categorized by type (e.g., Strings, Woodwinds) and tier (Basic, Premium)
- Customer registration and contact info
- Employee roles and rental oversight
- Instrument condition tracking and maintenance records
- Overdue rental fee calculation and enforcement

The system ensures data integrity, supports detailed reporting, and provides actionable insights into rental trends, customer behavior, staff performance, and inventory health.

## Database Features
- **Fully normalized schema** to 3NF
- **Entity-Relationship model (EER)** built and synchronized in MySQL Workbench
- Populated with realistic sample data
- Includes foreign key constraints and appropriate indexing

## SQL Queries Included
The SQL script (`uptownRentalsmaxparsons.sql`) contains multiple queries with descriptive comments, including:
- Total rentals and overdue tracking
- Top spending and most frequent customers
- Instrument status reports (damaged/maintained)
- Staff performance metrics
- Subquery and aggregated insights

## Technologies Used
- MySQL Workbench
- MySQL Server
- SQL (DML, DDL, subqueries, aggregation, joins)

## Getting Started
To run this project:
1. Open MySQL Workbench and import the `uptownRentalsmaxparsons.sql` script.
2. Execute the script to create and populate the database.
3. Run queries to explore insights from the data.

## Author
**Maxwell Parsons**  
Business Analytics & Data Science  
NC State University  
Class of Fall 2025

