# SmartTasks API Documentation

## Overview
The SmartTasks API provides a RESTful interface for managing tasks and projects. It allows users to create, read, update, and delete tasks and projects, as well as manage user authentication.

## Base URL
The base URL for all API endpoints is:
```
http://<your-domain>/api/
```

## Authentication
All endpoints require authentication via JSON Web Tokens (JWT). Users must log in to receive a token, which should be included in the `Authorization` header for subsequent requests.

### Login
- **Endpoint:** `/auth/login/`
- **Method:** POST
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "yourpassword"
  }
  ```
- **Response:**
  ```json
  {
    "token": "your_jwt_token"
  }
  ```

## User Endpoints

### Create User
- **Endpoint:** `/users/`
- **Method:** POST
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
    "password": "yourpassword",
    "full_name": "John Doe"
  }
  ```
- **Response:**
  ```json
  {
    "id": 1,
    "email": "user@example.com",
    "full_name": "John Doe"
  }
  ```

### Get User Details
- **Endpoint:** `/users/{id}/`
- **Method:** GET
- **Response:**
  ```json
  {
    "id": 1,
    "email": "user@example.com",
    "full_name": "John Doe"
  }
  ```

## Project Endpoints

### Create Project
- **Endpoint:** `/projects/`
- **Method:** POST
- **Request Body:**
  ```json
  {
    "title": "New Project",
    "description": "Project description",
    "owner": 1
  }
  ```
- **Response:**
  ```json
  {
    "id": 1,
    "title": "New Project",
    "description": "Project description",
    "owner": 1
  }
  ```

### Get Project List
- **Endpoint:** `/projects/`
- **Method:** GET
- **Response:**
  ```json
  [
    {
      "id": 1,
      "title": "New Project",
      "description": "Project description",
      "owner": 1
    }
  ]
  ```

## Task Endpoints

### Create Task
- **Endpoint:** `/tasks/`
- **Method:** POST
- **Request Body:**
  ```json
  {
    "title": "New Task",
    "description": "Task description",
    "project": 1,
    "assignee": 1,
    "due_date": "2023-12-31"
  }
  ```
- **Response:**
  ```json
  {
    "id": 1,
    "title": "New Task",
    "description": "Task description",
    "project": 1,
    "assignee": 1,
    "due_date": "2023-12-31"
  }
  ```

### Get Task List
- **Endpoint:** `/tasks/`
- **Method:** GET
- **Response:**
  ```json
  [
    {
      "id": 1,
      "title": "New Task",
      "description": "Task description",
      "project": 1,
      "assignee": 1,
      "due_date": "2023-12-31"
    }
  ]
  ```

## Error Handling
All error responses will include a status code and a message. For example:
```json
{
  "error": "Invalid credentials"
}
```

## Conclusion
This API documentation provides a comprehensive overview of the SmartTasks API endpoints, authentication, and request/response formats. For further details, please refer to the other documentation files in the `docs` directory.