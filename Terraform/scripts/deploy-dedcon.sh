#!/bin/bash
echo "Installing x86 prereqs"
dpkg --add-architecture i386
apt-get update
apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386

echo "Creating dedcon user"
adduser --system dedcon

echo "Downloading Dedcon"
wget -O dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2 https://dedcon.simamo.de/bin/dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2

echo "Extracting Dedcon"
tar -xjf dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2 -C /usr/local/bin

cd /usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0

echo "Creating game server config file"
cat > ConfigFile << EOF
ServerName ${server_name}

# Settings and commands are usually case sensitive. You can make the lookup of a command
# case insensitive by setting the following to 0:
CaseSensitive 1

# The following numeric options determine whether your server should be made known on
# the Internet or your LAN. 0 means no, 1 means yes.
AdvertiseOnInternet 0
AdvertiseOnLAN 1

# The following numeric option determines the game mode.
GameMode ${gamemode}
# The possilbe values are (the names are also accepted):
# 0 for Default
# 1 for OfficeMode   : real time speed only
# 2 for SpeedDefcon  : 20x speed only
# 3 for Diplomacy    : survivor scoring, everyone starts in the same alliance
# 4 for BigWorld     : double unit counts
# 5 for Tournament   : Default with a minimum of 10 allowed spectators and more locked settings
# 6 for Custom       : All settings unlocked

# Note that depending on the game mode you set, certain of the following options are
# locked to special values, exactly as a regular server would handle them. You can
# bypass this locking by setting IgnoreLimits to 1. It is recommended you pick the custom
# game mode instead.

# The maximal number of players can be set with
MaxTeams ${max_players}

# The number of countries controlled by each player is set by
TerritoriesPerTeam  ${territories_per_player}

# The number of cities in each country is
CitiesPerTerritory ${cities_per_territory}

# The population of each country, given in millions, is
PopulationPerTerritory ${population_per_territory}

# The way population is distributed around the cities
CityPopulations ${city_population_mode}
# Values
# 0 for Default: take populations from rough real world data
# 1 for Equalised: every city gets the same amount of people
# 2 for Random: people are distributed randomly around the first cities in the database
# 3 for TotallyRandom: like Random, but the cities picked will also be random

# Enable or disable random distributions of territories to players here. 1 activates it.
RandomTerritories ${random_territories}

# Should alliances be allowed to form and break during the game? 1 for yes, 0 for no.
PermitDefection 1

# How radar coverage is shared between players.
RadarSharing 1
# 0 for AlwaysOff: no radar sharing ever
# 1 for Alliance: automatically share radar with all allies
# 2 for Selective: pick your own friends
# 3 for AlwaysOn: see everything all of the time

# The game speed can be fixed to certain values here.
GameSpeed 0
# 0 for Slowest Requested
# 1 for Real Time
# 2 for 5x Real Time
# 3 for 10x Real Time
# 4 for 20x Real Time

# if the speed is set to "Slowest Requested", set the slowest allowed speed here.
SlowestSpeed 1
# 0 for Pause
# 1 for Real Time
# 2 for 5x Real Time
# 3 for 10x Real Time
# 4 for 20x Real Time
# 5 for 50x Real Time  (only with CheckLimits off)
# 6 for 100x Real Time (only with CheckLimits off)
# anything larger: 255, beware, speed factors > 100 will make nukes "miss" their target.
# The values avove 5 are very dangerous and need to be set after the game has started. If you do it
# earlier and people check out the advanced options, their game crashes.

# the score mode, how do kills affect your ranking?
ScoreMode ${score_mode}
# 0 for Default: +2 for kills, -1 for deaths
# 1 Survivor: +1 for survivors
# 2 Genocide: +2 for kills

# If the number of nukes left in the game falls below this percentage of the total
# number at the start of the game, the victory timer is started.
VictoryTrigger  20

# And then the victory timer will run for this many minutes of game time.
VictoryTimer    45

# After this many minutes of real time, the game is ended, too. 0 means no limit.
MaxGameRealTime 0

# Set to 1 to enable credits mode where players can pick how many units of the various
# types they want to place.
VariableUnitCounts 0

# A multiplier that affects unit counts and ranges.
WorldScale 100

# Set to 0 to make spectator chat invisible to players.
SpectatorChatChannel 1

# Set to 1 to allow everyone to control all units in the game. If you do so,
# players will be warned about it.
TeamSwitching 0

# The maximal number of allowed spectators. Or rather, since you can't say at
# connection time whether a client will be a spectator or player, the total
# number of clients is at most MaxSpectators + MaxTeams. Only after the game
# has started, new connections will be denied if the number of spectators
# is already MaxSpectators or larger.
MaxSpectators 3
# Nobody will ever get kicked if you change MaxSpectators or MaxTeams
# or when the game starts and it turns out too many spectators are present.
# Only new logins will be denied. In order not to confuse the metaserver,
# clients or players, the reported maximal spectator count in the server
# browsers will be adapted to reality and occasionally be bigger than what
# you set here.

# Password-protect your server with this setting.
#ServerPassword secret

###########################################################################################
## Extended game options
###########################################################################################

# Dedcon adds a couple of options to that.

# Into the server name as it is advertised on the network, you can include the names
# of players that are online. The following setting determines the maximal number
# of names that will be included, more players will be indicated with an ellipsis.
AdvertisePlayers 0

# Single players that enter your server and start a game without other players can be a problem.
# To counter that, the following option can be used to set the minimum number of players
# that need to be in the game before they are allowed to start it. 2 is the default.
MinTeams 2

# The critical mods run by the server. The mods don't actually have to be installed anywhere
# on the server, but they need to be installed on all clients that want to join.
ServerMods
# The format is a semicolon-separated list, stating alteratingly the mod and the version. For
# example, to play with xander's Sailable Pluss mod version 1.0, use
#ServerMods Sailable Pluss;1.0;
# The semicolon at the end is required.
# This setting must be in the config file before any Wait command and changing it over the admin
# interface has no effect.

# You can forbid placing each type of unit, useful for crazy game modes.
ForbidRadar 0
ForbidSilo 0
ForbidAirbase 0
ForbidSubmarine 0
ForbidBattleship 0
ForbidCarrier 0

#> NEW
# You can also disable changing the ceasefire state manually (allies
# will be unaffected, of course) by setting this to 1:
ForbidCeaseFire 0
#< NEW

# Dedcon supports a slowdown budget, meaning that the amount of time players 
# can slow the game down can be limited according to various rules. Every 
# player gets a budget that is used up whenever he/she is in the group 
# requesting the slowest speed and thus determines the speed that is used.
# The budget everyone starts start with is determined by
SlowBudgetStart 300
# The maximal budget that can accumulate is
SlowBudgetMax 600
# The units for both numbers are seconds of real time.

