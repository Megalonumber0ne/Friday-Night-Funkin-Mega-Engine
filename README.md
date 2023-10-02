# Friday Night Funkin' - Mega Engine! (End of Development)

# Farewell, Mega Engine;
As I prepare for the shutdown of Mega Engine, I want to thank all of those that stuck by my project, whether it be for a week, a month, or it's whole life. You people are the reason I managed to get Mega Engine to the state it's in, and I'm incredibly thankful for this. I left the details in the discord server, however I will release what I have, even though some things I promised will not show up. - I will hopefully have the update up by 10:00PM (British Summer Time (BST)) October 3rd 2023

Everything on this list won't be done unless it's crutial to fixing a crash (none of these are) or have been explicity stated will happen;

Missing:
 - Cutscenes for Week 6
 - Winter Horrorland camera & light sound stuff (gonna add that)
 - A few songs don't have dialogue (gonna add that too)
 - Downscroll (I tried to add it, failed miserably.)

Unfinished: 
 - Week 6 dialogue - SCRAPPED
 - Mod system (scrapping, only songs will be functioning)
 - Debug build count on the menu (idk how to add that)

Broken:
 - Pausing and unpausing on the countdown will cause undesirable effects ranging from a miss to a death
 - Week 6 intro (gonna fix by scrapping the dialogue for Senpai's week)
 - Death counter (gonna scrap that too)

I do apologise, with failed promises and broken dreams, Mega Engine just cannot continue in development. There has been a VERY large drop in commits since my holiday in August, because my spark for this project simply got put out. My fire and passion for this project were simply extinguished. If you want to see the full goodbye message, pop into the Discord server to take a look, I'm leaving it open on the small chance I come back.

Signing out - Megalo(number0ne) ❤️


# Basic Information - No longer needed
This is the repository for Friday Night Funkin' Mega Engine, a game originally made for Ludum Dare 47 "Stuck In a Loop" by Ninjamuffin99 and the Funkin' devs.
Huge credits to them for the base game!

Play the Ludum Dare prototype here: https://ninja-muffin24.itch.io/friday-night-funkin
Play the Newgrounds one here: https://www.newgrounds.com/portal/view/770371

We have a Discord server! Feel free to join here: https://discord.gg/Mb78ZKtEYY
Any concerns, feel free to pop into the Discord server and make a thread.

# MODDING - Barebones, but it's all that it'll be
Make a folder in the `mods` directory, I'll be using a mod called "Peeco" for this (It's just adding the song Pico into the game without source code editing.(I know I've added it, it's just an example.))

Make a folder named `_append` - The underscore is VERY important

In the `_append` folder, make a folder called `data`

Make a new text file titled `freeplaySongs.txt` and add the name of the song you want to mod in to the file (Such as "Pico")

Go back to the mod directory (You should only see the `_append` folder for now)

Make 2 new folders, title them `data` and `songs`

In the `data` folder, add the song's charts in a folder titled the same as the `freeplaySongs.txt` contents, so in the `data` folder, you should see a folder named `your song name`, and 3 charts in that folder for each respective difficulty

Do the same for the `songs` folder, but add the `Inst` and `Voices` files

You should be able to play the song from the Freeplay menu!
