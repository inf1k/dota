# Dota [![Gem Version](https://badge.fury.io/rb/dota.svg)](http://badge.fury.io/rb/dota) [![Build Status](https://travis-ci.org/vinnicc/dota.svg?branch=master)](https://travis-ci.org/vinnicc/dota)

`dota` is a Ruby client for the [Dota 2 WebAPI](https://wiki.teamfortress.com/wiki/WebAPI#Dota_2). It provides an easy way to access matches, players, heroes, items, and other public Dota 2 objects in an opinionated manner.

Currently supported endpoints:

- [GetMatchDetails](https://wiki.teamfortress.com/wiki/WebAPI/GetMatchDetails)
- [GetMatchHistory](https://wiki.teamfortress.com/wiki/WebAPI/GetMatchHistory)
- [GetRarities](https://wiki.teamfortress.com/wiki/WebAPI/GetRarities)
- [GetHeroes](https://wiki.teamfortress.com/wiki/WebAPI/GetHeroes)
- GetGameItems

This gem is in alpha, keep that in mind when upgrading.

## TODO

- Support for more endpoints
  - [GetFriendList](https://wiki.teamfortress.com/wiki/WebAPI/GetFriendList)
  - [GetLiveLeagueGames](https://wiki.teamfortress.com/wiki/WebAPI/GetLiveLeagueGames)
  - [GetMatchHistoryBySequenceNum](https://wiki.teamfortress.com/wiki/WebAPI/GetMatchHistoryBySequenceNum)
  - [GetPlayerSummaries](https://wiki.teamfortress.com/wiki/WebAPI/GetPlayerSummaries)
  - [GetScheduledLeagueGames](https://wiki.teamfortress.com/wiki/WebAPI/GetScheduledLeagueGames)
  - [GetTeamInfoByTeamID](https://wiki.teamfortress.com/wiki/WebAPI/GetTeamInfoByTeamID)
  - [GetTournamentPlayerStats](https://wiki.teamfortress.com/wiki/WebAPI/GetTournamentPlayerStats)
  - [GetTournamentPrizePool](https://wiki.teamfortress.com/wiki/WebAPI/GetTournamentPrizePool)
- Validations and error classes
- More configuration options
- Move API documentation to [readthedocs.org](https://readthedocs.org/) or somewhere else
- Better search filters
- Computed attributes such as win rates, hero usage, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dota'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dota

## Usage

```ruby
Dota.configure do |config|
  config.api_key = "YOUR_STEAM_API_KEY"
end
```

Get your Steam API key [here](http://steamcommunity.com/dev/apikey).

```ruby
api = Dota.api

api.heroes(43)           # (Cached) A single hero - Death Prophet
api.heroes               # (Cached) All heroes

api.items(114)           # (Cached) A single item - Heart of Tarrasque
api.items                # (Cached) All items

api.cosmetic_rarities    # All cosmetic rarities

api.leagues              # All leagues

api.matches(789645621)   # A single match - Newbee vs Vici Gaming
api.matches              # A list of matches
api.matches(hero_id: 43) # Allowed options:
                         #
                         #   :hero_id     - Integer, With this hero. See Dota::API::Hero::MAPPING
                         #   :after       - Integer, With match ids equal to greater than this
                         #   :player_id   - Integer, With this player (Steam ID)
                         #   :league_id   - Integer, In this league. Use Dota.leagues to get a list of leagues
                         #   :mode_id     - Integer, In this game mode. See Dota::API::Match::MODES
                         #   :skill_level - Integer, In this skill level (ignored if :player_id is provided). See Dota::API::Match::SKILL_LEVELS
                         #   :from        - Integer, Minimum timestamp
                         #   :to          - Integer, Maximum timestamp
                         #   :min_players - Integer, With at least this number of players
                         #   :league_only - Boolean, Only league matches
                         #   :limit       - Integer, Amount of matches to return (default is 100)
```

#### Custom Requests

For the unsupported endpoints, you can use `api.get`. The following code is similar to `api.matches(789645621)` except that it returns the raw JSON response.

```ruby
api.get("IDOTA2Match_570", "GetMatchDetails", match_id: 789645621)
```

### API Objects

#### Heroes

```ruby
hero.id        # => 43
hero.name      # => "Death Prophet"
hero.image_url # => "http://cdn.dota2.com/apps/dota2/images/heroes/death_prophet_full.png"
```

#### Items

```ruby
item.id        # => 114
item.name      # => "Heart of Tarrasque"
item.image_url # => "http://cdn.dota2.com/apps/dota2/images/items/heart_lg.png"
```

#### Leagues

```ruby
league.id          # => 600
league.name        # => "The International 2014"
league.description # => "The Aegis of Champions hangs in the balance. See the world's top teams battle in the International."
league.url         # => "http://www.dota2.com/international/overview/"
```

#### Matches

Caveat: Getting a list of matches via `api.matches` will call [GetMatchHistory](https://wiki.teamfortress.com/wiki/WebAPI/GetMatchHistory) which has very few attributes for the matches returned (obviously for performance reasons), as opposed to getting info about a particular match via `api.matches(id)` which will instead call [GetMatchDetails](https://wiki.teamfortress.com/wiki/WebAPI/GetMatchDetails). In both cases, the matches returned will be instances of `Dota::API::Match`. In the future, there will be subclasses to distinguish the two.

When an instance method in a `Dota::API::Match` class returns `nil`, it most likely means the endpoint called doesn't provide it yet.

```ruby
match.id                      # => 789645621
match.league_id               # => 600
match.type                    # => "Tournament"
match.type_id                 # => 2
match.mode                    # => "Captain's Mode"
match.mode_id                 # => 2
match.drafts                  # => [Dota::API::Match::Draft, ...]
match.players                 # => [Dota::API::Match::Player, ...]
match.sequence                # => 709365483
match.starts_at               # => 2014-07-21 20:12:50 UTC
match.duration                # => 908
match.winner                  # => :radiant
match.first_blood             # => 33
match.positive_votes          # => 34701
match.negative_votes          # => 13291
match.season                  # => nil
match.players_count           # => 10
match.cluster                 # => 111
match.radiant_tower_status    # => 2039
match.dire_tower_status       # => 1974
match.radiant_barracks_status # => 63
match.dire_barracks_status    # => 63
```

#### Players

```ruby
player.id           # => 98887913
player.hero         # => Dota::API::Hero
player.items        # => [Dota::API::Item, ...]
player.slot         # => 0
player.status       # => :played
player.level        # => 11
player.kills        # => 2
player.deaths       # => 1
player.assists      # => 13
player.last_hits    # => 45
player.denies       # => 0
player.gold         # => 649
player.gold_spent   # => 6670
player.gpm          # => 437
player.xpm          # => 460
player.hero_damage  # => 3577
player.tower_damage # => 153
player.hero_healing # => 526
```

#### Drafts

```ruby
draft.order # => 1
draft.pick? # => true
draft.team  # => :radiant
draft.hero  # => Dota::API::Hero
```

#### Cosmetic Rarities

```ruby
rarity.id    # => 1
rarity.order # => 0
rarity.color # => "#e4ae39"
rarity.name  # => "Immortal"
```

## Contributing

1. [Fork it!](https://github.com/vinnicc/dota/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
