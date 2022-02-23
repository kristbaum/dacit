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
    ci_user = models.ForeignKey(CI_User, on_delete=models.CASCADE)
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


class Audio(models.Model):
    speaker = models.ForeignKey(Speaker, on_delete=models.CASCADE)
    audio = models.FileField(upload_to='audio')
    language = models.CharField(max_length=2)
    dicalect = models.CharField(max_length=100)

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
