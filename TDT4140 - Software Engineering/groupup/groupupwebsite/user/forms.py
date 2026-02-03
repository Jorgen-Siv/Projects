from django.forms import ModelForm
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django import forms
from django.utils.translation import gettext_lazy as _
from .models import Profile
from django.core.exceptions import ValidationError
from django.forms import TextInput, EmailInput, DateInput



class CreateUserForm(UserCreationForm):
    class Meta:
        model = User
        fields = ['username', 'password1', 'password2']

        widgets = {
            'username': TextInput(attrs={
                'class': "form-control",
                'style': 'max-width: 350px;',
                'placeholder': 'Name'
                })
        }


class profileForm(ModelForm):
    class Meta:
        model = Profile
        fields = ['full_name', 'email', 'date_of_birth', 'interest_temp']

        widgets = {
            'full_name': TextInput(attrs={
                'class': "form-control",
                'style': 'max-width: 350px;',
                'placeholder': 'Name'
                }),
            'email': EmailInput(attrs={
                'class': "form-control", 
                'style': 'max-width: 350px;',
                'placeholder': 'Email'
                }),
            'date_of_birth': DateInput(attrs={
                'class': "form-control",
                'type' : 'date',
                'style': 'max-width: 350px;',
                }),
            'interest_temp': TextInput(attrs={
                'class': "form-control",
                'style': 'max-width: 350px;',
                'placeholder': 'Top three interests'
                })                                 
        }

    def clean_date_of_birth(self, *args, **kwargs):
        import datetime

        date_of_birth = self.cleaned_data.get("date_of_birth")
        today = datetime.date.today()

        # Finds out if todays day/month comes before the given date_of_birth
        one_or_zero = ((today.month, today.day) < (
            date_of_birth.month, date_of_birth.day))

        difference = today.year - date_of_birth.year
        age = difference - one_or_zero

        if age >= 18:
            return date_of_birth
        else:
            raise forms.ValidationError("User must be atleast 18 years old")
