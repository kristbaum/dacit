from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
import random


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


class DacitUserManager(BaseUserManager):
    def create_user(self, email, password=None):
        """
        Creates and saves a User with the given email and password.
        """
        if not email:
            raise ValueError('Users must have an email address')

        user = self.model(
            email=self.normalize_email(email),
        )

        user.username = random.randint(100000000000, 9999999999999)
        user.public_id = user.username
        logging.info("Setting this userid as publicid: " + user.public_id)

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(
            email,
            password=password,
        )
        user.is_admin = True
        user.save(using=self._db)
        return user


class DacitUser(AbstractBaseUser):
    email = models.EmailField(
        verbose_name='email address',
        max_length=255,
        unique=True,
    )
    is_active = models.BooleanField(default=True)
    is_admin = models.BooleanField(default=False)
    username = models.CharField(max_length=255)
    public_id = models.BigIntegerField(
        blank=True,
        null=True,
        unique=True)

    objects = DacitUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.email

    def has_perm(self, perm, obj=None):
        "Does the user have a specific permission?"
        return self.is_admin

    def has_module_perms(self, app_label):
        "Does the user have permissions to view the app `app_label`?"
        return self.is_admin

    @property
    def is_staff(self):
        "Is the user a member of staff?"
        return self.is_admin

    ci_user = models.ForeignKey(CI_User, on_delete=models.CASCADE, null=True)
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

    def __str__(self):
        return self.text


class Audio(models.Model):
    text_stimulus = models.ForeignKey(Text_Stimulus, on_delete=models.CASCADE)
    speaker = models.ForeignKey(DacitUser, on_delete=models.CASCADE)
    audio = models.FileField(upload_to='audio')
    language = models.CharField(max_length=2)
    dicalect = models.CharField(max_length=100)

    def __str__(self):
        return str(self.audio.name)


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
