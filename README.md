# SmartTasks

SmartTasks is a task and project management application designed to help users efficiently manage their tasks and projects. This application features a Flutter frontend and a Python/Django backend, adhering to OOP best practices and SOLID principles.

## Features

- User authentication and authorization
- Create, read, update, and delete tasks and projects
- Assign tasks to users
- Set due dates and priorities for tasks
- Responsive design for mobile and web platforms

## Architecture

The application follows a clean architecture pattern, separating concerns between the frontend and backend. The backend is built using Django, providing a RESTful API for the Flutter frontend to interact with.

## Setup Instructions

### Backend

1. Navigate to the `backend` directory.
2. Create a virtual environment:
   ```
   python -m venv venv
   ```
3. Activate the virtual environment:
   - On Windows:
     ```
     venv\Scripts\activate
     ```
   - On macOS/Linux:
     ```
     source venv/bin/activate
     ```
4. Install the required packages:
   ```
   pip install -r requirements.txt
   ```
5. Run the Django server:
   ```
   python manage.py runserver
   ```

### Frontend

1. Navigate to the `frontend/flutter` directory.
2. Get the Flutter dependencies:
   ```
   flutter pub get
   ```
3. Run the Flutter application:
   ```
   flutter run
   ```

## API Documentation

For detailed information about the API endpoints, request and response formats, please refer to the [API Documentation](docs/api.md).

## Authentication

For information on the authentication process and JWT usage, please refer to the [Authentication Documentation](docs/auth.md).

## Contributing

If you would like to contribute to the project, please read the [Contributing Guidelines](docs/contributing.md) for more information.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.