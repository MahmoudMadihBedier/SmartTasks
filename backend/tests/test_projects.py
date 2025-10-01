from django.test import TestCase
from apps.projects.models import Project
from apps.users.models import User

class ProjectModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='testuser@example.com',
            password='testpassword',
            full_name='Test User'
        )
        self.project = Project.objects.create(
            title='Test Project',
            description='A project for testing purposes',
            owner=self.user
        )

    def test_project_creation(self):
        self.assertEqual(self.project.title, 'Test Project')
        self.assertEqual(self.project.description, 'A project for testing purposes')
        self.assertEqual(self.project.owner, self.user)

    def test_project_str(self):
        self.assertEqual(str(self.project), 'Test Project')

    def test_project_members(self):
        self.project.members.add(self.user)
        self.assertIn(self.user, self.project.members.all())