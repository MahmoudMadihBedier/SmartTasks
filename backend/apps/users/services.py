from django.contrib.auth import get_user_model
from rest_framework import exceptions

User = get_user_model()

class UserService:
    @staticmethod
    def create_user(email, password, full_name, role):
        user = User(email=email, full_name=full_name, role=role)
        user.set_password(password)
        user.save()
        return user

    @staticmethod
    def get_user_by_id(user_id):
        try:
            return User.objects.get(id=user_id)
        except User.DoesNotExist:
            raise exceptions.NotFound("User not found.")

    @staticmethod
    def update_user(user_id, **kwargs):
        user = UserService.get_user_by_id(user_id)
        for key, value in kwargs.items():
            setattr(user, key, value)
        user.save()
        return user

    @staticmethod
    def delete_user(user_id):
        user = UserService.get_user_by_id(user_id)
        user.delete()
        return {"message": "User deleted successfully."}