# For every second of real time, the slowdown budget of every player gets 
# a refill, whether it is currently used or not. The refill rate can be 
# set with
SlowBudgetRefill 5
# It's in percent, so a refill rate of 100 would give you 1 unit of 
# budget every second, and if the usage rates are 100, too, the budget 
# gets meaningless.

# When budget is used up by players, it can be redistributed to the other 
# players who currently would prefer a faster game speed. This setting 
# gives the percentage of budget that gets redistributed. The rest is lost,
# so if the refill rate is 0 and this setting is below 100, nobody will
# be able to slow the game down after a while.
SlowBudgetRedistributeUsed 100

# Likewise, budget that is unused (which means that a player with a maxed 
# out budget receives more budget either via redistribution or refilling)
# can be redistributed to the other players. Again, this is in percent.
SlowBudgetRedistributeUnused 0

# You should either leave SlowBudgetRedistributeUnused at the default 
# of 0 and have a positive SlowBudgetRefill, or set 
# SlowBudgetRedistributeUnused to 100 and have SlowBudgetRefill at 0.
# Having both positive Refill and RedistributeUunsed can enable single
# players to keep the game slower than anyone else wants, and Refill 0
# plus RedistributeUunsed below 100 will enable single players to put 
# the game at a higher speed than anyone else wants.

# Slowing down can have different budget costs depending on the speed 
# mode that is requested. Select the costs with these variables. 
# 100 means that for each realtime second, one budget unit is used up. 
# To enable any effect of the slowdown budget, one or several
# of these variables need to be set to something other than 0.
SlowBudgetUsePause 0
SlowBudgetUseRealtime 0
SlowBudgetUse5x 0
SlowBudgetUse10x 0
# A little math: If you want N (but not N-1) players to be able to permanently
# slow the game down to a certain speed, then pick the use ratio of that
# speed to be the refill rate times N. Non-default example: say you want 
# all other settings at defaults, limit realtime use (pause is disabled
# completely), but allow 5x permanently if three players agree on it; you 
# would then set (since the refill rate is at the default of 5%)
#SlowBudgetUseRealtime 100
#SlowBudgetUse5x 15

# The version the server pretends to be running. Determines which clients think they are
# compatible with it.
ServerVersion 1.42 dedicated

# A semicolon separated list of Defcon versions that are not allowed to play:
NoPlayVersions 
# Users of these versions will be forced to spectator mode. For example,
# uncomment the line below once 1.43 has been declared stable to lock out 
# clients with the ship-over-land bug that this server cannot really fix.
# (1.42 linux already is unaffected, so it's not on that list)
#NoPlayVersions 1.42;1.42 steam;1.42 mac;
# The default is to not lock anyone out.

# Analogously, a semicolon separated list of versions that are not even allowed onto the server.
ForbiddenVersions

# All versions in the following range are considered compatible with this server. All versions
# outside of this range will be blocked. Both limits are included in the range.
#  Empty strings denote no limit. It is safe to assume,
# for example, that future clients incompatible with 1.42 will know that themselves and
# refuse to connect on their own, therefore no upper limit is required.
# The trailing "mac", "linux" or "steam" is removed from the client's version before
# it is compared with these limits, but a trailing "beta1" is not.
MinVersion 1.42
MaxVersion

# For examples, see the various ConfigVersion* -files.

# You can give Dedcon a list of no-go areas for ships. Each no-go area is a rectangle specified
# by the longitude and latitude ranges to exclude. The following list are the areas where, if you
# send ships to them, may cause the ship to go over big chunks of land.
# You can get the coordinates by running this server with LogLevel 3 and searching the output
# for lines beginning with "Navy move". The numbers given there are the target longitude and
# latitude.

# You can exclude the Mediterranean Sea, which shouldn't be reachable according
# to sailable.bmp, with this:
#NavalBlacklist 17 19 35 37

# The blacklists are only applied to commands from clients in the interval between
NavalBlacklistMinVersion
NavalBlacklistMaxVersion
# The comparisons work like for MaxVersion and MinVersion above. Likewise, you can
# exclude some versions from the blacklists with the semicolon separaded list
NavalBlacklistExcludeVersions

# For more examples on the blacklists, see ConfigVersion-1.43.

#> NEW
# You can force the game to start out in specific alliance configurations by
# changing
AllianceSize 0
# away from the default. It gives the number of players in each pre-game alliance.
#AllianceSize 1
# would force everyone into his own alliance for FFA servers,
#AllianceSize 2
#MaxTeams 4
# enfoces 2 vs 2 games,
#AllianceSize 2
#MaxTeams 6
# makes a 2 vs 2 vs 2 game, and finally
#AllianceSize 3
#MaxTeams 6
# generates 3 vs 3. To emulate diplomacy startup in other game modes, use
#AllianceSize 6

# The server also takes care of random territory selection. The following settings
# change the territories that actually make it into a game with a certain number of
# players; they are assinged in order (Territory1 to Territory6) to randomly
# selected alliances. Members of the same alliance will get territories that 
# are next to each other in the list.
Territory1 Random
Territory2 Random
Territory3 Random
Territory4 Random
Territory5 Random
Territory6 Random
# Legal values for each of them:
# Random, None or -1 for random selection
# NA, NorthAmerica or 0 for North America
# SA, SouthAmerica or 1 for South America
# EU, Europe or 2 for Europe
# RU, Russia or 3 for Russia
# AS, Asia or 4 for Asia
# AF, Africa or 5 for Africa

# For example,
#AllianceSize 2
#MaxTeams 4
#Territory1 EU
#Territory2 AF
#Territory3 RU
#Territory4 AS
# Will make the game always Europe + Africa vs. Russia + Asia.
# In games where not every territory will get a player, you can take
# territories out of the random selection by assigning the higher
# TerritoryX variables to them.

# This setting, if activated, sets all players to the slowest allowed speed if
# one of them has difficulties (like a connection drop, or a reconnection, or resyncing).
DropCourtesy 0
# if you set it to a positive number, the speed will not get reduced more
# often than that number. -1 will slow everyone down on every problem.
#< NEW

# This setting is to combat problems with players that go AFK:
IdleTime 300
# After the specified time, the players are made to speed up when in the game.
# To remove idle players from the lobby, the ReadyVote mechanism below
# needs to be used. (0.7 and earlier also removed players for just being
# idle.)

# and if nobody at all gave a command for this many seconds, the game is 
# considered over.
IdleTimeGlobal 7200
# The purpose of this setting is to avoid players who leave their client
# running while they take a vacation to block the server; See the WaitEnd
# usage example how you can force the server to quit/restart then.

# The server will usually stop the game countdown if player slots are free and a new
# potential player is connecting. Here you can control how often that happens.
StopForNewPlayers 3

