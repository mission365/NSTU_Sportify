from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Carom
from ..serializers import CaromSerializer
from ..permission import IsRepresentativeOrReadOnly

class CaromViewSet(viewsets.ModelViewSet):
    queryset = Carom.objects.all()
    serializer_class = CaromSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]
