from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from dacit_app.models import Text_Stimulus
from dacit_app.serializers import TextStimulusSerializer


class MultipartView(APIView):

    def handle_upload(self, request, format=None, *args, **kwargs):
        return Response({'raw': request.data, 'data': request._request.POST,
                        'files': str(request._request.FILES)})

class TextStimuli(APIView):
    def get(self, request, format=None):
        all_stimuli = Text_Stimulus.objects.all()
        print(all_stimuli)
        json_stimuli = TextStimulusSerializer(all_stimuli, many=True).data
        return Response(json_stimuli) 

class TextStimulus(APIView):
    def get(self, request, format=None):
        stimulus = Text_Stimulus.objects.first()
        print(stimulus)
        json_stimulus = TextStimulusSerializer(stimulus).data
        return Response(json_stimulus)