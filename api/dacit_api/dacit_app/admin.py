from django.contrib import admin

# Register your models here.
from dacit_app.models import *

admin.site.register(DacitUser)
admin.site.register(Audio)
admin.site.register(Text_Stimulus)
admin.site.register(Min_Pair)
admin.site.register(Audio_to_Users)
