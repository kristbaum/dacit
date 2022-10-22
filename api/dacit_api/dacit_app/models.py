from django.db import models


class CI_User(models.Model):
    COCHLEARLIMITED = 'CL'
    ADVANCEDBIONICS = 'AB'
    MEDEL = 'ME'
    NEURELEC = 'NC'
    NUROTRON = 'NN'
    MANUFACTURERS = [
        (COCHLEARLIMITED, 'Cochlear Limited'),
        (ADVANCEDBIONICS, 'Advanced Bionics'),
        (MEDEL, 'MED-EL'),
        (NEURELEC, 'Neurelec'),
        (NUROTRON, 'Nurotron'),
    ]
    manufacturer = models.CharField(
        max_length=2,
        choices=MANUFACTURERS,
    )

    name = models.CharField(max_length=100)
    theraphist = models.CharField(max_length=100)
    birthdate = models.DateField()
    created = models.DateTimeField(auto_now_add=True)


class Speaker(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    ci_user = models.ForeignKey(CI_User, on_delete=models.CASCADE, null=True)
    created = models.DateTimeField(auto_now_add=True)

    PARENT = 'P'
    SIBLING = 'S'
    FRIEND = 'F'
    GRANDPARENT = 'G'
    THERAPIST = 'T'
    RELATIONSHIP_TYPES = [
        (PARENT, 'Parent'),
        (SIBLING, 'Sibling'),
        (FRIEND, 'Friend'),
        (GRANDPARENT, 'Grandparent'),
        (THERAPIST, 'Therapist'),
    ]
    relationship = models.CharField(
        max_length=1,
        choices=RELATIONSHIP_TYPES,
    )


class Text_Stimulus(models.Model):
    text = models.CharField(max_length=500, blank=False)
    user_audio_creatable = models.BooleanField(default=True)

    class Language(models.TextChoices):
        GERMAN = 'DE'
        ENGLISH = 'EN'
    language = models.CharField(
        max_length=2,
        choices=Language.choices,
        default=Language.GERMAN,
        blank=False
    )

    wd_lexeme_url = models.CharField(max_length=50)
    wd_item_url = models.CharField(max_length=50)
    wc_picture_url = models.CharField(max_length=1500)
    description = models.CharField(max_length=1000)
    creator = models.CharField(max_length=50)

    # class Text_Stimulus_Class(models.TextChoices):
    #     Consonant = 'C'
    #     F_W = 'F_W'
    #     H_R = 'H_R'
    #     K_T = 'K_T'
    #     PF_F = 'PF_T'
    #     R_L = 'R_L'
    # min_pair_class = models.CharField(
    #     max_length=4,
    #     choices=Min_Pair_Class.choices,
    #     default=None,
    # )

    def __str__(self):
        return self.text


class Audio(models.Model):
    text_stimulus = models.ForeignKey(Text_Stimulus, on_delete=models.CASCADE)
    speaker = models.ForeignKey(Speaker, on_delete=models.CASCADE)
    audio = models.FileField(upload_to='audio')
    language = models.CharField(max_length=2)
    dicalect = models.CharField(max_length=100)


class Min_Pair(models.Model):
    first_part = models.ForeignKey(
        Text_Stimulus, on_delete=models.CASCADE, blank=False, related_name="first_part")
    second_part = models.ForeignKey(
        Text_Stimulus, on_delete=models.CASCADE, blank=False, related_name="second_part")

    class Min_Pair_Class(models.TextChoices):
        B_W = 'B_W'
        F_W = 'F_W'
        H_R = 'H_R'
        K_T = 'K_T'
        PF_F = 'PF_T'
        R_L = 'R_L'
    min_pair_class = models.CharField(
        max_length=4,
        choices=Min_Pair_Class.choices,
        default=None,
    )

    def __str__(self):
        return str(self.first_part) + " " + str(self.second_part)


class CI_User_Language(models.Model):
    language = models.CharField(max_length=2)
    dicalect = models.CharField(max_length=100)
    ci_user = models.ForeignKey(CI_User, on_delete=models.CASCADE)


class Audio_to_Users(models.Model):
    ci_user = models.ForeignKey(CI_User, on_delete=models.CASCADE)
    audio = models.ForeignKey(Audio, on_delete=models.CASCADE)
    ts_sent = models.DateTimeField(auto_now_add=True)
    ts_recieved = models.DateTimeField()
    skipped = models.BooleanField()
    mode = models.CharField(max_length=100)
