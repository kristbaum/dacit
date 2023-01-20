from rest_framework import serializers
from dacit_app.models import Text_Stimulus, Min_Pair, DacitUser
from rest_framework.validators import UniqueTogetherValidator


class TextStimulusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Text_Stimulus
        #fields = ['text', 'id']
        fields = '__all__'


class MinPairSerializer(serializers.ModelSerializer):
    class Meta:
        model = Min_Pair
        fields = '__all__'


# class UserSerializer(serializers.ModelSerializer):

#     def create(self, validated_data):
#         user = DacitUser.objects.create_user(**validated_data)
#         return user

#     class Meta:
#         model = DacitUser
#         fields = (
#             'name',
#             'email',
#             'password',
#         )
#         validators = [
#             UniqueTogetherValidator(
#                 queryset=DacitUser.objects.all(),
#                 fields=['email']
#             )
#         ]
