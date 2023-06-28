# Friday Night Funkin' - Mega Engine! (Early Development Stage!)

This is the repository for Friday Night Funkin' Mega Engine, a game originally made for Ludum Dare 47 "Stuck In a Loop" by Ninjamuffin99 and the Funkin' devs.
Huge credits to them for the base game!

Play the Ludum Dare prototype here: https://ninja-muffin24.itch.io/friday-night-funkin
Play the Newgrounds one here: https://www.newgrounds.com/portal/view/770371

We have a Discord server! Feel free to join here: https://discord.gg/Mb78ZKtEYY
Any concerns, feel free to pop into the Discord server and make a thread.

My goals for this engine is to be a somewhat lightweight rework that fixes issues the base game has, while staying close to what the original game is like

# MODDING - STILL BAREBONES
Make a folder in the `mods` directory, I'll be using my mod "Peeco" for this (It's just adding the song Pico into the game without source code editing.)

Make a folder named `_append` - The underscore is VERY important

In the `_append` folder, make a folder called `data`

Make a new text file titled `freeplaySongs.txt` and add the name of the song you want to mod in to the file (Such as "Pico")

Go back to the mod directory (You should only see the `_append` folder for now)

Make 2 new folders, title them `data` and `songs`

In the `data` folder, add the song's charts in a folder titled the same as the `freeplaySongs.txt` contents, so in the `data` folder, you should see a folder named `your song name`, and 3 charts in that folder

Do the same for the `songs` folder, but add the `Inst` and `Voices` files

You should be able to play the song from the Freeplay menu!
