from rest_framework import serializers
from dacit_app.models import Text_Stimulus


class TextStimulusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Text_Stimulus
        fields = ['text', 'id']
        #fields = '__all__'

# text = models.CharField(max_length=500, blank=False)
#     user_audio_creatable = models.BooleanField(default=True)

#     class Language(models.TextChoices):
#         GERMAN = 'DE'
#         ENGLISH = 'EN'
#     language = models.CharField(
#         max_length=2,
#         choices=Language.choices,
#         default=Language.GERMAN,
#         blank=False
#     )
    
#     wd_lexeme_url = models.CharField(max_length = 50)
#     wd_item_url = models.CharField(max_length = 50)
#     wc_picture_url = models.CharField(max_length = 1500)
#     description = models.CharField(max_length = 1000)
#     creator = models.CharField(max_length = 50)