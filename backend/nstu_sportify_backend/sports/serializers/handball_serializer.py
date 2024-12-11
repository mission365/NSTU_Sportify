from rest_framework import serializers
from ..models import Handball

class HandballSerializer(serializers.ModelSerializer):
    class Meta:
        model = Handball
        fields = '__all__'
