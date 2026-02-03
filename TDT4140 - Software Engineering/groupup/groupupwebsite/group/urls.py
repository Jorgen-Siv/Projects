from django.urls import path
from django.conf.urls import include
from . import views
from django.shortcuts import redirect

urlpatterns = [
    path('my_groups/', views.myGroups, name="myGroups"),
    path('create_group/', views.gropuRegisterPage, name="create_group"),
    path('view_group/', views.view_group, name='view_group'), 
]
