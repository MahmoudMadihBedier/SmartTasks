from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from .models import User

class UserTests(APITestCase):
    def setUp(self):
        self.user_data = {
            'email': 'testuser@example.com',
            'password': 'testpassword',
            'full_name': 'Test User',
            'role': 'member',
            'is_active': True
        }
        self.user = User.objects.create_user(**self.user_data)

    def test_user_creation(self):
        response = self.client.post(reverse('user-create'), {
            'email': 'newuser@example.com',
            'password': 'newpassword',
            'full_name': 'New User',
            'role': 'member',
            'is_active': True
        })
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 2)

    def test_user_login(self):
        response = self.client.post(reverse('user-login'), {
            'email': self.user_data['email'],
            'password': self.user_data['password']
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('token', response.data)

    def test_user_retrieval(self):
        response = self.client.get(reverse('user-detail', args=[self.user.id]))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], self.user_data['email'])

    def test_user_update(self):
        response = self.client.patch(reverse('user-detail', args=[self.user.id]), {
            'full_name': 'Updated User'
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.user.refresh_from_db()
        self.assertEqual(self.user.full_name, 'Updated User')

    def test_user_deletion(self):
        response = self.client.delete(reverse('user-detail', args=[self.user.id]))
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(User.objects.count(), 0)