# Flag indicating whether C2 packets from the clients should be accepted.
# Presently, they are not sanity checked very much and can theoretically 
# be used for cheating, but they are so useful.
AcceptC2 1

# If you don't like demo players, keep them from playing even default games by setting
# this one to 1:
DemoRestricted 0
# To lock them out completely so they cannot even spectate, set it to 2.

#> NEW
# By default, players are not allowed to carry the same name. This is to prevent trouble
# with the /setscore interface and kicks. This setting is responsible:
AllowDuplicateNames 0
# Change it to 1 to allow the paranoia mode where everyone renames to ".".

# To lock them out completely so they cannot even spectate, set it to 1.
#< NEW

# Players with high ping have a tendency to cry "lag" once the game has started and leave
# early. With the following setting, you can keep them out of the game. It's the maximum
# ping a player may have. It is only tested in the lobby, nobody gets kicked later because
# of a too high ping. The unit is milliseconds, one second is the default. You can disable
# the check by setting MaxPing to 0.
MaxPing 1000

# Likewise, players with high packet loss can be locked out. Packet loss
# is measured in percent and therefore goes from 0 to 100 ;) It's not
# exactly the percentage of packets that are lost, but something comparable.
# Only for really high packet loss, the measured packet loss is too low.
MaxPacketLoss 30

# When players are kicked with the /kick admin command, they are forced to spectator mode
# when they rejoin after this many kicks:
KicksToSpectator 2

# And after this many total kicks, they are not allowed to re-enter the server at all.
KicksToBan 3

# For registered players, these bans are based on the player's 
# authentication key. For demo players, the client's IP is used.
# If the kicked player comes back with different demo keys 
# and from different IPs, set DemoRestricted to 1.

# Players can still try to block a server by joining, staying active, but
# refusing to ready up; if a majority of players wants to start the game,
# they are therefore removed to spectator mode. The time delay (in seconds)
# between the majority of players hitting "ready" and the blocking player
# getting removed can be fine tuned with this:
ReadyVoteDelay 120

# The maximal number of players refusing to ready up that will be removed
# together is determined by
ReadyVoteMaxRemove 1

# When that delay is half over, the blocking players receive a friendly
# warning. You can change the warning text with this setting:
#ReadyVoteWarning <warning message, ready up or leave>

# Another way of players to annoy others is to repeatedly abort the countdown.
# The ReadyVote mechanism would stop that eventually, but it's still annoying,
# so the number of times anyone can abort the countdown is limited by
MaxCountdownAborts 5
# Set it to something negative for no limit.

# The same setting also influences how often a player is allowed to leave
# the game to spectator mode and come back.

# As a protection against chat spam, Dedcon throttles player chat down if it exceeds
# a certain threshold. The Threshold is given as the average number of chat lines
# a player is allowed to issue per minute here:
ChatsPerMinute 12
# Setting it to 0 disables the spam protection.

# Likewise, the maximal average number of name changes per hour can be limited with
RenamesPerHour 60
# Setting it to 0 disables the spam protection.

# You may want to control the automatic restarting of the server. The default behavior is
# that the server quits (and hopefully gets restarted by the wrapping script) when all clients
# that were connected to it are gone. This may happen quite early. You can counter that with
MinRunTime 0
# which keeps the server running for at least that many seconds, no matter how many clients
# connect and leave again.
# To make the server quit after a period of time without any activity at all, use
MaxIdleRunTime 0
# this will make the server quit after the specified amount of seconds even if nobody
# connected to it. A value of 0 makes the server run forever. Changing this to a value
# in the range of an hour (3600) is recommended for public internet servers.

# All of these automatic quits happen only when no clients are connected currently, of course.

#> NEW
# If you want to set up a server where players can't recognize each other, set this
# to 1:
Anonymise 0
# Ugly side effect: the name change enforced by this will be sticky and players will
# have to rename back later.
#< NEW

###########################################################################################
## CPUs
###########################################################################################

# You can add a CPU player with the command
#AddCPU <cpu name>
# if you omit the name, it will get a default name.

# You can also simply fill the server with default named CPUs with
#FillWithCPUs

# To kick all CPUs, use
#RemoveCPUs

# The best time to add CPUs is when the game countdown starts. When that happens, the
# value of the setting OnStartCountdown is executed. So, by setting it to
#OnStartCountdown FillWithCPUs
# the server will fill with CPUs once all players hit "ready". The default setting of this
# is to do nothing.
# If you use this, you probably want to kick the CPUs out again if the countdown is aborted;
# for that, use
#OnAbortCountdown RemoveCPUs

# You can make CPUs switch alliances with this:
#CPUAlliance <CPU ID> <Alliance ID>
# CPU ID is a numeric ID of the CPU; Every CPU gets assigned lowest possible
# ID, starting from 0.
# Alliance ID is the numeric ID of the alliance, 0 is for Red, 1 for Green, 2
# for Blue, 3 for Yellow, 4 for Orange and 5 for Turq.

# You can make CPUs select a territory (even when random territories are
# enabled) with this:
#CPUTerritory <CPU ID> <Territory ID>
# CPU ID is the same ID as with CPUAlliance.
# TerritoryID is the numeric ID of the territory; for standard Earth, 0 is
# North America, 1 is South America, 2 is Europe, 3 is Russia, 4 is Asia,
# and 5 Africa.
# The selection is actually a toggle; use multiple CPUTerritory commands
# to assign many territories to a CPU player in multi-territory mode, and
# you can repeat the last CPUTerritory command to make a CPU deselect
# the current territory.

#> NEW
# EVIL HACK, use at your own risk: this command turns all active players into CPU players.
# an inverse command is not poisible, the clients will not accept getting moved back from
# spectator to active play.
#CPUIze

#< NEW


#> NEW
###########################################################################################
## Chat filter
###########################################################################################

# The author does not believe systems like this can actually accomplish 
# anything, but build one anyway :) You can police player chat. The 
# system consists of two parts: Filters searching strings for patterns,
#  and Actions that act on it. 

# A filter has the simple form
#ChatFilter <pattern to recognize>
# On Windows, the pattern is a simple string. In the Unix versions, the 
# pattern can be a regular expression. If you write multiple filters below
# each other, the whole block will act like a single filter recognizing
# any of the patterns. Pattern matching is case insensitive.

# If you want the filter to only catch full words, use
#ChatFilterWord <word to recognize>
# instead. Useful for patterns that are perfectly fine
# if they appear inside words (like ASSign or matsuSHITa).
# The pattern does not need to be a word; instead, it counds
# as a match if the pattern ends lie at word boundaries.
# The pattern "classy lady" would match the chat
# "Your mom is a classy lady."

# After a filter block, you can put an arbitrary number of actions.
# The possible actions are:

