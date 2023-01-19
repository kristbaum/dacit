from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone


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


class CustomUserManager(BaseUserManager):

    def _create_user(self, email, password, **extra_fields):
        now = timezone.now()
        if not email:
            raise ValueError('The given email must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, date_joined=now, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(email, password, **extra_fields)

    def create_superuser(self, email, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        return self._create_user(email, password, True, True, **extra_fields)


# class AccountManager(BaseUserManager):
#     use_in_migrations = True

#     def _create_user(self, email, name, phone, password, **extra_fields):
#         values = [email, name, phone]
#         field_value_map = dict(zip(self.model.REQUIRED_FIELDS, values))
#         for field_name, value in field_value_map.items():
#             if not value:
#                 raise ValueError('The {} value must be set'.format(field_name))

#         email = self.normalize_email(email)
#         user = self.model(
#             email=email,
#             name=name,
#             phone=phone,
#             **extra_fields
#         )
#         user.set_password(password)
#         user.save(using=self._db)
#         return user

#     def create_user(self, email, name, phone, password=None, **extra_fields):
#         extra_fields.setdefault('is_staff', False)
#         extra_fields.setdefault('is_superuser', False)
#         return self._create_user(email, name, phone, password, **extra_fields)

#     def create_superuser(self, email, name, phone, password=None, **extra_fields):
#         extra_fields.setdefault('is_staff', True)
#         extra_fields.setdefault('is_superuser', True)

#         if extra_fields.get('is_staff') is not True:
#             raise ValueError('Superuser must have is_staff=True.')
#         if extra_fields.get('is_superuser') is not True:
#             raise ValueError('Superuser must have is_superuser=True.')

#         return self._create_user(email, name, phone, password, **extra_fields)


# class Account(AbstractBaseUser, PermissionsMixin):
#     email = models.EmailField(unique=True)
#     name = models.CharField(max_length=150)
#     phone = models.CharField(max_length=50)
#     date_of_birth = models.DateField(blank=True, null=True)
#     is_staff = models.BooleanField(default=False)
#     is_active = models.BooleanField(default=True)
#     date_joined = models.DateTimeField(default=timezone.now)
#     last_login = models.DateTimeField(null=True)

#     objects = AccountManager()

#     USERNAME_FIELD = 'email'
#     REQUIRED_FIELDS = ['name', 'phone']

#     def get_full_name(self):
#         return self.name

#     def get_short_name(self):
#         return self.name.split()[0]

# class CustomUser(AbstractBaseUser):
#     first_name = models.CharField(max_length=5000, null=True)
#     last_name = models.CharField(max_length=5000, null=True)
#     email = models.EmailField(max_length=5000, unique=True)
#     is_staff = models.BooleanField(default=False)
#     is_superuser = models.BooleanField(default=False)
#     is_active = models.BooleanField(default=False)
#     date_joined = models.DateTimeField(auto_now_add=True)
#     last_login = models.DateTimeField(null=True)
#     USERNAME_FIELD = 'email'
#     REQUIRED_FIELDS = []
#     objects = CustomUserManager()

#     ci_user = models.ForeignKey(CI_User, on_delete=models.CASCADE, null=True)
#     PARENT = 'P'
#     SIBLING = 'S'
#     FRIEND = 'F'
#     GRANDPARENT = 'G'
#     THERAPIST = 'T'
#     RELATIONSHIP_TYPES = [
#         (PARENT, 'Parent'),
#         (SIBLING, 'Sibling'),
#         (FRIEND, 'Friend'),
#         (GRANDPARENT, 'Grandparent'),
#         (THERAPIST, 'Therapist'),
#     ]
#     relationship = models.CharField(
#         max_length=1,
#         choices=RELATIONSHIP_TYPES,
#     )

class CustomUser(AbstractBaseUser):
#    first_name = models.CharField(max_length=5000, null=True)
#    last_name = models.CharField(max_length=5000, null=True)
    email = models.EmailField(max_length=5000, unique=True)
#    is_staff = models.BooleanField(default=False)
#    is_superuser = models.BooleanField(default=False)
#    is_active = models.BooleanField(default=False)
#    date_joined = models.DateTimeField(auto_now_add=True)
#    last_login = models.DateTimeField(null=True)
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []
    objects = CustomUserManager()
#
#    ci_user = models.ForeignKey(CI_User, on_delete=models.CASCADE, null=True)
#    PARENT = 'P'
#    SIBLING = 'S'
#    FRIEND = 'F'
#    GRANDPARENT = 'G'
#    THERAPIST = 'T'
#    RELATIONSHIP_TYPES = [
#        (PARENT, 'Parent'),
#        (SIBLING, 'Sibling'),
#        (FRIEND, 'Friend'),
#        (GRANDPARENT, 'Grandparent'),
#        (THERAPIST, 'Therapist'),
#    ]
#    relationship = models.CharField(
#        max_length=1,
#        choices=RELATIONSHIP_TYPES,
#    )


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
    speaker = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
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
