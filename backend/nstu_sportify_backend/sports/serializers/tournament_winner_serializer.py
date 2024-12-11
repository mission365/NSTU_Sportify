from rest_framework import serializers
from ..models import TournamentWinner, Team

class TournamentWinnerSerializer(serializers.ModelSerializer):
    team_id = serializers.IntegerField(write_only=True)

    class Meta:
        model = TournamentWinner
        fields = ['id', 'year', 'sport', 'team_id', 'team']
        extra_kwargs = {'team': {'read_only': True}}

    def create(self, validated_data):
        team_id = validated_data.pop('team_id')
        validated_data['team'] = Team.objects.get(pk=team_id)
        return super().create(validated_data)
