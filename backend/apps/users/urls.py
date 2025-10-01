from django.urls import path
from .views import UserListView, UserDetailView, UserLoginView, UserSignupView

urlpatterns = [
    path('users/', UserListView.as_view(), name='user-list'),
    path('users/<int:pk>/', UserDetailView.as_view(), name='user-detail'),
    path('auth/login/', UserLoginView.as_view(), name='user-login'),
    path('auth/signup/', UserSignupView.as_view(), name='user-signup'),
]