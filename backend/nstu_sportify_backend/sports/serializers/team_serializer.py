from rest_framework import serializers
from ..models import Team
from .player_serializer import PlayerSerializer

class TeamSerializer(serializers.ModelSerializer):
    players = PlayerSerializer(many=True, read_only=True)  # Include player details in the response

    class Meta:
        model = Team
        fields = ['team_id', 'name', 'coach', 'representative_id', 'players', 'sport']
