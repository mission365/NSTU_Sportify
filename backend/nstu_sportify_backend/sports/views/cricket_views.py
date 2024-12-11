from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Cricket
from ..serializers import CricketSerializer
from ..permission import IsRepresentativeOrReadOnly

class CricketViewSet(viewsets.ModelViewSet):
    queryset = Cricket.objects.all()
    serializer_class = CricketSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]
