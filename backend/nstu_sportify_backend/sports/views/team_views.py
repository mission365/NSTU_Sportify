from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from django.core.exceptions import PermissionDenied
from ..models import Team, Player, Representative
from ..serializers import TeamSerializer
from ..permission import IsRepresentativeOrReadOnly

class TeamViewSet(viewsets.ModelViewSet):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy', 'add_player', 'remove_player']:
            return [IsRepresentativeOrReadOnly()]
        return [AllowAny()]

    def perform_create(self, serializer):
        user = self.request.user
        if user.is_authenticated and user.is_representative:
            try:
                representative = Representative.objects.get(name=user.username)
                serializer.save(representative=representative)
            except Representative.DoesNotExist:
                raise PermissionDenied("You are not associated with any representative profile.")
        else:
            raise PermissionDenied("Only representatives can create teams.")

    @action(detail=False, methods=['post'], url_path=r'(?P<team_name>[^/.]+)/add_player', permission_classes=[IsRepresentativeOrReadOnly])
    def add_player(self, request, team_name=None):
        try:
            team = get_object_or_404(Team, name=team_name)
            if team.representative.name != request.user.username:
                raise PermissionDenied(f"You can only add players to your own teams. This team is owned by {team.representative.name}, but you are logged in as {request.user.username}.")
            player_id = request.data.get('player_id')
            if not player_id:
                return Response({"detail": "Player ID is required."}, status=400)
            player = Player.objects.get(pk=player_id)
            team.players.add(player)
            return Response({"detail": f"Player {player.name} added to team {team.name} successfully."}, status=200)
        except Player.DoesNotExist:
            return Response({"detail": "Player not found."}, status=404)
        except Exception as e:
            return Response({"detail": str(e)}, status=400)

    @action(detail=False, methods=['post'], url_path=r'(?P<team_name>[^/.]+)/remove_player', permission_classes=[IsRepresentativeOrReadOnly])
    def remove_player(self, request, team_name=None):
        try:
            team = get_object_or_404(Team, name=team_name)
            if team.representative.name != request.user.username:
                raise PermissionDenied(f"You can only remove players from your own teams. This team is owned by {team.representative.name}, but you are logged in as {request.user.username}.")
            player_id = request.data.get('player_id')
            if not player_id:
                return Response({"detail": "Player ID is required."}, status=400)
            player = Player.objects.get(pk=player_id)
            if player in team.players.all():
                team.players.remove(player)
                return Response({"detail": f"Player {player.name} removed from team {team.name} successfully."}, status=200)
            else:
                return Response({"detail": "Player not found in the team."}, status=404)
        except Player.DoesNotExist:
            return Response({"detail": "Player not found."}, status=404)
        except Exception as e:
            return Response({"detail": str(e)}, status=400)

    @action(detail=False, methods=['get'], permission_classes=[IsRepresentativeOrReadOnly])
    def owned(self, request):
        user = request.user
        if not hasattr(user, 'is_representative') or not user.is_representative:
            raise PermissionDenied("You must be a representative to view your teams.")
        try:
            representative = Representative.objects.get(name=user.username)
        except Representative.DoesNotExist:
            raise PermissionDenied("No representative profile found for the logged-in user.")
        teams = Team.objects.filter(representative=representative)
        serializer = self.get_serializer(teams, many=True)
        return Response(serializer.data)
