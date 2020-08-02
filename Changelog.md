## v0.0.2-beta
- 0001 - Added functionality to "Cancel Everything" button.  
- 0002 - SoftReserved item, tie-rolls.  
- 0003 - Tie-Rolls became SoftRes rolls.  
- 0004 - Anyone could win on Tie-Rolls.  

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

## v0.0.1-beta
**SoftRes** went public in beta status.