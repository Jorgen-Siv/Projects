from django.test import SimpleTestCase
from django.test import TestCase, Client
from django.urls import resolve, reverse
from group.views import myGroups, gropuRegisterPage, view_group
import json

class TestGroupUrls(SimpleTestCase):

    def test_my_groups_url_resolves(self):
        url = reverse('my_groups')
        self.assertEquals(resolve(url).func, myGroups)

    def test_create_group_url_resolves(self):
        url = reverse('create_group')
        self.assertEquals(resolve(url).func, gropuRegisterPage)
    
    def test_view_group_url_resolves(self):
        url = reverse('view_group')
        self.assertEquals(resolve(url).func, view_group)


class TestGroupViews(TestCase):

    def setUp(self):
        self.client = Client()
        self.my_groups_url = reverse('myGroups')
        self.create_group_url = reverse('create_group')
        self.view_group_url = reverse('view_group')

    def test_my_groups_GET(self):
        response = self.client.get(self.my_groups_url)

        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'myGroups.html')
    
    def test_view_group_GET(self):
        response = self.client.get(self.view_group_url)

        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'view_group.html')
    
    def test_create_group_GET(self):
        response = self.client.get(self.create_group_url)

        self.assertEquals(response.status_code, 200)
        self.assertTemplateUsed(response, 'create_group.html')
    
