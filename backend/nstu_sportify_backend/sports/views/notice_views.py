from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from ..models import Notice
from ..serializers import NoticeSerializer
from ..permission import IsAdminOrReadOnly

class NoticeViewSet(viewsets.ModelViewSet):
    queryset = Notice.objects.all()
    serializer_class = NoticeSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]
