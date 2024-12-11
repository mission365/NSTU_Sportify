from django.db import models
from django.contrib.auth.models import AbstractUser
class Department(models.Model):
    department_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class CustomUser(AbstractUser):
    is_representative = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    department = models.ForeignKey(
        Department, on_delete=models.SET_NULL, null=True, blank=True
    )
    def save(self, *args, **kwargs):
        if self.is_admin:
            self.is_staff = True
        super().save(*args, **kwargs)
    def __str__(self):
        return self.username

class Representative(models.Model):
    representative_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    email = models.EmailField()
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    def __str__(self):
        return self.name
class Team(models.Model):
    SPORTS_CHOICES = [
        ('football', 'Football'),
        ('cricket', 'Cricket'),
        ('chess', 'Chess'),
        ('handball', 'Handball'),
        ('carom', 'Carom'),
    ]
    team_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    coach = models.CharField(max_length=100)
    representative = models.ForeignKey(Representative, on_delete=models.CASCADE)
    players = models.ManyToManyField('Player', related_name='teams', blank=True)
    sport = models.CharField(max_length=50, choices=SPORTS_CHOICES)
    def __str__(self):
        return f"{self.name} ({self.get_sport_display()})"
class Player(models.Model):
    player_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    age = models.IntegerField()
    position = models.CharField(max_length=50)

    def __str__(self):
        return self.name
class Event(models.Model):
    event_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=200)
    description = models.TextField()
    start_date = models.DateField()
    end_date = models.DateField()

    def __str__(self):
        return self.title
class Matchdetails(models.Model):
    SPORTS_CHOICES = [
        ('football', 'Football'),
        ('cricket', 'Cricket'),
        ('chess', 'Chess'),
        ('handball', 'Handball'),
        ('carom', 'Carom'),
    ]
    match_id = models.AutoField(primary_key=True)
    date = models.DateField()
    location = models.CharField(max_length=200)
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    team1 = models.ForeignKey(Team, related_name='team1_matches', on_delete=models.CASCADE)
    team2 = models.ForeignKey(Team, related_name='team2_matches', on_delete=models.CASCADE)
    sport = models.CharField(max_length=50, choices=SPORTS_CHOICES, default='football')
    def __str__(self):
        return f"{self.team1} vs {self.team2} ({self.get_sport_display()}) on {self.date} at {self.location}"
class Carom(models.Model):
    carom_match_id = models.AutoField(primary_key=True)
    rounds = models.IntegerField()
    points_team1 = models.IntegerField()
    points_team2 = models.IntegerField()
    match = models.ForeignKey(Matchdetails, on_delete=models.CASCADE)

    def __str__(self):
        return f"Carom Match {self.carom_match_id}"
class Handball(models.Model):
    handball_match_id = models.AutoField(primary_key=True)
    duration = models.IntegerField()  # in minutes
    goals_team1 = models.IntegerField()
    goals_team2 = models.IntegerField()
    match = models.ForeignKey(Matchdetails, on_delete=models.CASCADE)

    def __str__(self):
        return f"Handball Match {self.handball_match_id}"
class Chess(models.Model):
    chess_match_id = models.AutoField(primary_key=True)
    duration = models.IntegerField()  # in minutes
    moves = models.IntegerField()
    match = models.ForeignKey(Matchdetails, on_delete=models.CASCADE)

    def __str__(self):
        return f"Chess Match {self.chess_match_id}"
class Football(models.Model):
    football_match_id = models.AutoField(primary_key=True)
    duration = models.IntegerField()  # in minutes
    goals_team1 = models.IntegerField()
    goals_team2 = models.IntegerField()
    match = models.ForeignKey(Matchdetails, on_delete=models.CASCADE)

    def __str__(self):
        return f"Football Match {self.football_match_id}"
class Cricket(models.Model):
    cricket_match_id = models.AutoField(primary_key=True)
    overs = models.IntegerField()
    runs_team1 = models.IntegerField()
    runs_team2 = models.IntegerField()
    wickets_team1 = models.IntegerField()
    wickets_team2 = models.IntegerField()
    match = models.ForeignKey(Matchdetails, on_delete=models.CASCADE)

    def __str__(self):
        return f"Cricket Match {self.cricket_match_id}"
class Livescore(models.Model):
    score_id = models.AutoField(primary_key=True)
    score = models.IntegerField()
    match = models.ForeignKey(Matchdetails, on_delete=models.CASCADE)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)

    def __str__(self):
        return f"Livescore for match {self.match.match_id}"
class Result(models.Model):
    result_id = models.AutoField(primary_key=True)
    match = models.ForeignKey(Matchdetails, on_delete=models.CASCADE)
    winner_team = models.ForeignKey(Team, related_name='winner_team', on_delete=models.CASCADE)
    loser_team = models.ForeignKey(Team, related_name='loser_team', on_delete=models.CASCADE)
    draw = models.BooleanField(default=False)

    def __str__(self):
        return f"Result of match {self.match.match_id}"
class Standing(models.Model):
    standing_id = models.AutoField(primary_key=True)
    position = models.IntegerField()
    team = models.ForeignKey(Team, on_delete=models.CASCADE)
    event = models.ForeignKey(Event, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.team.name} position {self.position} in event {self.event.title}"
class Notice(models.Model):
    notice_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    content = models.TextField()
    posted_date = models.DateField()
    event = models.ForeignKey(Event, on_delete=models.CASCADE)

    def __str__(self):
        return self.title

class RepresentativeRequest(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
    ]

    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} ({self.get_status_display()})"

class TournamentWinner(models.Model):
    year = models.IntegerField()
    sport = models.CharField(max_length=50, choices=Team.SPORTS_CHOICES)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)
    class Meta:
        unique_together = ('year', 'sport')
    def __str__(self):
        return f"{self.team.name} - {self.sport} ({self.year})"
