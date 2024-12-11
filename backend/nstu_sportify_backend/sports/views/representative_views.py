from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Representative
from ..serializers import RepresentativeSerializer
from ..permission import IsRepresentativeOrReadOnly

class RepresentativeViewSet(viewsets.ModelViewSet):
    queryset = Representative.objects.all()
    serializer_class = RepresentativeSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]
