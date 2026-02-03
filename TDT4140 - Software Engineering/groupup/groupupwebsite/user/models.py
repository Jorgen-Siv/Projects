from django.db import models
from django.contrib.auth.models import User

#from groupupwebsite.group.models import Group_model

# Create your models here.


#The profile entity for a user. Keeps track of the information provided on the user creation page.
class Profile(models.Model):
    user = models.OneToOneField(User, null=True, on_delete=models.CASCADE, related_name="profile")
    full_name = models.CharField(max_length=200, null=True)
    date_of_birth = models.DateField(null=True)
    email = models.CharField(max_length=200, null=True)
    date_created = models.DateTimeField(auto_now_add=True)
    interest_temp = models.CharField(max_length=200, null=True)
    
    
    CATEGORY = (
        ('Male', 'Male'),
        ('Female', 'Female'),
    )
    sex = models.CharField(max_length=200, null=True, choices=CATEGORY)
  
    
    def __str__(self):
        return self.full_name


#Interest entity. Keeps track of all the interests. By using through, the relationship will be created by 
#InterestStatus.
class Interest(models.Model):
    name = models.CharField(max_length=200, null=True)
    profile = models.ManyToManyField(Profile, through='InterestStatus')
    
    def __str__(self):
        return self.name

#A way to add interests to any profile in the database. Can also add more attributes that describe
#a profile's relation to an interest. Creates a many-to-many relation.
class InterestStatus(models.Model):
    profile = models.ForeignKey(Profile, on_delete=models.CASCADE)
    interest = models.ForeignKey(Interest, on_delete=models.CASCADE)
    rating = models.CharField(max_length=1, null=True)
    
class Meta:
    unique_together = [['profile', 'interest']]
