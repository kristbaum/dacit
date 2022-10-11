from django.urls import path
from . import views

urlpatterns = [
    path('upload/', views.MultipartView.handle_upload, name='upload'),
    path('ts/', views.TextStimuli.as_view(), name='ts'),
]
