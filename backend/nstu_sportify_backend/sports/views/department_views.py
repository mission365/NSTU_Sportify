from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Department
from ..serializers import DepartmentSerializer
from ..permission import IsAdminOrReadOnly

class DepartmentViewSet(viewsets.ModelViewSet):
    queryset = Department.objects.all()
    serializer_class = DepartmentSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]
