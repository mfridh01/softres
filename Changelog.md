## v0.0.5-beta
- 0018 - Added SoftReservees to tooltip.
- 0017 - Fixed "stuck" item when trading.
- 0016 - Added client mode.
- 0015 - Re-arranged the Changelog.
- 0014 - When importing a list, people not ON THAT list, will still get added to the addon. (without softres.)

### 0018
If you have the SoftRes add enabled, you will see who has SoftReserved the item you are hovering on the tooltip.

### 0017
When dragging an item from the bag and announcing it.  
When the item is traded, it wasn't removed from the SoftRes announcement window, thus the User couldn't continue without canceling the announcement.  
This is now fixed, so that when traded the item is removed.  
You could, however, right-click on the Icon of the announced item, to remove it from the window and the result is saved.

### 0016
Added a new mode, called Client Mode.  
Write "/softres client" to start it in that mode OR if you start the addon with "/softres show" and in the "Config" tab.  
You have an option to press "Client mode".  
In client mode, you can't press any other buttons or change any values.  
Click the "SoftRes List" and press the "Request List" button, to get the current list and ruleset for the SoftRes run.  
When an item is announced, you will see it in the item-box and can easily roll for it.

### 0015
Re-arranged the Changelog (this file).  
Added the latest on top.  

### 0014
When importing a list from example "softres.it", everyone who is not ON that list but IN the raid gets added to the list on the addon.  
Important to know is that if anyone spelled their name wrong on the "softres.it" list, that player will be added as a player without softres.  
AND the softres with the wrong name, will still be ON the addon list. (but easily recognized by being grayed out).

## v0.0.4-beta
- 0013 - Added a button "Missing SoftRes" to the bottom of the addon.
- 0012 - Added a confirmation window when you are posting the rules.
- 0011 - Changed text on "Scan SoftRes" when scanning.
- 0010 - Added List import feature.

### 0013
Added a button "Missing SoftRes" to the bottom of the addon, while the scanner is active.
Pressing this button will announce to the raid who has not reserved an item.

### 0012
Added a confirmation window for announcing the rules.
* Yes = Will post the rules.
* Yes & Scan = Will post the rules and start the chat-scanner.
* No = Close the window.

### 0011
When the scanner is active, the button will say "Stop Scanning" instead of "Scanning".
To make it more clear what the button is doing.

### 0010
Added a feature for import of lists.
Supported list is http://softres.it list.
* Usage: Use the sites list as usual and when done, you click the "Copy to WeakAura" button.
* In this addon you click the "Import" button. Choose the softres.it in the dropdown.
* Paste the copied string into the list and press "Import List".
**!! WARNING !!**
If any name is spelled wrong, that player will not work ingame. This is not SoftRes Addons fault.

## v0.0.3-beta
- 0009 - Added a button for announcing the SoftReserved items.
- 0008 - Fixed the issue with MS penalty, transfered to OS.

### 0009
There has been many requests for a button to announce the soft-reserved items.
On Tab 1, press the "SoftRes" button in the middle for announce the reservations.
"Rules", is still the "Announce rules" button and will activate the scanner, as before.

### 0008
The MS penalties were activated even though they shouldn't.
This have been fixed (again).
Thanks to "rylix3" for all the testing.

## v0.0.2-beta
- 0007 - Added a confirmation whisper.
- 0006 - Added option for resetting loot-penalties.
- 0005 - Fixed the penalty for MS transfered to OS.
- 0004 - Anyone could win on Tie-Rolls.  
- 0003 - Tie-Rolls became SoftRes rolls.  
- 0002 - SoftReserved item, tie-rolls.  
- 0001 - Added functionality to "Cancel Everything" button.  

### 0007
When you close the scanner of SoftReservations, a popup-window will show where you can choose to send a confirmation to everyone or not.  
If a player hasn't made a reservation, that player will get a whisper that says so. This is to give that player a chance to speak up.

### 0006
If you press "Edit Loot", there is now an option for resetting loot-penalties.  
What this button does is that it toggles the penalty flag for that item to false.  
It will still say MS or OS, but the penalty will not be counted for the items.  
This will only trigger for the currently won items, not future items.  
You still have to change the configuration to 0 penalty if you want future items to not give penalties.
After this, if you want to change it back, you will have to manually do this per player / item.

### 0005
When you have won an item on MS, and roll on OS items, the MS penalty gets transfered over to the OS roll.
And vise versa.
This is now fixed.

### 0004
On a none-SoftReserved "Tie-Roll", anyone could roll and win.  
**SoftRes** should now only read the rolls from the "Tie-Rollers".  

### 0003
When two or more elegible players rolls the same value on a none-SoftReserved item, there's a "Tie-Roll".  
When no players rolled on that roll, the roll got changed into a SoftRes roll.  
What that meant was that the player who won that roll, got the SoftReserved item as received, and could not roll on the item if it dropped.  
That is now fixed.  

### 0002
When two or more elegible players rolls the same value on a SoftReserved item, there's a "Tie-Roll".  
Earlier, anyone who had SoftReserved the announced item, could roll on that Tie-roll.  
**SoftRes** will now only read the rolls from the players who rolled a tie.

### 0001
When a winner is announced, that player automaticly gets that item recorded as a won item.  
If it's a SoftReserved item, it gets checked as won.  
If it's a normal won item, that item gets added to the players won items table.  
With this fix, when pressing the cancel button, the announced item is removed again from the player.  

## v0.0.1-beta
**SoftRes** went public in beta status.