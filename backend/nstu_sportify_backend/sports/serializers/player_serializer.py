from rest_framework import serializers
from ..models import Player, Team

class PlayerSerializer(serializers.ModelSerializer):
    sport = serializers.CharField(source='team.sport', read_only=True)  # Add sport field from related Team

    class Meta:
        model = Player
        fields = '__all__'
