from rest_framework import serializers
from dacit_app.models import Text_Stimulus, Min_Pair, User
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


class UserSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user

    class Meta:
        model = User
        fields = (
            'name',
            'email',
            'password',
        )
        validators = [
            UniqueTogetherValidator(
                queryset=User.objects.all(),
                fields=['email']
            )
        ]
