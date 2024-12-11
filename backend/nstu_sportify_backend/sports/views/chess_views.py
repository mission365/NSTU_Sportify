from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Chess
from ..serializers import ChessSerializer
from ..permission import IsRepresentativeOrReadOnly

class ChessViewSet(viewsets.ModelViewSet):
    queryset = Chess.objects.all()
    serializer_class = ChessSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]
