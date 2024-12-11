from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import status
from ..models import RepresentativeRequest, Representative, CustomUser
from ..serializers import RepresentativeRequestSerializer
from ..permission import IsAdminOrReadOnly
from rest_framework.permissions import AllowAny
from rest_framework.permissions import IsAuthenticated, IsAdminUser

class RepresentativeRequestViewSet(viewsets.ModelViewSet):
    queryset = RepresentativeRequest.objects.all()
    serializer_class = RepresentativeRequestSerializer
    permission_classes = [IsAdminOrReadOnly]

    def get_permissions(self):
        if self.action == 'create':
            return [AllowAny()]
        return super().get_permissions()

    @action(detail=True, methods=['post'], permission_classes=[IsAdminUser])
    def approve_request(self, request, pk=None):
        try:
            print(f"Method: {request.method}, Path: {request.path}")
            rep_request = self.get_object()
            print(f"Request ID: {rep_request.id}, Status: {rep_request.status}")

            if rep_request.status != 'pending':
                return Response({"detail": "This request has already been processed."}, status=status.HTTP_400_BAD_REQUEST)

            Representative.objects.create(
                name=rep_request.name,
                email=rep_request.email,
                department=rep_request.department,
            )
            CustomUser.objects.create_user(
                username=rep_request.name,
                email=rep_request.email,
                password="12345",  # Replace with secure generation
                is_representative=True
            )

            rep_request.status = 'approved'
            rep_request.save()
            return Response({"detail": "Request approved successfully."}, status=status.HTTP_200_OK)

        except Exception as e:
            print(f"Error: {e}")
            return Response({"detail": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['post'], permission_classes=[IsAdminUser])
    def reject_request(self, request, pk=None):
        """
        Reject a pending representative request.
        """
        try:
            rep_request = self.get_object()
            if rep_request.status != 'pending':
                return Response({"detail": "This request has already been processed."}, status=status.HTTP_400_BAD_REQUEST)

            rep_request.status = 'rejected'
            rep_request.save()
            return Response({"detail": "Request rejected."}, status=status.HTTP_200_OK)

        except Exception as e:
            print(f"Error: {e}")
            return Response({"detail": str(e)}, status=status.HTTP_400_BAD_REQUEST)
