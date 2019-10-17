# Yggdrasil 3
A multiplayer text based multi-user-dungeon (MUD) written in perl5. Users can connect through a simple socket connection (port 3329 by default). As this is the third time I have attempted to create a mud, this will be version 3 of operation Yggdrasil.

## description
A [MUD](https://en.wikipedia.org/wiki/MUD) is a role playing game simulated and rendered through text. Because of the simplicity of designing & developing text based games, it makes it a prime target for practicing & expanding one's coding exeperience.

## purpose
To give form to my ideals.

## environment
* Linux/Mac or Windows with WSL (Tested with Ubuntu 18.04.2)
* Perl (5.26)
    * DBI (1.642)
    * DBD::SQLite (1.64)
    * Math::Fractal::Noisemaker (0.105)
    * Lingua::EN::Inflexion (0.001008)
    * YAML (1.29)
    * Tie::IxHash (1.23)
* SQLite3 (3.22.0)

## suggested
* Perl::Critic
* Perl::Tidy

## running
# setup
* Install the modules listed above through cpan/package manager
* Run src/db_init.pl for first time database setup & loading

# server startup
* Run src/server.pl and connect to socket 3329 through netcat/telnet client

# local client startup
* Run src/local_client.pl to run an interactive client locally
