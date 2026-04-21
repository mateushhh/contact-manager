# Contact Manager
Full-stack project consists of two main parts: a server application (backend) and a client application (frontend).
Project developed in .NET Core with REST API and React (Vite)

## Project Structure
- `./src/` - .NET Core project with all the source files
- `./database/` - Database structure diagram, schemas, select queries

## Backend
**Framework:** `.NET 8` (ASP.NET Core Web API).
**Database:** `Microsoft SQL Server` (LocalDB).
**Object-Relational Mapping:** `Entity Framework Core` (database handling via C# code).
**Libraries:**
- `Microsoft.EntityFrameworkCore.SqlServer` - driver for the SQL Server database.
- `Microsoft.EntityFrameworkCore.Tools` - tools for database migrations.
- `Microsoft.AspNetCore.Authentication.JwtBearer` - support for JWT token authorization.
- `Microsoft.AspNetCore.Identity` - password hasher.

## Frontend
**Framework:** `React` (Vite).
**Libraries:**
- `axios` - handling HTTP requests to the API server.

## Classes and Methods
**Data**
- **AppDbContext:** The main class managing communication with the database.
**API Controllers**
- **ContactsController:**
  - `GetContacts()`: Retrieves a list of all contacts.
  - `GetContact(id)`: Retrieves detailed data of a specific contact.
  - `CreateContact()`: Adds a new contact. Hashes the password before saving. Requires login.
  - `UpdateContact(id)`: Edits an existing entry. Requires login.
  - `DeleteContact(id)`: Removes a contact from the database. Requires login.
- **AuthController:**
  - `Register()`: Create an administrator account.
  - `Login()`: Verifies credentials and returns a JWT token, which grants admin access to protected functions.
- **CategoriesController:**
  - `GetCategories()`: Retrieves a list of categories and subcategories from the database dictionaries.
**Models**
- **Contact:** Contains fields required for each contact.
- **User:** Represents a user account capable of managing the database.

## How to run the project
**Database and Backend Startup:**
1. Open the solution file (.sln) in Visual Studio.
2. Open the **Package Manager Console**.
3. Type the command `Update-Database` to create the SQL LocalDB database and tables.
4. Run the project using the **Start button**. The API server will start at localhost.

**Frontend Startup:**
1. Open the terminal in the frontend folder.
2. Type `npm install` to download the libraries.
3. Type `npm run dev` to start the application.
4. The browser should open by itself, if not then open `http://localhost:5173`.

## SQL Queries and ERD Diagram
This part of the project is not related to the previous part of the project. The database here is a completely seperate thing.
- `./database/0_erd.pdf` - Database structure diagram (entity–relationship model)
- `./database/1_schema.sql` - Creates database structure and inserts data to the database
- `./database/2_select.sql` - Example select queries for the database
- `./database/readme.md` - Family tree hierarchy in the database showcased with a mermaid graph 

SQL Queries were tested on [db-fiddle.com](https://www.db-fiddle.com/f/mRQHJcPWqVfvRA3VKnasvD/15) website with MySQL v9 database, by clicking the link you should be transferred to a premade example with this project schema and select queries.
