from django.test import SimpleTestCase
from django.test import TestCase, Client
from django.urls import resolve, reverse
from user.views import profile, registerPage
import json

class TestUserUrls(SimpleTestCase):

    def test_profile_url_resolves(self):
        url = reverse('profile')
        self.assertEquals(resolve(url).func, profile)

    def test_register_url_resolves(self):
        url = reverse('register')
        print(url)
        self.assertEquals(resolve(url).func, registerPage)


class TestUserViews(TestCase):

    def setUp(self):
        self.client = Client()
        self.profile_url = reverse('profile')
        self.register_url = reverse('register')

    def test_profile_GET(self):
        response = self.client.get(self.profile_url)

        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'profile.html')

    def test_create_profile_GET(self):
        response = self.client.get(self.register_url)

        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'create_profile.html')
    
