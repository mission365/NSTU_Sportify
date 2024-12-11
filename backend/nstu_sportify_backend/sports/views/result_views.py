from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from ..models import Result
from ..serializers import ResultSerializer
from ..permission import IsAdminOrReadOnly

class ResultViewSet(viewsets.ModelViewSet):
    queryset = Result.objects.all()
    serializer_class = ResultSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]

    def get_queryset(self):
        sport = self.request.query_params.get('sport', None)
        if sport:
            return Result.objects.filter(match__sport=sport)
        return super().get_queryset()

    def create(self, request, *args, **kwargs):
        print("Request data:", request.data)
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        print("Validated data:", serializer.validated_data)
        self.perform_create(serializer)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
