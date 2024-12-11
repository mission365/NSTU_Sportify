from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Handball
from ..serializers import HandballSerializer
from ..permission import IsRepresentativeOrReadOnly

class HandballViewSet(viewsets.ModelViewSet):
    queryset = Handball.objects.all()
    serializer_class = HandballSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]
