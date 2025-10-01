from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    email = models.EmailField(unique=True)
    full_name = models.CharField(max_length=255)
    role = models.CharField(max_length=50, choices=[
        ('admin', 'Admin'),
        ('user', 'User'),
    ])
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.email