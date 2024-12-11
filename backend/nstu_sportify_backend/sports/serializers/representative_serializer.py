from rest_framework import serializers
from ..models import Representative

class RepresentativeSerializer(serializers.ModelSerializer):
    department_name = serializers.CharField(source='department.name', read_only=True)  # Fetch department name

    class Meta:
        model = Representative
        fields = ['representative_id', 'name', 'email', 'department_name']  # Include department_name instead of department_id
