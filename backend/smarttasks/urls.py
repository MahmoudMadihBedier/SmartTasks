from django.urls import path, include

urlpatterns = [
    path('api/users/', include('apps.users.urls')),
    path('api/projects/', include('apps.projects.urls')),
    path('api/tasks/', include('apps.tasks.urls')),
]