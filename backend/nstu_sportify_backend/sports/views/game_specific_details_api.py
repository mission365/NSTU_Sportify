from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from ..models import Matchdetails, Cricket, Football, Chess, Handball, Carom
from ..permission import IsAdminOrReadOnly

class GameSpecificDetailsAPIView(APIView):
    def get_permissions(self):
        if self.request.method in ['POST', 'PUT', 'PATCH', 'DELETE']:
            return [IsAdminOrReadOnly()]
        return [AllowAny()]

    def get(self, request, result_id):
        try:
            match = Matchdetails.objects.get(result__result_id=result_id)
            response_data = {
                "match_date": match.date,
                "location": match.location,
                "team1_name": match.team1.name,
                "team2_name": match.team2.name,
                "sport_type": match.sport
            }

            # Fetch game-specific details
            if match.sport == 'cricket':
                game_details = Cricket.objects.get(match=match)
                response_data.update({
                    "overs": game_details.overs,
                    "runs_team1": game_details.runs_team1,
                    "runs_team2": game_details.runs_team2,
                    "wickets_team1": game_details.wickets_team1,
                    "wickets_team2": game_details.wickets_team2
                })
            elif match.sport == 'football':
                game_details = Football.objects.get(match=match)
                response_data.update({
                    "duration": game_details.duration,
                    "goals_team1": game_details.goals_team1,
                    "goals_team2": game_details.goals_team2
                })
            elif match.sport == 'chess':
                game_details = Chess.objects.get(match=match)
                response_data.update({
                    "duration": game_details.duration,
                    "moves": game_details.moves
                })
            elif match.sport == 'handball':
                game_details = Handball.objects.get(match=match)
                response_data.update({
                    "duration": game_details.duration,
                    "goals_team1": game_details.goals_team1,
                    "goals_team2": game_details.goals_team2
                })
            elif match.sport == 'carom':
                game_details = Carom.objects.get(match=match)
                response_data.update({
                    "rounds": game_details.rounds,
                    "points_team1": game_details.points_team1,
                    "points_team2": game_details.points_team2
                })
            else:
                return Response({"detail": "Sport not supported."}, status=400)

            return Response(response_data)
        except Matchdetails.DoesNotExist:
            return Response({"detail": "Result not found."}, status=404)
        except Exception as e:
            return Response({"detail": str(e)}, status=500)

    def post(self, request, result_id):
        try:
            match = Matchdetails.objects.get(result__result_id=result_id)
            sport = match.sport
            data = request.data

            if sport == 'cricket':
                Cricket.objects.create(
                    match=match,
                    overs=data['overs'],
                    runs_team1=data['runs_team1'],
                    runs_team2=data['runs_team2'],
                    wickets_team1=data['wickets_team1'],
                    wickets_team2=data['wickets_team2']
                )
            elif sport == 'football':
                Football.objects.create(
                    match=match,
                    duration=data['duration'],
                    goals_team1=data['goals_team1'],
                    goals_team2=data['goals_team2']
                )
            elif sport == 'chess':
                Chess.objects.create(
                    match=match,
                    duration=data['duration'],
                    moves=data['moves']
                )
            elif sport == 'handball':
                Handball.objects.create(
                    match=match,
                    duration=data['duration'],
                    goals_team1=data['goals_team1'],
                    goals_team2=data['goals_team2']
                )
            elif sport == 'carom':
                Carom.objects.create(
                    match=match,
                    rounds=data['rounds'],
                    points_team1=data['points_team1'],
                    points_team2=data['points_team2']
                )
            else:
                return Response({"detail": "Sport not supported."}, status=400)

            return Response({"detail": "Game-specific details added successfully."}, status=201)
        except Matchdetails.DoesNotExist:
            return Response({"detail": "Match not found."}, status=404)
        except KeyError as e:
            return Response({"detail": f"Missing required field: {str(e)}"}, status=400)
        except Exception as e:
            return Response({"detail": str(e)}, status=500)
