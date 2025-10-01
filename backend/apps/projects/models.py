from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Project(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    owner = models.ForeignKey(User, related_name='projects', on_delete=models.CASCADE)
    members = models.ManyToManyField(User, related_name='project_members', blank=True)

    def __str__(self):
        return self.title

    class Meta:
        verbose_name = 'Project'
        verbose_name_plural = 'Projects'