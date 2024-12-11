from django.contrib import admin
from .models import *
from .models import CustomUser

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'is_staff', 'is_admin', 'is_representative')
    list_filter = ('is_staff', 'is_admin', 'is_representative')
    search_fields = ('username', 'email')
    fields = ('username', 'email', 'password', 'is_staff', 'is_admin', 'is_representative')
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'password1', 'password2', 'is_admin', 'is_representative'),
        }),
    )

@admin.register(Team)
class TeamAdmin(admin.ModelAdmin):
    list_display = ('name', 'coach', 'representative')
    filter_horizontal = ('players',)
    list_filter = ('sport',)

@admin.register(Player)
class PlayerAdmin(admin.ModelAdmin):
    list_display = ('name', 'age', 'position')

@admin.register(Representative)
class RepresentativeAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'department')

@admin.register(Matchdetails)
class MatchdetailsAdmin(admin.ModelAdmin):
    list_display = ('match_id', 'date', 'location', 'sport', 'event')
    list_filter = ('sport', 'date')
    search_fields = ('location', 'event__title')

admin.site.register(Department)
admin.site.register(Event)
admin.site.register(Carom)
admin.site.register(Handball)
admin.site.register(Chess)
admin.site.register(Football)
admin.site.register(Cricket)
admin.site.register(Livescore)
admin.site.register(Result)
admin.site.register(Standing)
admin.site.register(Notice)
admin.site.register(TournamentWinner)