#ChatFilterWarn <warning level> <message>
# prints a public message and increases the clients warning level by
# the given number.

#ChatFilterWarnPrivate <warning level> <message>
# prints a private message and increases the clients warning level by
# the given number.

#ChatFilterWarnOnce <warning level> <message>
# prints a public message and increases the clients warning level by
# the given number. The message is only printed the first time any
# player says something matching the filter

#ChatFilterRespond <message>
#ChatFilterRespondPrivate <message>
#ChatFilterRespondOnce <message>
# are equivalent to the Warn actions with warning level zero; they
# just respond to the pattern.

#ChatFilterBlockPrivate <warning level> <message>
# do what the Warn actions do, but also completely block the clients chat.
# (No public message, that would not make sense)

#ChatFilterAbort
# aborts the pattern matching, does not look further.

# and lastly,
#ChatFilterReplace <replacement>
# will replace all occurences of the pattern in the chat line with the
# given replacement.

# The warning level of a client can have consequences. If you set
# these thresholds to something bigger than 0 and a client reaches
# that warning level, something nasty happens to him:
ChatFilterSilence 0
# silences the player,
ChatFilterKick 0
# kicks the player and
ChatFilterGrief 0
# makes a log entry in the grief log.

# Example:
# Replace "fuck" and "fcuk" with "f**k" and warn the player privately:
#ChatFilterWord fcuk
#ChatFilterWord fuck
#ChatFilterReplace f**k
#ChatFilterWarnPrivate 1 Watch your mouth, or I'll have to wash it!

# More examples can be found in the example file examples/chatfilter(.txt)
# and examples/chatfilter_swearwords(.txt) 
# If you directly use that last file, note that it replaces some things
# with Generic_Swearword, Generic_Swearword_ing and Generic_Insult;
# you can then replace them with tame alternatives, such as:

#ChatFilter Generic_Swearword
#ChatFilterReplace Bork

#ChatFilter Generic_Swearword_ing
#ChatFilterReplace Borking

#ChatFilter Generic_Insult
#ChatFilterReplace Muppet

# Note: one single regular expression is more efficient than a block with
# several ChatFilter alternatives.

#< NEW

###########################################################################################
## Administrative Options
###########################################################################################

# You can give players access to the server by creating admin accounts. The format
# for those is
#Admin <player name>~<player keyID>~<admin level>~<password>
# The individual fields, separated by the tilde character (you can't get it in Defcon, so
# it won't appear in player names) are:
# <player name>  The game name of the player. Comparison of names is not case sensitive and
#                leading and trailing whitespace is discarded.
# <player keyID> the player's authentication keyID. You can find yours in the file debug.txt
#                on the line starting with "Received Authentication". You can find the
#                keyID of others in the server logs on the lines starting with "Login request".
#                For non-steam users, the keyID is a never changing number associated with
#                the authentication key and moderately hard to fake. For steam users, the number
#                changes every time they get a new key.
#                If you are a steam user and don't want to update your config files every time
#                you get a new key, you can also place the string "OWNER" in place of the key
#                ID, it will be automatically replaced by the server's key ID.
#                If you don't want to include the player's keyID in the login data, just leave
#                the filed blank.
# <admin level>  is a number determining the rights of that admin. Lower numbers are better.
#                0 and negative values mean this player essentially owns the server and can do
#                everything. 1 are regular admins. In the default settings, they too can do
#                everything. Level 2 are metamoderators, level 3 and more are moderators.
#                In the default settings, metamoderators and moderators don't have the right
#                to change server settings. The difference between metamoderators and moderators
#                is that metamoderators can recruit moderators with the /op command.
# <password>     the password the player has to enter after "/login". It is case sensitive
#                and whitespace is significant, so be sure you don't put in leading or
#                trailing whitespace there. Although the keyID check is quite secure, it is
#                not perfect and therefore, a password is highly recommended.

# Example: This allows the fictionous user Sam with keyID 123456 to log in as
# metamoderator without giving a password:
#Admin Sam~123456~2~

# The player names of admins with registered keyID will be protected against imposters.
# To extend this protection to selected regular players, use
#Player <player name>~<player keyID>
# This is equivalent to Admin with a very long and random password and no worthwile admin level.
# Note that for steam users, this is rather inpractical since the keyID changes too often.

# (not really new, but new to this file)
# The number of attempts a player gets to log in as admin/moderator is controlled by
LoginAttempts 5

# You can remove admin accounts with
#AdminRemove <player name>

# You can determine what the admins of various levels can do. The minimum level required
# to change setting via /set is given by
AdminLevelSet 1

#> NEW
# The minimum level required to bypass chat filters (/ignore and private spectator chat) via /say is given by
AdminLevelSay 2
#< NEW

# The minimum level required to use the /op command is
AdminLevelOp 2

# and the minimum level to use /kick is
AdminLevelKick 4

# the minimum level to use /include is
AdminLevelInclude 4
#> NEW
# the minimum admin level to actually be allowed to play. For the purpose of this commanddnl
# configuration options and commands also have individual admin levels. You can change them
# with
#AdminLevel <command> <level>
# The settings that change the admin levels are by default only usable by the owner,
# that would be the effect of
AdminLevel AdminLevelKick 0

# Sometimes, you want to make scripts with commands only callable by high level
# admins available to lower levels. To do so, use Sudo. Put it at the beginning
# of the file:
#Sudo <required level> <effective level>
# The required level will be the minimum level the admin issuing the include needs
# to have to execute the whole script. The effective level is then the admin level
# the script will be executed with. So
#Sudo 3 0
# would allow all moderators and higher to execute the script with effective
# rights of the server owner.

# When an admin uses /op to pass on the admin rights, this is the highest level the
# new admin will initially have. You can increase the level later with /promote.
OpLevel 2

# When demo players try to join, but can't, they get an informative message. Customize
# it here. I'd recommend encouraging them to buy the game in your own words, like
#DemoPlayerMessage Sorry, too many demo players, you can't join. Please support IV and buy the game.

###########################################################################################
## Kick votes
###########################################################################################

# Kick votes are usually a bad idea (keywords: lynch mob, kick vote abuse) and are
# therefore disabled by default. You can enable them by giving a finite value to
# the variable
KickVoteMin 0
# which controls the minimum number of clients that need to be in agreement on a kick
# before it is executed. The recommended minimal value would be 3; otherwise, two
# griefers can team up and block a server by kicking everyone who enters.

# Likewise, the minimum number of players approving a kick requried for it to get
# executed is determined with
KickVoteMinPlayers 0
# For a two player server, 0 is fine (any other value and the two griefers can block
# the server again by joining the active players, but not readying up), for larger
# servers larger values would be recommended. 1 sounds good for 3 or 4 player servers,
# 2 seems fine for 5 or 6 players.

