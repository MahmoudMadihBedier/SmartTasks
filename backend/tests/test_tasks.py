import pytest
from rest_framework import status
from rest_framework.test import APIClient
from apps.tasks.models import Task
from apps.users.models import User

@pytest.mark.django_db
class TestTaskAPI:
    def setup_method(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            email='testuser@example.com',
            password='testpassword',
            full_name='Test User'
        )
        self.client.force_authenticate(user=self.user)

    def test_create_task(self):
        response = self.client.post('/api/tasks/', {
            'title': 'Test Task',
            'description': 'This is a test task.',
            'status': 'pending',
            'priority': 'high',
            'assignee': self.user.id,
            'due_date': '2023-12-31'
        })
        assert response.status_code == status.HTTP_201_CREATED
        assert Task.objects.count() == 1
        assert Task.objects.get().title == 'Test Task'

    def test_get_task_list(self):
        Task.objects.create(
            title='Test Task 1',
            description='This is test task 1.',
            status='pending',
            priority='high',
            assignee=self.user,
            due_date='2023-12-31',
            created_by=self.user
        )
        response = self.client.get('/api/tasks/')
        assert response.status_code == status.HTTP_200_OK
        assert len(response.data) == 1

    def test_update_task(self):
        task = Task.objects.create(
            title='Test Task',
            description='This is a test task.',
            status='pending',
            priority='high',
            assignee=self.user,
            due_date='2023-12-31',
            created_by=self.user
        )
        response = self.client.patch(f'/api/tasks/{task.id}/', {
            'title': 'Updated Task Title'
        })
        assert response.status_code == status.HTTP_200_OK
        task.refresh_from_db()
        assert task.title == 'Updated Task Title'

    def test_delete_task(self):
        task = Task.objects.create(
            title='Test Task',
            description='This is a test task.',
            status='pending',
            priority='high',
            assignee=self.user,
            due_date='2023-12-31',
            created_by=self.user
        )
        response = self.client.delete(f'/api/tasks/{task.id}/')
        assert response.status_code == status.HTTP_204_NO_CONTENT
        assert Task.objects.count() == 0