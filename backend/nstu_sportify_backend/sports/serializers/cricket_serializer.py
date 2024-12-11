from rest_framework import serializers
from ..models import Cricket

class CricketSerializer(serializers.ModelSerializer):
    team1_name = serializers.CharField(source='match.team1.name', read_only=True)
    team2_name = serializers.CharField(source='match.team2.name', read_only=True)
    match_date = serializers.DateField(source='match.date', read_only=True)

    class Meta:
        model = Cricket
        fields = [
            'cricket_match_id',
            'overs',
            'runs_team1',
            'runs_team2',
            'wickets_team1',
            'wickets_team2',
            'match',
            'team1_name',
            'team2_name',
            'match_date'
        ]
