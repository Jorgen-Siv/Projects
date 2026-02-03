from pyexpat import model
from django.contrib.auth.models import Group, User
from sys import maxsize
from django.db import models
from user.models import Profile

from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType

#Through references another table which means that the foreign keys will be stored
#in the Group_member table.
class Group_model(models.Model):
    group=models.OneToOneField(Group, null=True, on_delete=models.CASCADE)
    members = models.ManyToManyField(Profile) 
    name = models.CharField(max_length=200, null=True)
    interests = models.CharField(max_length=200, null =True)
    email = models.CharField(max_length=200, null=True)
    date_created = models.DateTimeField(auto_now_add=True)
    age_min=models.PositiveIntegerField(null=True)
    age_max=models.PositiveIntegerField(null=True)
    location=models.CharField(max_length=200, null=True)
    date_meeting=models.DateField(null=True, auto_now_add=False)
    group_leader= models.ForeignKey(User, null=True, on_delete=models.CASCADE)
    
    ######################################################### 
    @classmethod 
    def addToGroup(cls, group_leader, new_member):
        
        if(cls.group_leader == group_leader):
        
            member, created = cls.objects.get_or_create(
                group_leader=group_leader
            )
            cls.members.add(new_member)
        

    def __str__(self):
        return self.name 

    def getGroupAndLeader(self):
        return self.name + ' : ' + self.group_leader.username
    
    def getGroupName(self):
        return self.name

"""
class Group_members(models.Model):
    member = models.ForeignKey(Profile, on_delete=models.CASCADE)
    group = models.ForeignKey(Group_model, on_delete=models.CASCADE)
    
    def __str__(self):
        return self.group.getGroupName()
    """
class Interest(models.Model):

    name = models.CharField(max_length=200, null=True)
    description = models.CharField(max_length=200, null=True)
    CATEGORY = (
        ('Sport', 'Sport'),
        ('Music', 'Music'),
    )
    category = models.CharField(max_length=200, null=True, choices=CATEGORY)
    group = models.ManyToManyField(Group_model)

class GroupLeader(models.Model):

    leader = models.ForeignKey(Profile, on_delete=models.CASCADE)
    group = models.ForeignKey(Group_model, on_delete=models.CASCADE)

    def __str__(self):
        return self.group.getGroupAndLeader()
    
    class Meta:
        #Man slipper å "lage" permissions som det kommenterte feltet over.
        #https://stackoverflow.com/questions/1876424/add-a-custom-permission-to-a-user
        permissions = [
            ('an_add_users', 'Can add other users to the group'),
            ('can_remove_users', 'Can remove other users from the group'),
        ]
