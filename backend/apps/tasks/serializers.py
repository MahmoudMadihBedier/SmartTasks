from rest_framework import serializers
from .models import Task

class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = '__all__'  # or specify the fields you want to include, e.g., ['id', 'title', 'description', 'status', 'priority', 'assignee', 'due_date']