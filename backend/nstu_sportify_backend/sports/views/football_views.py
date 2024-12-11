from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Football
from ..serializers import FootballSerializer
from ..permission import IsRepresentativeOrReadOnly

class FootballViewSet(viewsets.ModelViewSet):
    queryset = Football.objects.all()
    serializer_class = FootballSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]
