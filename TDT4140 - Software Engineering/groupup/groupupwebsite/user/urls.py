from unicodedata import name
from django.urls import path, include
from . import views
import django.contrib.auth

urlpatterns = [
    path('profile/', views.profile, name="profile"),
    path('create_profile/', views.registerPage, name="register"),
    path('accounts/', include("django.contrib.auth.urls"), name="accounts"),
    path('', views.frontpage, name='frontpage'),
]