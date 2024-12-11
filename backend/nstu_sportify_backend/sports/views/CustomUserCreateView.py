from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.permissions import AllowAny
from ..serializers import CustomUserSerializer

class CustomUserCreateView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = CustomUserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "User created successfully!"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LoginView(TokenObtainPairView):
    pass

class UserDetailsView(APIView):
    def get(self, request):
        user = request.user
        if user.is_authenticated:
            return Response({
                "username": user.username,
                "email": user.email,
                "is_representative": user.is_representative,
                "is_admin": user.is_admin,
            })
        return Response({"detail": "Unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
