# Friday Night Funkin' - Mega Engine! (Early Development Stage!)

This is the repository for Friday Night Funkin' Mega Engine, a game originally made for Ludum Dare 47 "Stuck In a Loop" by Ninjamuffin99 and the Funkin' devs.
Huge credits to them for the base game!

Play the Ludum Dare prototype here: https://ninja-muffin24.itch.io/friday-night-funkin
Play the Newgrounds one here: https://www.newgrounds.com/portal/view/770371

# MODDING - STILL BAREBONES
Make a folder in the `mods` directory, I'll be using my mod "Peeco" for this (It's just adding the song Pico into the game without source code editing.)

Make a folder named `_append` - The underscore is VERY important

In the `_append` folder, make a folder called `data`

Make a new text file titled `freeplaySongs.txt` and add the name of the song you want to mod in to the file (Such as "Pico")

Go back to the mod directory (You should only see the `_append` folder for now)

Make 2 new folders, title them `data` and `songs`

In the `data` folder, add the song's charts in a folder titled the same as the `freeplaySongs.txt` contents, so in the `data` folder, you should see a folder named `your song name`, and 3 charts in that folder

Do the same for the `songs` folder, but add the `Inst` and `Voices` files

Make sure that player 2 in the `.json` file is a character from the game (as I haven't finished the mod system yet, and it _will_ crash. (I use GF for simplicity.)

You should be able to play the song from the Freeplay menu!
