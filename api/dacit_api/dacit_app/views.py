from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from dacit_app.models import Text_Stimulus, Min_Pair, Audio, Speaker
from dacit_app.serializers import TextStimulusSerializer, MinPairSerializer
import logging
from random import choice


class MultipartView(APIView):
    def handle_upload(self, request, format=None, *args, **kwargs):
        return Response({'raw': request.data, 'data': request._request.POST,
                        'files': str(request._request.FILES)})


class TextStimuli(APIView):
    # return a number of textstimuli
    def get(self, request, format=None):
        all_stimuli = Text_Stimulus.objects.order_by('text')[:5]
        print(all_stimuli)
        json_stimuli = TextStimulusSerializer(all_stimuli).data
        return Response(json_stimuli)


class TextStimulus(APIView):
    # return a random single text stimulus
    def get(self, request, format=None):
        stimulus = Text_Stimulus.objects.first()
        print(stimulus)
        json_stimulus = TextStimulusSerializer(stimulus).data
        return Response(json_stimulus)


class MinPair(APIView):
    # return a random single text stimulus
    def get(self, request, format=None):
        speaker = request.query_params.get('speaker')
        if speaker is None:
            selected_speaker = Speaker.objects.filter(
                first_name='Thomas', last_name='K').first()
        else:
            selected_speaker = Speaker.objects.get(pk=speaker)

        text_category = request.query_params.get('category')
        category = None
        for min_pair_cat in Min_Pair.Min_Pair_Class.choices:
            if text_category == min_pair_cat[0]:
                category = min_pair_cat
                break
        if category is None:
            logging.warning("Category not found")
            return Response({"error": "Category not defined"}, status=status.HTTP_404_NOT_FOUND)

        class_selection = Min_Pair.objects.filter(min_pair_class=category[0])
        pks = class_selection.values_list('pk', flat=True)
        random_pk = choice(pks)
        minpair = class_selection.get(pk=random_pk)

        first_audio = Audio.objects.get(text_stimulus=minpair.first_part, speaker=selected_speaker)
        second_audio = Audio.objects.get(text_stimulus=minpair.second_part, speaker=selected_speaker)
        print(first_audio.audio.url)
        json_min_pair = {
            "minpair": minpair.pk,
            "first_stimulus": minpair.first_part.text,
            "first_audio": first_audio.audio.url,
            "second_stimulus": minpair.second_part.text,
            "second_audio": second_audio.audio.url
        }
        #minpair = Min_Pair.objects.filter(min_pair_class='B_W')
        #minpair = Min_Pair.objects.first()
        #json_min_pair = MinPairSerializer(minpair, first_audio, second_audio).data
        return Response(json_min_pair)
