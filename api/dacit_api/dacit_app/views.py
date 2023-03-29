from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FormParser, MultiPartParser, FileUploadParser
from rest_framework import status
from dacit_app.models import Text_Stimulus, Text_Stimulus_Sent, Min_Pair, Audio, DacitUser
from dacit_app.serializers import TextStimulusSerializer, MinPairSerializer, DacitUserSerializer
from rest_framework.permissions import IsAdminUser, AllowAny
import logging
from random import choice
from django.views.decorators.http import require_http_methods


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
    parser_classes = [MultiPartParser]

    def post(self, request, filename, format=None):
        # logging.info("Filename: " + filename)
        # logging.info("Requestdata: " + str(request.data))
        logging.info(request.FILES)
        file_obj = request.FILES['file']
        dacit_user = request.user

        matching_ts = Text_Stimulus.objects.get(pk=int(filename))

        if matching_ts is not None:
            # logging.info(matching_ts)

            # logging.info(file_obj)
            new_audio = Audio(text_stimulus=matching_ts, speaker=dacit_user, audio=file_obj,
                              language=dacit_user.active_language, dialect=dacit_user.active_dialect)
            new_audio.save()
            return Response(status=status.HTTP_201_CREATED)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def __str__(self):
        return str(self.audio.name)


class TextStimuli(APIView):
    # return a number of textstimuli
    def get(self, request, format=None):
        all_stimuli = Text_Stimulus.objects.order_by('text')[:5]
        logging.info(all_stimuli)
        json_stimuli = TextStimulusSerializer(all_stimuli).data
        return Response(json_stimuli)


class TextStimulus(APIView):

    def get(self, request, format=None):
        # Get all the Text_Stimulus objects
        all_text_stimuli = Text_Stimulus.objects.all()

        # Check if any Text_Stimulus has already been sent to the user
        text_stimuli_sent_to_user = Text_Stimulus_Sent.objects.filter(
            user=request.user)
        text_stimuli_sent_to_user_ids = [
            text_stimulus_sent.text_stimulus.id for text_stimulus_sent in text_stimuli_sent_to_user]

        # Exclude any Text_Stimulus that has already been sent to the user
        text_stimuli_to_send = all_text_stimuli.exclude(
            id__in=text_stimuli_sent_to_user_ids)

        if text_stimuli_to_send.exists():
            # Choose a random Text_Stimulus to send to the user
            text_stimulus = choice(text_stimuli_to_send)

            # Track that this Text_Stimulus has been sent to the user
            text_stimulus_sent = Text_Stimulus_Sent(
                user=request.user, text_stimulus=text_stimulus, sent=1)
            text_stimulus_sent.save()

            logging.info(text_stimulus)
            json_stimulus = TextStimulusSerializer(text_stimulus).data
            return Response(json_stimulus)
        else:
            # If all Text_Stimuli have been sent to the user, return an empty Response
            return Response({})


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
        logging.info(first_audio.audio.url)
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
