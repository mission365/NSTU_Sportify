from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from ..models import Matchdetails
from ..serializers import MatchdetailsWithTeamsSerializer
from ..permission import IsAdminOrReadOnly

class CaromMatchesAPIView(APIView):
    def get_permissions(self):
        if self.request.method in ['POST', 'PUT', 'PATCH', 'DELETE']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]

    def get(self, request):
        carom_matches = Matchdetails.objects.filter(sport='carom')
        serializer = MatchdetailsWithTeamsSerializer(carom_matches, many=True)
        return Response(serializer.data)