# Aditionally, for a kick vote to be successful, either a majority of players
# or a majority of all clients need to approve it. You can bend the vote in favor
# or against kick votes by changing
KickVoteBias 0
# A vote gets accepted if 
# 2*(number of supporters) + KickVoteBias > (total clients)
# holds (where the counts go over all clients resp. only the players).
# So by making KickVoteBias larger, you make kick votes accepted more easily, by
# making it smaller, more approvers will be reqired to get them through.

# Good values for a six player server seem to be
#KickVoteMin 3
#KickVoteMinPlayers 2

# Final remarks: once the game has started, kick votes only work against spectators.
# Clients from the same IP are treated as one voter.
# Players can issue kick votes with the /kick and /kickid chat commands as described
# in the README.

###########################################################################################
## Bans and Kicks
###########################################################################################


# Like with the chat commands /kick and /kickid, you can kick spectators or, if the
# game has not started yet, players, with
#Kick <part of client name>
# and
#KickID <numeric ID of client>

#> NEW
# For bans and other permanent things attached to players, you have three ways
# of identifying a player. The easiest one is the KeyID. It is the numeric ID
# you see in the login messages. Beware, Steam users do not have a fixed KeyID, their
# KeyID changes rougly once per month.
# Steam users and demo players therefore need to get identified via their IP address.
# To identify a player via his KeyID or IP address (in standard x.y.z.w notation),
# just pass it as the ID argument of the following commands. 
# The last resort for identifying players are IP ranges. The format of the range 
# is one of the standard notations for IP ranges: first comes the basic IP, then
# a slash, then the number of significant bits that are used for comparison.
# For example, 192.168.0.0/24 stands for all IPs of the form 192.168.0.*,
# and 192.168.0.0/16 for all IPs of the form 192.168.*.*. .
# Flags can be appended to IP ranges, they determine the various client versions
# a player may be using. Typically, griefers don't have the possibility to switch
# between client types, so you can make your range bans more specific by limiting
# them to, say, Linux Demo users. Flags are single letters that go directly behind
# the IP range (without space). Supported flags:
# n : Only applies to ranges used in bans: negates the effect of the ban.
#     Use to punch holes into ranges. Combine with other flags to negate
#     bans on regular users.
# w : Windows Demo clients from that IP range.
# l : Linux Demo clients from that IP range.
# m : Mac Demo clients from that IP range.
# s : Steam clients from that IP range.
# c : all clients that would be compatible with a steam key as 
#     authentication (that's all except the Mac versions) that log 
#     in with a full key (which may be from steam).
# a : all clients that log in with a full authentication key from 
#     that range.
# the last two flag types are only for emergencies when used for banning: 'c' for those
# griefers that find out they can copy their steam key over to other versions and appear
# to Dedcon as new regular players every time their key gets updated, which
# they can enforce, I think. 'a' is for rich spoiled brats who buy tons 
# of keys. Flags can be combined; 'wlam' will apply to all clients.
# If you don't give flags, the range applies to all demo and steam users (wlms)
#< NEW

# You can ban players:
#Ban <ID>
# where ID is either a KeyID, IP or IP range. The old commands BanKeyID, BanIP and BanIPRange
# are also accepted as synonyms.

# Bans can be revoked with
#UnBan <ID>
# again with the synonyms UnBanKeyID, UnBanIP and UnBanIPRange.

# For less severe cases, where the only offense of a player is language you disapprove
# of, you can silence players by IP, IP range or KeyID. The command is
#Silence <ID>
# Or synonymously SilenceKeyID, SilenceIP and SilenceIPRange.

# You can undo silencings with UnSilence, UnsilenceKeyID, UnSilenceIP and UnSilenceIPRange.

# If you use the Silence command family, you will probably also want to lock the player
# to a specific name:
#ForceName <ID> <name>
# where, as usual, <ID> is a keyID, IP or IP range, and synonymous commands are
# ForceNameKeyID, ForceNameIP and ForceNameIPRange.
# You can undo forcing a name by setting the name to NONE.

# Mostly for warning players that they are about to be banned, you can send
# players greeting messages via
#Message <ID> <message>
# or
#PublicMessage <ID> <message>
# The difference is that the first message is sent to the player privately,
# while the second message is sent publicly. 
#> NEW
# Messages accumulate, you can send several messages to the same player, mixing
# public and private ones as you like.
#< NEW

#> NEW
# You can associate a rating score with a player via
#Rating <ID> <score>
# (because I can't decide whether "rating" or "rank" is the better word, the command
# Rank does the same thing.)
# The score will then be displayed in the server browser, 
# where normally the game score (which Dedcon doesn't know all by itself) is displayed.
# If the All Star Mode is activated, players with a higher score can 
# push players with a lower score out of the game (if the game hasn't started yet,
# of course).

# The score in the display can be fuzzed with the setting
RatingFluctuation 0
# A random number between -RatingFluctuation and +RatingFluctuation will be added
# to the scores, so that the displayed scores cannot be used to identify specific players
# that easily.

# All Star Mode is activated by changing this setting:
AllStarTime 0
# It determines the number of minutes, counted from server start, that the server
# waits for better players to arrive.

# If the All Star Mode is active, seats really occupied by players with a lower 
# rating score than
AllStarMinRating 0
# are advertised as still free on the server browser.

# The minimum rating required to play. Only active when set.
#MinRating 0

# The maximum allowed rating to play. Only active when set.
#MaxRating 0
#< NEW

###########################################################################################
## Logging
###########################################################################################

# Log level. Increase to get more output (a lot, actually), decrease to make the server
# mostly silent.
LogLevel 2
# 0 for mostly silent (except error messages)
# 1 to display only game events
# 2 for game events and some status changes

# Log lines can be prepended with a timestamp. The following variable determines the format,
# various % directives are replaced with bits of the current time.
# This, for example, prints the time without date, but with seconds:
#TimestampFormat %T:
# (Unfortunately, it does not seem to work on the Windows version)
# The default is to print no timestamp at all.
# For full docs on the possibilities, see "man strftime" or, probalby just as accurate,
# "man date" or http://de3.php.net/strftime . Results may vary depending on your operating
# system.

# All the log filenames that follow are piped through the same function as the timestamp;
# that means you can automatically name them according to the current date and time by
# smuggling in appropriate %-statements.


# All the following log files can get an additional prefix, determined by
LogFilePrefix

# To store all log files into a common directory, you can use
#LogFilePrefix directory/

#> NEW
# You can create directories using 
#MakeDir <directory name>
#< NEW

# In addition to printing them to the terminal, error messages can be logged
# into a file with
#ErrFile <error log file>

# All console output (meant to be read by humans) can be logged to a file with
#OutFile <output log file>
# This overrides a previous ErrFile setting.

