from rest_framework import serializers
from ..models import Result, Team

class ResultSerializer(serializers.ModelSerializer):
    winner_team_name = serializers.CharField(source='winner_team.name', read_only=True)
    loser_team_name = serializers.CharField(source='loser_team.name', read_only=True)
    match_date = serializers.DateField(source='match.date', read_only=True)
    sport_type = serializers.CharField(source='match.sport', read_only=True)

    class Meta:
        model = Result
        fields = [
            'result_id',
            'match',
            'match_date',
            'sport_type',
            'winner_team',
            'winner_team_name',
            'loser_team',
            'loser_team_name',
            'draw',
        ]
