from django.forms import ModelForm
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import Group
from django import forms
from .models import Group_model
from .models import Profile
from django.forms import TextInput, EmailInput, DateInput, NumberInput

class CreateGroupForm(ModelForm):
    class Meta:
        model = Group
        fields = ['name']

        widgets = {
            'name': TextInput(attrs={
                'class': "form-control",
                'style': 'max-width: 350px;',
                'placeholder': 'Name of group'
                })
        }

class CreateGroupModelForm(ModelForm):
    class Meta:
        model = Group_model
        fields = ['name', 'email', 'interests', 'age_min',
                  'age_max', 'location', 'date_meeting', 'members']
        
        members = forms.ModelMultipleChoiceField(
            queryset=Profile.objects.all(),
            widget=forms.CheckboxSelectMultiple
        )

        widgets = {
            'email': EmailInput(attrs={
                'class': "form-control", 
                'style': 'max-width: 350px;',
                'placeholder': 'E-mail'
                }),
            'interests': TextInput(attrs={
                'class': "form-control", 
                'style': 'max-width: 350px;',
                'placeholder': 'Top three interests'
                }),
            'age_min': NumberInput(attrs={
                'class': "form-control", 
                'style': 'max-width: 350px;',
                'placeholder': 'Minimum age of group member'
                }),
            'age_max': NumberInput(attrs={
                'class': "form-control", 
                'style': 'max-width: 350px;',
                'placeholder': 'Maximum age of group member'
                }),
            'location': TextInput(attrs={
                'class': "form-control", 
                'style': 'max-width: 350px;',
                'placeholder': 'City for meeting'
                }),
            'date_meeting': DateInput(attrs={
                'class': "form-control", 
                'type' : 'date',
                'style': 'max-width: 350px;',
                })
        }
