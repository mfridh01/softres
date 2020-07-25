# SoftRes
### A SoftReservation addon for WoW Classic.

## Who made SoftRes and why?
**SoftRes** is made by Mikael "Snits" Fridh. (Snits-NoggenfoggerEU)
This is my first addon (well second, since I first made **SoftRes** then re-wrote it due to many bugs)

When I joined the guild <OMEGA> on NoggenfoggerEU, I had no prior experience in raiding.
The first ZG run I joined, I noticed how messy everything was and all players had to keep track on their own stuff and the ML had to check lists and stuff.
I decided to create an addon to help with that. A **SoftRes** run should go smoothly, wether it's PUG or guild.

## Thanks to:
Thanks to <OMEGA> for supporting me in the creation of **SoftRes** and testing it on our Guild-Runs.
Extra shoutout to Vadfangördu, Velina and everyone who has whispered me while the addon was used.

## What is SoftRes?
**SoftRes** is an addon, that helps the ML keep track of what people have **SoftRes**erved and will help with:
* Announcement of items and rolls.
* Keeps track of who has the highest roll.
* Will count roll-penalties (if configured)

## No more Google sheets.
**SoftRes** takes away the need of having sheets with reservations.
No more checking who reserved what.
No more "Speak up if your reserved item drops".
The players can now focus on doing the killing and the ML can easily see who reserved what and won what.

## What is SoftRes, NOT?
**SoftRes** is a tool for **HELPING** the ML with keeping track of the **SoftRes**erved items.
It will NOT automatically distribute items. It will only Announce Roll-winners and won items, roll-penalties and such.
The ML will still have to manually distribute items and can do whatever he wants, even if **SoftRes** shows one thing, the ML can do another.
**SoftRes** does not automatically switch between loot types. So if the ML wants the trash loot too be rolled for normally, that will have to be switched manually.
    * Don't forget to put ML back again before bosses ... *cough*

## What's so good about SoftRes?
With **SoftRes**, only the Master Looter needs to have the addon. Everything is done so that everyone can see.
It announces winners and who has **SoftRes**erved what item when it drops.
No more Google sheets.

## What's bad about SoftRes?
**SoftRes** assumes that you can link an item in chat.
But really? Who doesn't have an addon that shows drops in dungeons?

## Whait! It announces and writes in chat in stuff. Doesn't that get messy?
There will be some spamming in chat, yes.
But that would happen even without **SoftRes** AND the ML would have to do it manually.
**SoftRes** uses a library called "ChatThrottle" to make sure that the spams are kept in an acceptable pace.
    * The user will NOT be thrown out of the game for spamming.
**SoftRes** uses another library called "AceTimers" for handling the timers.

## How do you actually use **SoftRes**?
As stated, only the ML needs the addon (which makes it perfect for pugs.)
Step-by-step:
1. The ML will create a new list.
    1. **SoftRes** will automatically fill the **SoftRes**ervations list with all the player in the raid (or party if 5-man).
1. The ML will go through the configurations and make sure they are as he wants them, or what's agreed upon.
    1. You can configure loot-timers, loot-penalties..
    1. There is an extra box for custom information.
        1. Ony-Head is reserved for guild.
        1. Need on all coins and bijous are.
1. He will then announce the rules.
    1. **SoftRes** will post them in /raid.
    1. **SoftRes** will also, at this stage, start the scanner of **SoftRes**ervations.
1. Everyone in the raid will link the item they want to reserve.
    1. Yes, it has to be an item-link.
    1. Yes, **SoftRes** assumes that you have an addon or something that can put item-links in chat.
1. When everyone have made their **SoftRes**reservations, the ML will close the scanner.
1. Now you play as normal.
1. When an item drops, the ML makes his choice on roll-type.

## Someone joined late, can we add that player?
YES! The user of **SoftRes** can manually Add/Edit/Remove players from the list.
YES! The user of **SoftRes** can manually Add/Edit/Remove won items.
YES! The user of **SoftRes** can manually ..... you can do it all.

