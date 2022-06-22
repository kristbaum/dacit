from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser


class MultipartView(APIView):

    def handle_upload(self, request, format=None, *args, **kwargs):
        return Response({'raw': request.data, 'data': request._request.POST,
                        'files': str(request._request.FILES)})