# A machine readable event log can be written to
#EventFile <event log file>

# The following events get recorded:
# SERVER_START                        server starts
# SERVER_QUIT                         server quits
# GAME_START                          the game starts
# GAME_END                            the game ends
# CLIENT_NEW <keyID> <IP> <ID> <version> a new client joins
# CLIENT_QUIT <ID> <reason>           a client disconnects/drops
# CLIENT_NAME <ID> <name>             a client gets a new name
# CLIENT_GRIEF <ID> <griefing>        a client does something bad
# CLIENT_OUT_OF_SYNC <ID>             a client fell out of sync
# CLIENT_BACK_OF_SYNC <ID>            a client fell back in sync
# CPU_NEW <ID>                        a new CPU joins
# CPU_NAME <ID>                       the CPU gets a name
# CPU_QUIT <ID>                       a CPU gets removed
# TEAM_ENTER <teamID> <ID>            a CPU or client enters as a player
# TEAM_LEAVE <teamID>                 a player leaves the game
# TEAM_ABANDON <teamID>               a player leaves the game and is replaced 
#                                     by a CPU dummy
# TEAM_RECONNECT <teamID>             a player rejoins the game and takes control
#                                     back from the CPU dummy
# TEAM_READY <teamID> <readyness>     a player marks that it is ready/not ready for play
# TEAM_SPEED <teamID> <speed factor>  a player requests a new game speed

# TEAM_TERRITORY <teamID> <territoryID> a team selects a new territory
#                                       (beware, this is RAW data and does
#                                       not mean the client actually HAS that territory selected.)
# TEAM_ALLIANCE <teamID> <allianceID> a team selects a new alliance (only pre-game right now)

# SCORE_BEGIN                         marks the beginning of logged scores
# SCORE_TEAM <teamID> <score> <clientID> <playerName> 
#                                     marks the scores of a team
# SCORE_SIGNATURE_PLAYER <clientID> <keyID> <playerName>
#                                     marks that a player has signed the scores
# SCORE_SIGNATURE_SPECTATOR <clientID> <keyID> <playerName>
#                                     marks that a spectator has signed the scores
# SCORE_END                           marks the end of logged scores
#> NEW
# CLIENT_ACHIEVEMENT <clientID> <flags> gives the current viral achievement flags of a player
# RANKED <ranked>                     0 if the players agreed not to have this game ranked, 1 otherwise.
# CHARSET <character set>             indicates the character set of the output. 
#                                     latin1 for DedCon, utf-8 for Dedwinia. Everything before this
#                                     line is pure ASCII.
# And on admin request via LogPing, connection statistics:
# CLIENT_PING <ID> <Ping in ms> <packet loss in percent> <number of unprocessed sequences>
#< NEW

# Names are always the rest of the log line, as is the client's version.
# Clients and CPU share the same ID space consisting of all non-negative integers.
# teamID goes from 0 to 5. With TEAM_ENTER, you have to check whether the ID belongs
# to a client or a CPU.

# The reasons given on client disconnects are (not all of them can occur):
# 0 : client left
# 1 : connection lost
# 2 : the server quit
# 3 : client sent invalid key
# 4 : client was using a duplicate key
# 5 : authentication failed
# 6 : client gave wrong password
# 7 : server is full
# 8 : client was kicked
# 9 : server is demo restricted, client is demo

# In addition to these hardcoded events, you can add your own entries to the event log
# with the config file command
#LogEvent <message to log>
# the intended usage is to log stuff for external scripts to analyze.


# By default, the timestamps not only get added to the log files (OutFile and ErrFile),
# but also the terminal output. If you want timestamps only in the log files,
# uncomment this:
#TimestampOut 0

# Griefing events (spam, admin kicks, early quits...) can be logged to a
# file with
#GriefLog <grief log file>
# All log lines in this file will begin with
# keyID=<griefer's key ID>, IP=<griefer's IP>, griefer=<griefer's client ID>,
# grief=<type of grief>.
# In the case of the kick, the person getting kicked is logged as the griefer,
# you should use your admin judgement and inspect the kick event in the logs.

# Before anything is written into the grief log, it gets a configurable
# header. Use them to distinguish between the server sessions.
#GriefLogHeader <header>
# It is run through the same processing as the timestamps.

# The players of a game are logged into this file:
#PlayerLog <player log file>

# Since those last logs are much less populated, they can get a different
# timestamps  than the output and error logs. You can control it with
#RareTimestampFormat %c:
# The example above gives a full date and time. The default, again, is to
# not add any timestamp.

# (changed interpretation)
# Early quits only get logged if they happen earlier than the following percentage
# of the game time where the majority of players was last online:
EarlyQuit 20

# Example: If there were six players, one player quits after 5 minutes, the next
# after another five minutes, the next after another 10 minutes and the next just
# at DEFCON 1, then the reference time used is the time the fourth player quit
# (30 minutes) and everyone quitting before 20% of that (6 minutes) gets logged.
# That's only the first quitter in this example.

#> NEW
# Additionally, early quits are only counted as such if they happen earlier than
# this many game time minutes after the game started:
EarlyQuitMinutes 60
# Rationale: games can drag along a long time, but some players are completely wasted
# after 60 minutes, and it would be cruel to force them to stick around.
#< NEW

# You can make the server write a recording of the session for later playback
# with
#Record <filename>
# The file extension is up to you, but we recommend you pick .dcrec.
# You can play back the recording later via the -l command line switch.

# The following flags determine whether keyIDs and player IPs are to be logged in the
# recording and printed at playback.
SaveKeyID 1
SaveIP 0

# The following setting defines the default value for the RANKED log event.
# All players need to agree to change it before it is flipped.
RankedDefault 1

###########################################################################################
## Networking options
###########################################################################################

# Dedcon tires to find the Defcon authroization key where it is stored by default; on Linux
# and OSX, the location is fixed and easy to find, on Windows it is more complicated. Anyway,
# should the key not be found (signal: the server prints "Only got demo key ...."),
# ServerKey needs to be be set to a valid Defcon authorization key for the dedicated server
# to be fully functional. It is crucial for advertizing it to the metaserver and to disable
# demo mode. Also, it serves as an authentication token: when you connect to your own server
# with a client using the same key (perfectly legal), you'll be recognized and admin chat
# commands will be made available to you.
ServerKey ${server_key}
# No qotation marks around the key, no space after the key, and all the hyphens and
# capitalization. Like this (only for format demonstration, the key is invalid):
#ServerKey DEMOOF-MJSHVW-MOLIKG-FXIAFD-XQV

# Alternatively, especially useful for Steam users, you can also set the location of the authkey
# file in this variable, like this:
#ServerKeyFile C:\Program Files\Steam\steamapps\common\Defcon\authkey
# You only need to set either ServerKey or ServerKeyFile.

