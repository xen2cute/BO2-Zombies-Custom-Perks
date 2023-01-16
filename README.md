# BO2 Zombies Custom Perk Machines


## Features 
- Adds Perk-A-Colas with custom perks to all the zombies maps. 

Checklist:
- ✅ TranZit
- ✅ Town 
- ✅ Farm 
- ✅ Nuketown
- ❌ Mob of The Dead 
- ✅ Buried 
- ✅ Origins (the locations are a bit messy)
- ❌ Die Rise




## Instructions to download 
1. Download the file in the precompiled folder
2. Move the file to %localappdata%\Plutonium\storage\t6\scripts\zm

### Custom Perks Available
- PhD Flopper - immunity to fall damage and explosions and create an explosion that kills zombise upon diving to prone
- Widow's Wine - deals damage to zombeis that attack you and slows them down
- Thunder Wall - launches nearby enemies into the air upon being attacked by 5 or more zombies
- Dying Wish - gives a second chance if you die
- Electric Cherry - generates an electric shockwave upon reload
- Ammo Regen - slowly regenerates ammunation 
- Executioner's Edge- gives melee attacks a one hit kill at any round 
- Burn Heart - ignore lava damage
- Downer's Delight - longer bleedout time and use last weapon held in last stand 
- Victorious Turtle - allows riot shield to block from all directions
- Mule (on maps that dont have it) - additional primary weapon
- Bloodthirst - Gain health when killing zombies and can reach a max of 320 health 
- Rampage - 20% chance of gaining one shot kill for 15 seconds upon killing a zombie 
- Guarding Strike - 10% chance of becoming invulnerable for 5 seconds upon killing a zombie
- Headshot Mayhem - Extra damage and points for headshots. 15% chance for a headshot kill to explode and kill surrounding zombies


## Pictures of the Perk-A-Colas
### TranZit 

No pictures yet

### Buried 

No pictures yet

### Town 

No pictures yet

### Farm

![farm-custom-perks](https://user-images.githubusercontent.com/71220264/210157415-965042cf-6e04-4d80-9a01-0e796fac27cf.gif)

### Nuketown

![nuketown-custom-perks](https://user-images.githubusercontent.com/71220264/210157416-def4b24f-c561-4b64-88cf-e337dd360490.gif)

### MOTD

Perk-a-colas not added yet

### Origins

No pictures yet

### Die Rise

Perk-a-colas not added yet

## Other notes
For Die Rise and MOTD, although I haven't added the perk machines yet, they can still be obtained by using the perk test function, when you spawn in you can press a certain button and you will be given all the perks. I can't guarantee that everything will work correctly however. 

If you wish to change the position of the perk add these two functions below and add this line to the OnPlayerSpawned function.
```
self thread doGetposition();
```
```
doGetposition() 
{
	self endon ("disconnect"); 
	self endon ("death"); 
	print_pos = 1;
	if (print_pos==1)
	{
		for(;;)
		{
			self.corrected_angles = corrected_angles(self.angles);
			self iPrintln("Angles: "+self.corrected_angles+"\nPosition: "+self.origin);
			wait 0.5;
		}
	}
}
corrected_angles(angles)
{
	if(angles[1] < 0)
	{
		angles = angles + (0, 90, 0);
		if(angles[1] < 0)
		{
			angles = angles + (0, 360, 0);
		}
	}
	else
	{
		angles = angles + (0, 90, 0);
	}
	return angles;
}
```