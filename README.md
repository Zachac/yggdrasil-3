# Yggdrasil 3
A multiplayer text based multi-user-dungeon (MUD) written in perl5. Users can connect through a simple socket connection (port 3329 by default). As this is the third time I have attempted to create a mud, this will be version 3 of operation Yggdrasil.

## description
A [MUD](https://en.wikipedia.org/wiki/MUD) is a role playing game simulated and rendered through text. Because of the simplicity of designing & developing text based games, it makes it a prime target for practicing & expanding one's coding exeperience.

## purpose
To give form to my ideals.

## requirements
* Linux/Mac or Windows with WSL (Tested with Ubuntu 18.04.2)
* Perl (Tested with v5.26)

## running
To run, an instance of src/local_client.pl will need to be started. If using src/server.pl, then a socket will be opened that will be connected to a local_client.
* execute src/local_client.pl or
* execute src/server.pl and connect through netcat/telnet
