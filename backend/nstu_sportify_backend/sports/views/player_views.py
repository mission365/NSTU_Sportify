from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Player
from ..serializers import PlayerSerializer
from ..permission import IsRepresentativeOrReadOnly

class PlayerViewSet(viewsets.ModelViewSet):
    queryset = Player.objects.all()
    serializer_class = PlayerSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]

    def get_queryset(self):
        sport = self.request.query_params.get('sport')
        if sport:
            return Player.objects.filter(teams__sport=sport).distinct()
        return super().get_queryset()
