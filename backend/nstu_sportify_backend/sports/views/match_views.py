from rest_framework import viewsets
from rest_framework.response import Response
from ..models import Matchdetails
from ..serializers import MatchdetailsWithTeamsSerializer
from ..permission import IsAdminOrReadOnly
from rest_framework.permissions import AllowAny
class MatchdetailsViewSet(viewsets.ModelViewSet):
    queryset = Matchdetails.objects.all()
    serializer_class = MatchdetailsWithTeamsSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid():
            print("Validation Errors:", serializer.errors)
            return Response(serializer.errors, status=400)
        return super().create(request, *args, **kwargs)