# The port the server will listen on.
ServerPort ${server_port}

#> NEW
# If your server is behind a router and you set up a port forwarding rule to forward
# ServerPort to the server, you should set the following to 1. This has two effects:
# the matchmaking protocol and the public port detection are disabled. Both are required
# if you have not set up port forwarding, and the port detection may give wrong results
# if you did set up port forwarding.
# If your server is connected to the internet directly, you should set this to 1, too.
PortForwarding 0
#< NEW

# The IP of your server on your LAN. The server tries to determine it automatically by
# sending a broadcast to itself (AFAIK the same method is used by Defcon), but there
# are many situations in which this fails. Examples are if you have disabled broadcasts
# or if your server is on multiple networks. Watch your logs for the line starting with
# "ServerLanIP ="; if there is none or if the IP is wrong, you should verride the
# automatic detection with
#ServerLANIP <your real IP>

# On rare occasions, if your server has many network interfaces, you want Dedcon to
# only listen to connections from one of those IPs and contact the metaserver from
# that IP. That is possible with
#ServerIP 127.0.0.1
# The above example makes the server only listen to the loopback network, which won't
# work properly as the metaserver cannot be reached from there.

# The difference between ServerLANIP and ServerIP is the following: only serverIP has
# a real influence on the network setup, ServerLANIP merely informs prospective clients
# of the correct IP to connect to. ServerIP automatically also sets ServerLANIP.

# On short time average, the server will not use more bandwidth (in byte/s) in total.
# Technically, it only affects the outgoing bandwidth, but in good approximation,
# the clients send back an equal amount ob data than they receive by the server.
# Players get priority in the bandwidth distribution; if there is a shortage, spectators
# will be the first to lag.
TotalBandwidth 10000

# During tough times, every client, even spectators, are guaranteed to
# receive at least this bandwidth.
MinBandwidth 600
# The default value is the minimal value that makes a client keep in sync
# if nothing interesting is happening at all.

# The maximal bandwidth (again in bytes/s) allocated for each player. This mostly limits
# the bandwidth spent on freshly connecting spectators or reconnecting players, the 
# average bandwidth used by synced spectators and players is around 700 bytes/s at all times.
PlayerBandwidth 4000

# If bigger than 0, SpectatorBandwidth determines the maximal bandwidth allocated for 
# each spectator. If set to something smaller than PlayerBandwidth, this can be used
# to limit the server's resource usage, but it will also increase the time it takes
# the spectators to join.
SpectatorBandwidth 0

# If you want the current players' pings in your logs for some reason, use this command:
#Ping
# It's probably most useful after WaitStart or when entered manually at the
# console.

#> NEW
#LogPing
# gives the same data, but logs it into the event log.
#< NEW

# The players' scores can be printed with
#Score
# This is probably most useful after WaitEnd.

# Sometimes, clients fall out of sync completely and no amount of resyncing
# can fix that. They only waste bandwidth and worse: they can pull other
# clients down with them, for example when it is a three player game, one
# player is desyncing, and another quits. Afterwards, both players will be
# considered out of sync. Anyway, the maximum number of times a player
# can press the "resynchronize" button is given by
MaxResyncAttempts 3

# "Ghosting" is a popular, low tech cheating method; you log in to a server both as
# a player and a spectator and use the spectator to collect intel to use as the player.
# More sophisticated methods can't be detected, but a simple IP comparison can stop
# most cheaters. The following setting configures Dedcon's behavior when ghosting is
# detected.
GhostProtection 2
# Values:
# 0 for do nothing, no action is taken.
# 1 for report, ghosting suspicions are reported to all players.
# 2 for kick, kick the spectators with the same IPs as players. This is the default.

#> NEW
# Change this setting to 1 if you don't want the server to continue operation
# (restricted to demo mode) if no contact to the metaserver can be made.
RequireMetaServer 0
#< NEW

###########################################################################################
## Flow control
###########################################################################################

# A very limited amount of scripting is available in config files.

# You may want a fake player in the server representing you while you are not online yourself.
# It will communicate things to the players by chat, for example when they hit "ready", but
# too few people are online to start the game.
# Here's how you set his name.
#HostName <insert your name here>

# You can make this fake player say a greeting message. This setting can be repeated to
# say several things, each in its own chat line.
#Say Welcome to my server.
#Say Feel free to start a game any time.

# You can wait for the game to start with a single line containing
#WaitStart
# all the following lines will only be executed after the game started.
# Possible application: make the spectator channel private only after the game started with
# these lines;
#SpectatorChatChannel 1
#WaitStart
#SpectatorChatChannel 0


# On playback, you can modify the initial playback speed (10 is normal) with
PlaybackSpeed 10

# You can make the next client that joins take control over a specified
# team as if it was the owner of that team that rejoined. Unwanted, but
# unavoidable side effect: the client's name will be altered to the
# name of the player previously controlling that team.
#JoinAs <teamID (0-5)>
# instead of the team ID, a client ID works just as well.

# This feature can be abused for single player save games. Play a game
# on a dedicated server against AIs, order it to save a playback,
# quit, and later play it back with
#dedcon -l <recording> -c "JoinAs 0"
# and you will continue where you left off.
#
# Another use is if you're in a nice six player game and one player quits
# very early. You (as the admin) can find out which teamID is missing
# with "/score" and then say "/set JoinAs <missing ID>", and the next
# qualified joining client will take over the abandonned territory.
#
# The last use would be teamwork. Two players are able to share control
# over a territory (or multiple territories). Find out your teamID with
# "/score" and then "/set JoinAs <your Team ID>". The next player that
# joins will have control over your units, too. Needless to say, do
# this only in controlled environments where you can trust the other
# player, and this usage also is deeply unsupported right now. It works
# quite well in the game itself, but the lobby has a number of quirks,
# and the player appears twice in the server browser.
#
# When reentering a recorded game, usually you'll start playing at the end
# of the recording. Sometimes, you want to enter in the middle, because that's
# where you dropped out of the game, and you want to find out whether you 
# would have done better than the CPU (with the other players replaced by
# CPUs this time). Use
#JoinAt <SeqID to join at>
# for that. The exact SeqID of a game time can be seen in the network data tool,
# and you can also estimate it: It roughly is the real time passed since the
# game start in seconds times ten. You can also get the SeqIDs of the times at
# which a client dropped from the server by watching the output of the playback
# when you use "JoinAt 0".

#> NEW

# You can revert all settings to their default and let the whole configuration
# be read again with
#Reload
# It's useful for tesing edits in configuration files without having to
# restart the server.

###########################################################################################
## Randomisation/Rotation
###########################################################################################

