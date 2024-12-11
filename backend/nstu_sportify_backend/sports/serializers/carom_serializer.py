from rest_framework import serializers
from ..models import Carom

class CaromSerializer(serializers.ModelSerializer):
    class Meta:
        model = Carom
        fields = '__all__'
