from django.db import transaction
from .models import Task
from .serializers import TaskSerializer

class TaskService:
    @staticmethod
    @transaction.atomic
    def create_task(data):
        task = TaskSerializer(data=data)
        if task.is_valid():
            task.save()
            return task.data
        return None

    @staticmethod
    def get_task(task_id):
        try:
            task = Task.objects.get(id=task_id)
            return TaskSerializer(task).data
        except Task.DoesNotExist:
            return None

    @staticmethod
    @transaction.atomic
    def update_task(task_id, data):
        try:
            task = Task.objects.get(id=task_id)
            task_serializer = TaskSerializer(task, data=data, partial=True)
            if task_serializer.is_valid():
                task_serializer.save()
                return task_serializer.data
            return None
        except Task.DoesNotExist:
            return None

    @staticmethod
    @transaction.atomic
    def delete_task(task_id):
        try:
            task = Task.objects.get(id=task_id)
            task.delete()
            return True
        except Task.DoesNotExist:
            return False

    @staticmethod
    def list_tasks():
        tasks = Task.objects.all()
        return TaskSerializer(tasks, many=True).data