## What are the roll-rules?
In **SoftRes** you can configure some loot rules.
* Roll-timers, which are timers for how long the players have to roll on an item before it goes over to the next roll-type or announces that no-one wanted it.
* Roll-penalties, where you can input how much roll-penalty the winners will have per won item.
    * MS- and OS-Penalties are separated, which means that if a player rolls on an MS-Roll (with penalty enabled*), that player will get that amount of penalty on future MS-Rolls... But not on OS-rolls. And vice versa.

## How does it Work?
The ML can either prepare an item while looting, or the ML can drag an item from the inventory to announce a roll for.
When an item is prepared, there are a few choices to make with the announcement.
When the ML announces an item for distribution, everyone who are elegible for rolling will have to manually /roll.
It takes those rolls and shows them on a list.
If someone who rolls already has a roll-penalty, **SoftRes** will announce in chat what the new roll-value is.

If the item is NOT **SoftRes**erved the choices are then: MS-roll, OS-roll, FFA-roll and Raid-Roll.
* MS-Roll = **SoftRes** will announce a Main Spec roll.
    * If no one rolled for MS **SoftRes** will automaticaly announce an OS-Roll (with the same penalty rules as the MS-roll)
* OS-Roll = **SoftRes** will announce an Off Spec roll.
    * If no one rolled for that OS roll, then the ML does whatever is agreed on, with the item.
* FFA-Roll = **SoftRes** will announce a Free for all roll.
    * This roll gives no penalty, even if you chose to put it there.
    * An FFA-roll is meant to give every player the opportunity to roll on an item.
* Raid-Roll = **SoftRes** will announce a Raid-Roll.
    * **SoftRes** will make the ML roll between (1- amount of members in raid). The one on the roll-position will be announced as the winner.
    * It counts from Group1 position 1 = **1**, Group2 position 1 = **6**. and so on.

If the item is **SoftRes**erved, the only choice you can make is to **SoftRes**-roll the item.
* **SoftRes** will announce who are elegible for rolls and will announce (once every xxx-seconds*) who has not rolled for the item.
    * When everyone has rolled, it announces the winner.
    * **SoftRes**erved item wins, does **NOT** give a penalty on rolls.
* If the ML decides that the roll has been waiting for a player, for too long (ie, that player is offline or whatever) the ML can force-announce the winner.
    * The winner will then be the one with the highest roll.

## It reads the rolls? But what if someone "cheats"?
Let's face it. We know that sometimes things goes really fast and it's easy to miss what people do.
People are people and there are always some who will try and cheat.
* Let's say that someone tries to /roll 100-100.
    * **SoftRes** will catch that and write in chat, that that type of roll is not supported and give them a chance to re-roll.

## Some configs that makes sense.
Some MLs prefers to have a loot-system that deals with a player winning an item, has lower prio than players who has not won an item.
* You config the MS- and OS-penalties to 100 each.
* When an item drops and are rolled for (with penalty enabled*) the winner gets -100 on that roll-type.
### A scenario, Say what we have 4 players who needs an item.
    * Player A, has 0 items won. (Bracket 0) (1 to 100)
    * Player B, has won 1 item on an MS-roll. (Bracket 1) (0 to -99)
    * Player C, has won 1 item on an MS-roll. (Bracket 1) (0 to -99)
    * Player D, has won 2 items on MS-rolls. (Bracket 2) (-100 to -199)
### An item drops that all 4 players needs.
### The ML announces an MS-Roll (with penalty) and all four players roll (1-100) on that item.
    * Player A, rolls a 1.
    * Player B, rolls a 50
    * Player C, rolls a 60
    * Player D, rolls a 90
### Player A wins the item, because:
    * Player A, is in bracket 0, which means he gets put agains other rollers on bracket 0.
    * Player B and C, are in bracket 1, they put against other people in that bracket. -100
        * Player C won over Player B with a rollvalue of -40 (Player B had -50) (bracket 0 to -99)
    * Player D, is in bracket 2, so his roll was worth -110 (bracket -100 to -199)
### And so on.

## Something else?
On the lists there are some icons showing up.
One bag per won item.
Green ReadyCheck means that the player has won the **SoftRes**erved item.

## TODO
- [ ] Add compatibility with Atlasloot (for linking items manually.)
    * For now you can "only" use itemlinks from CHAT or your BAG when you manually enter the items.