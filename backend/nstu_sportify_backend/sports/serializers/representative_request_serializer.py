from rest_framework import serializers
from ..models import RepresentativeRequest, Department

class RepresentativeRequestSerializer(serializers.ModelSerializer):
    department_name = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = RepresentativeRequest
        fields = ['id', 'name', 'email', 'department', 'department_name', 'status', 'created_at']
        read_only_fields = ['department', 'status', 'created_at']

    def create(self, validated_data):
        department_name = validated_data.pop('department_name', None)

        try:
            department = Department.objects.get(name=department_name)
        except Department.DoesNotExist:
            raise serializers.ValidationError({"department_name": "Department not found."})

        validated_data['department'] = department
        return super().create(validated_data)
