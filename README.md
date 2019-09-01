# Shell Mud
An interactive multi user dungeon built with shell scripting

## Purpose
The purpose of this project is to design an intuitive mud that is easy to edit without the hassel of learning commands and a library that is hyper specific to a single mud implementation. By making this mud editable in a system explorer rather than a command line, we hope to streamline the building process for these worlds.

Within a mud, data is all text based, so storing we assert that storing it in database, or even hypertext, is superfulous. Data storage is cheap, and disk memory is more than fast enough for real world applications. In the persuit of simplicity, we have made the following "compromises":
* Rooms are real directory with real links to other rooms
* Items, Players, and data are all kept in plain readable text as they will be formated on the player screen
* Commands are actual executable commands that can be written in any language that the creator is comfortable with

## Dependencies
* Bash
* Perl
	* libio-socket-inet6-perl