# Dedcon supports random setting selection or setting rotation via
# a simple mechanism. First, you define the variants of settings you want
# the server to alternate between, then you define how the server should
# select between those settings.

# Part 1: defining the random settings

# The easiest way to define a random setting is RSET. With
#RSet <configuration line>
# you define the given configuration line as one whole variant.
# For example,
#RSet Include variant1
# would let the variant, if it is selected, include the file variant1.

# For several frequently used configuration settings, there exist shortcuts:
#RInclude <file>
# is equivalent to
#RSet Include <file>
# and likewise, RFork <file> is a shortcut for RSet Fork <file>.


# You can also group several setting lines into one variant; that way, you don't
# have to create a whole include file for small setting groups. The syntax is
#RBegin <name>
# <your settings go here>
#REnd
# If the variant is selected, all settings between RBegin and REnd are executed.
# The name given with RBegin is optional, but it is used by the weighted randomisation
# to remember setting groups even if you shuffle them around in your configuration file.

# Part 2: selecting and activating

# There are three ways to select between rotation/randomising setting variants.
# The easiest is a simple, unweighted random selection:
#Randomise
# will just pick one arbitrary setting variant and execute it.

# The next method rotates the settings; on the first run, the first variant is picked,
# on the second run of the server, the second variant, and so on, until all variants
# were activated once, then the process starts over. The command to do that is
#Rotate <filename>
# where <filename> is a log file used to save and restore the current position in
# the variant list. It can contain time replacement strings just like the log filenames.

# The last method is the weighted randomisation, which is a blend of the previous
# methods and adds long term automatic player polls. The syntax is as simple as
# the plain rotation:
#Weight <filename>
# Again, <filename> is used to store statistics of previous runs and accepts time
# replacement directives; it is recommended to put %H in there to keep time of day
# dependant statistics.
# Two settings influence the random selection:
WeightFluctuation 900
# determines the randomness of the selection. The unit of this setting is seconds.
WeightExponent 1.5
# is an exponent that determines how much the server will listen to the opinions
# of the players. At 0, it will not pay any attention at all, and the higher the
# value is, the more the server will focus on just picking the selections the 
# users like. Settings > 3 probably are not such a good idea.

# What does this do precisely? The popularity of settings is determined by measuring
# the time it takes for the server to gather players. For every setting variant,
# the sum of all past values of (wait time)^WeightExponent is calculated,
# a random number between 0 and WeightFluctuation^WeightExponet is added, and then
# the variant with the lowest number wins. This guarantees that in the long run,
# the frequency with which a setting variant is selected is proportional to 
# (average wait time)^-WeightExponent, and assuming the wait time is shorter
# for more popular settings, more popular settings get selected more often.

# Random setting variants can be nested. Inside RBegin/REnd blocks or in included, further
# rotation commands may appear.

# This setting determines how many players need to be online before the
# system considers the waiting time to be over. A server quit or a started
# game also counts as ending the waiting.
WeightWaitTeams 2

#< NEW

###########################################################################################
# WARNING: all commands and settings that come after a Wait* command will only be executed/
# applied once the Wait* command has finished. You should put all settings before the first
# Wait* command in your config file, ESPECIALLY the Admin-command. Also see the Fork 
# command which allows you to have multiple scripts executing at the same time.
###########################################################################################

# You can wait for a client to connect with
#WaitClient
#> NEW
# WaitClient accepts an additional parameter: the total number of clients to wait for.
#WaitClient 3
# will wait until there are 3 players online.
#< NEW

# You can wait for the game to end (defined as: when all the players have quit) with
#WaitEnd

# You can wait for some seconds of real time with
#WaitSeconds <seconds to wait>

#> NEW
# Does the same, but takes the time from the program start
#WaitSecondsFromStart <seconds to wait>
#< NEW

# , for some seconds of game time with
#WaitGameSeconds <seconds to wait>

# and for the game clock to reach an absolute value.
#WaitGameSecondsAbsolute <total game time in seconds to wait for>

# For simplification, you can also wait for a certain Defcon level with
#WaitDefcon <level to wait for>
# WaitDefcon 1 is equivalent to WaitGameSecondsAbsolute 18000.

# There are two ways to read input from other configuration files; the straightforward
# way is the classic include:
#Include <file to read>
# Commands in that file will be executed as if you copy-pasted them into the current
# configuration file. A .txt extension is automatically appended to the filename if needed.
# Wait commands inside the configuration cause the execution of the
# current configuration file to stall until they are completed. If that is not desired,
# use
#Fork <file to read>
# That will execute all commands inside the specified configuration file in parallel to
# the commands in the current configuration file, so while one configuration file waits
# for the game end to shut down the server, another configuration file can wait for
# Defcon 3 to speed up the game after everyone has placed.

# you can shut down the server with
#Quit

# Possible application of the last three: prevent spectators from keeping the server running with
#WaitEnd
#WaitSeconds 1200
#Quit

# A complete example on how to use this can be found in ConfigTournament.sample.

###########################################################################################
## Better leave those alone
###########################################################################################

# If set to 0, all sensibility checks on settings are turned off.
# Of course, all problems you find doing so are yours.
CheckLimits 1
# To make this setting work, you need to put it before all settings with
# out-of-sane-bound values, best at the beginning. It also disables the network
# bandwidth sanity checks, so you have to figure out on your own whether the number of
# configured players and spectators fits into the total bandwidth.

# The assumed overhead in bytes per sent UDP packet. The real value varies depending
# on the network infrastructure. This is used in bandwidth calculations.
PacketOverhead 40

# Maximum size of UDP packets the server tries to send. Larger packets, if possible,
# are split.
MaxPacketSize 500

# Same setting, specialized for packets that contain data sent again to compensate for
# packet loss.
MaxResendPacketSize 200

# The maximum number of sequences (roughly equivalent to packets) that can be pending
# (sent, but not yet acknowledged) for each client at any time.
SeqIDMaxAhead 300

# The rough maximum queue of received, but not yet processed, packages for each client.
# As the queue grows larger, bandwidth to that client is gradually throttled down.
# Set to 0 to disable this throttling, this would be the behavior of the regular Defcon server.
SeqIDMaxQueue 300
EOF
chown -R dedcon:root /usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0/

# create service file
echo "Creating service file"
cat > /etc/systemd/system/dedcon.service << EOF
[Unit]
Description="Dedcon game server service"
After=network.target
[Service]
User=dedcon
WorkingDirectory=/usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0
ExecStart=/usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0/loop.sh ConfigFile
Restart=no
[Install]
WantedBy=multi-user.target
EOF

echo "Reloading daemon"
sudo systemctl daemon-reload

echo "Enabling dedcon service"
sudo systemctl enable dedcon

echo "Starting dedcon service"
sudo systemctl start dedcon

echo "Service Started"


