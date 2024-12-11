from rest_framework import serializers
from ..models import Chess

class ChessSerializer(serializers.ModelSerializer):
    class Meta:
        model = Chess
        fields = '__all__'
