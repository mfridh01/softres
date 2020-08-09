## v0.0.2-beta
- 0001 - Added functionality to "Cancel Everything" button.  
- 0002 - SoftReserved item, tie-rolls.  
- 0003 - Tie-Rolls became SoftRes rolls.  
- 0004 - Anyone could win on Tie-Rolls.  
- 0005 - Fixed the penalty for MS transfered to OS.
- 0006 - Added option for resetting loot-penalties.
- 0007 - Added buttons for sorting SoftReservation list.

### 0001
When a winner is announced, that player automaticly gets that item recorded as a won item.  
If it's a SoftReserved item, it gets checked as won.  
If it's a normal won item, that item gets added to the players won items table.  
With this fix, when pressing the cancel button, the announced item is removed again from the player.  

### 0002
When two or more elegible players rolls the same value on a SoftReserved item, there's a "Tie-Roll".  
Earlier, anyone who had SoftReserved the announced item, could roll on that Tie-roll.  
**SoftRes** will now only read the rolls from the players who rolled a tie.

### 0003
When two or more elegible players rolls the same value on a none-SoftReserved item, there's a "Tie-Roll".  
When no players rolled on that roll, the roll got changed into a SoftRes roll.  
What that meant was that the player who won that roll, got the SoftReserved item as received, and could not roll on the item if it dropped.  
That is now fixed.  

### 0004
On a none-SoftReserved "Tie-Roll", anyone could roll and win.  
**SoftRes** should now only read the rolls from the "Tie-Rollers".  

### 0005
When you have won an item on MS, and roll on OS items, the MS penalty gets transfered over to the OS roll.
And vise versa.
This is now fixed.

### 0006
If you press "Edit Loot", there is now an option for resetting loot-penalties.  
What this button does is that it toggles the penalty flag for that item to false.  
It will still say MS or OS, but the penalty will not be counted for the items.  
This will only trigger for the currently won items, not future items.  
You still have to change the configuration to 0 penalty if you want future items to not give penalties.
After this, if you want to change it back, you will have to manually do this per player / item.

### 0007 - Not done yet.
Add sorting-functionality for the SoftReservation list.

## v0.0.1-beta
**SoftRes** went public in beta status.