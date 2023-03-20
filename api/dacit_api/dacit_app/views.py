from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FormParser, FileUploadParser
from rest_framework import status
from dacit_app.models import Text_Stimulus, Min_Pair, Audio, DacitUser
from dacit_app.serializers import TextStimulusSerializer, MinPairSerializer, DacitUserSerializer
from rest_framework.permissions import IsAdminUser, AllowAny
import logging
from random import choice


class DacitUserRecordView(APIView):
    """
    API View to create or get a list of all the registered
    users. GET request returns the registered users whereas
    a POST request allows to create a new user.
    """
    # permission_classes = [IsAdminUser]

    # def get(self, format=None):
    #     users = CustomUser.objects.all()
    #     serializer = DacitUserSerializer(users, many=True)
    #     return Response(serializer.data)
    permission_classes = [AllowAny]

    def post(self, request):
        logging.info("Create user")
        serializer = DacitUserSerializer(data=request.data)
        logging.info("Create user")
        if serializer.is_valid(raise_exception=ValueError):
            serializer.create(validated_data=request.data)
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            {
                "error": True,
                "error_msg": serializer.error_messages,
            },
            status=status.HTTP_400_BAD_REQUEST
        )

# class DacitUserPreferences:
#    def get(self, request):


# class MultipartView(APIView):
 #   def handle_upload(self, request, format=None, *args, **kwargs):
 #       return Response({'raw': request.data, 'data': request._request.POST,
 #                       'files': str(request._request.FILES)})

class FileUploadView(APIView):
    parser_classes = [FileUploadParser]

    def put(self, request, filename, format=None):
        file_obj = request.data['file']
        dacit_user = request.user
        
        logging.info(filename)
        matching_ts = Text_Stimulus.objects.get(pk=int(filename))
        logging.info(matching_ts)

        # json_text = request.data['json']
        print(file_obj)
        new_audio = Audio(text_stimulus=matching_ts, speaker=dacit_user, audio=file_obj,
                          language=dacit_user.active_language, dialect=dacit_user.active_dialect)
        new_audio.save()
        return Response(status=204)

    def __str__(self):
        return str(self.audio.name)


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
                public_id=1).first()
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

        first_audio = Audio.objects.get(
            text_stimulus=minpair.first_part, speaker=selected_speaker)
        second_audio = Audio.objects.get(
            text_stimulus=minpair.second_part, speaker=selected_speaker)
        print(first_audio.audio.url)
        json_min_pair = {
            "minpair": minpair.pk,
            "first_stimulus": minpair.first_part.text,
            "first_audio": first_audio.audio.url,
            "second_stimulus": minpair.second_part.text,
            "second_audio": second_audio.audio.url
        }
        # minpair = Min_Pair.objects.filter(min_pair_class='B_W')
        # minpair = Min_Pair.objects.first()
        # json_min_pair = MinPairSerializer(minpair, first_audio, second_audio).data
        return Response(json_min_pair)
