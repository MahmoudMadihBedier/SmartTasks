from django.db import transaction
from .models import Project
from .serializers import ProjectSerializer

class ProjectService:
    @staticmethod
    @transaction.atomic
    def create_project(data):
        project = ProjectSerializer(data=data)
        if project.is_valid():
            project.save()
            return project.instance
        return None

    @staticmethod
    def get_project(project_id):
        try:
            return Project.objects.get(id=project_id)
        except Project.DoesNotExist:
            return None

    @staticmethod
    @transaction.atomic
    def update_project(project_id, data):
        project = ProjectService.get_project(project_id)
        if project:
            project_serializer = ProjectSerializer(instance=project, data=data, partial=True)
            if project_serializer.is_valid():
                project_serializer.save()
                return project_serializer.instance
        return None

    @staticmethod
    @transaction.atomic
    def delete_project(project_id):
        project = ProjectService.get_project(project_id)
        if project:
            project.delete()
            return True
        return False

    @staticmethod
    def list_projects():
        return Project.objects.all()