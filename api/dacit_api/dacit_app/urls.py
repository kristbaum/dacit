from django.urls import path
from . import views

urlpatterns = [
    # path('upload/', views.MultipartView.handle_upload, name='upload'),
    path('upload/<str:filename>/', views.FileUploadView.as_view(), name='upload'),
    path('download/<str:filename>/', views.Download.as_view(), name='download'),
    # path('ts/', views.TextStimuli.as_view(), name='ts'),
    path('sts/', views.TextStimulus.as_view(), name='sts'),
    path('minpair/', views.MinPair.as_view(), name='minpair'),
    path('user/', views.DacitUserRecordView.as_view(), name='users'),
]
