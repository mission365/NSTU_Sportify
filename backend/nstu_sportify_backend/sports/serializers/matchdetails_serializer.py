from rest_framework import serializers
from ..models import Matchdetails

class MatchdetailsWithTeamsSerializer(serializers.ModelSerializer):
    team1_name = serializers.CharField(source='team1.name', read_only=True)
    team2_name = serializers.CharField(source='team2.name', read_only=True)
    event_name = serializers.CharField(source='event.title', read_only=True)

    class Meta:
        model = Matchdetails
        fields = ['match_id', 'date', 'location', 'event', 'sport', 'team1', 'team2',
                  'event_name', 'team1_name', 'team2_name']
