from rest_framework import viewsets
from rest_framework.response import Response
from ..models import TournamentWinner
from ..serializers import TournamentWinnerSerializer
from ..permission import IsAdminOrReadOnly
from rest_framework import status
from rest_framework.permissions import AllowAny
class TournamentWinnerViewSet(viewsets.ModelViewSet):
    queryset = TournamentWinner.objects.all()
    serializer_class = TournamentWinnerSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]

    def create(self, request, *args, **kwargs):
        print(f"Incoming data: {request.data}")  # Log the received data for debugging
        serializer = self.get_serializer(data=request.data)

        if not serializer.is_valid():
            print(f"Validation errors: {serializer.errors}")  # Log validation errors
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        print("Validated data:", serializer.validated_data)  # Log validated data before saving
        return super().create(request, *args, **kwargs)

    def get_queryset(self):
        year = self.request.query_params.get('year')
        if year:
            return self.queryset.filter(year=year)
        return self.queryset
