from multiprocessing import context
from django.shortcuts import redirect, render
from django.http import HttpResponse
from django.contrib import messages

from django.contrib.auth.decorators import login_required

# Create your views here.
from .models import *
from group.models import *
from .forms import CreateUserForm, profileForm


# Create your views here.
def profile(request):
	if request.user.is_authenticated:
		groups1= Group_model.objects.filter(group_leader=request.user)
		groups2= Group_model.objects.filter(members=request.user.profile)
		groups=(groups1| groups2).distinct()
		context={
			'group': groups
		}

		return render(request, 'profile.html', context)
	else:
		return render ('login')

def registerPage(request):
	if request.user.is_authenticated:
		return redirect('profile')
	else:
		form = CreateUserForm()
		profile_form = profileForm()
		if request.method == 'POST':
			form = CreateUserForm(request.POST)
			profile_form = profileForm(request.POST)
			if form.is_valid() and profile_form.is_valid() :
				user = form.save()
				profile = profile_form.save(commit=False)
				profile.user = user
				profile.save()


				username = form.cleaned_data.get('username')
				messages.success(request, 'Account was created for ' + username)

				return redirect('login')

		context = {'form':form, 'profile_form': profile_form}
		return render(request, 'create_profile.html', context)


def frontpage(request):
    if request.user.is_authenticated==False: 
        return redirect('login')
    elif request.user.is_authenticated==True:
        return redirect('profile')

