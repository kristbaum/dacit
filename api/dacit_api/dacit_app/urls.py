from django.urls import path
from . import views

urlpatterns = [
    path('upload/', views.MultipartView.handle_upload, name='upload'),
    path('ts/', views.TextStimuli.as_view(), name='ts'),
    path('sts/', views.TextStimulus.as_view(), name='sts'),
    path('minpair/', views.MinPair.as_view(), name='minpair'),
#    path('user/', views.UserRecordView.as_view(), name='users'),
]
