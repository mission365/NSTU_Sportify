from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Event
from ..serializers import EventSerializer
from ..permission import IsAdminOrReadOnly

class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]
