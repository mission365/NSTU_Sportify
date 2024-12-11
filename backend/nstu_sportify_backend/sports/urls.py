from django.urls import include, path
from rest_framework.routers import DefaultRouter
from .views import *
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
router = DefaultRouter()
router.register(r'departments', DepartmentViewSet)
router.register(r'representatives', RepresentativeViewSet)
router.register(r'teams', TeamViewSet)
router.register(r'players', PlayerViewSet)
router.register(r'events', EventViewSet)
router.register(r'matchdetails', MatchdetailsViewSet)
router.register(r'carom', CaromViewSet)
router.register(r'handball', HandballViewSet)
router.register(r'chess', ChessViewSet)
router.register(r'football', FootballViewSet)
router.register(r'cricket', CricketViewSet)
router.register(r'results', ResultViewSet)
router.register(r'notices', NoticeViewSet)
router.register(r'representative-requests', RepresentativeRequestViewSet)
router.register(r'tournament-winners', TournamentWinnerViewSet)


urlpatterns = [
    path('api/', include(router.urls)),
    path('api/matches/cricket/', CricketMatchesAPIView.as_view(), name='cricket-matches'),
    path('api/matches/football/', FootballMatchesAPIView.as_view(), name='football-matches'),
    path('api/matches/chess/', ChessMatchesAPIView.as_view(), name='chess-matches'),
    path('api/matches/handball/', HandballMatchesAPIView.as_view(), name='handball-matches'),
    path('api/matches/carom/', CaromMatchesAPIView.as_view(), name='carom-matches'),
    path('api/result/<int:result_id>/details/', GameSpecificDetailsAPIView.as_view(), name='game-specific-details'),
    path('register/', CustomUserCreateView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('user/', UserDetailsView.as_view(), name='user_details'),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
]
