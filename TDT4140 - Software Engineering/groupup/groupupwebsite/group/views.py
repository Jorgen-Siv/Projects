from multiprocessing import context
from tokenize import group
from django.shortcuts import redirect, render
from django.http import HttpResponse
from django.contrib import messages

from django.contrib.auth.decorators import login_required

# Create your views here.
from .models import *
from .forms import CreateGroupForm, CreateGroupModelForm


# Create your views here.
def myGroups(request):
    return render(request, 'myGroups.html')


def gropuRegisterPage(request):
    if request.user.is_authenticated == False:
        return redirect('profile')
    else:
        form = CreateGroupForm()
        groupForm = CreateGroupModelForm()
        if request.method == 'POST':
            form = CreateGroupForm(request.POST)
            groupForm = CreateGroupModelForm(request.POST)
            if form.is_valid() and groupForm.is_valid():
                # create the auth group and add the user who created the group
                group = form.save()
                current_user = request.user
                group.user_set.add(current_user)
                current_user.save()

                # create our group model and add the correct profile
                group_model = groupForm.save(commit=False)
                group_model.group = group
                group_model.group_leader = current_user
                group.save()
                
                current_profile = current_user.profile
                group_model.save()
                group_model.members.add(current_profile) #
                group_model.addToGroup(current_user, current_profile)
                group_model.save()
                group.save()
                groupForm.save_m2m()
                GroupLeader.objects.create(leader=current_profile, group=group_model)
                
                #for løkke   
                #members = filter(lambda t: t[0] in groupForm.cleaned_data['members'], groupForm.fields['members'].choices)
                
                members = groupForm.cleaned_data['members']

                   
                for new_member in members:
                    group_model.addToGroup(current_user, new_member)
                                                      
                groupForm.save_m2m()
                
    
                """allMembers = request.POST.getlist('members')
                
                for i in allMembers:
                    Group_members.objects.create(member=i, group=group_model)"""
                    
                
                
                return redirect('view_group')

        context = {'form': form, 'groupForm': groupForm}
        return render(request, 'create_group.html', context)


def change_members(request, operation, pk):
    return redirect()


def view_group(request):
    groups1= Group_model.objects.filter(group_leader=request.user)
    #groups2= Group_model.objects.filter(members=request.user.profile)
    groups=(groups1)#| groups2).distinct()

    id1=groups[0].id
    members1=[]
    for members in Group_model.objects.get(id=id1).members.all():
        print('HER')
        members1.append(members.full_name)
        
    #group=Group_model.objects.get(id=id1).members.full_name
    print(groups)
    print(members1)
    context={'group_model':groups[0]}
    return render(request, 'view_group.html', context)
