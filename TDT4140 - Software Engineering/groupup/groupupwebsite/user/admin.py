from django.contrib import admin
from .models import Profile

# Register your models here.

from .models import * 

admin.site.register(Profile)
admin.site.register(Interest)
admin.site.register(InterestStatus)
