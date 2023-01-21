# BO2 Zombies Custom Perk Machines


## Features 
- Adds Perk-A-Colas with custom perks to all the zombies maps except Die Rise and MOTD. You can still get the perks through the test function which will give you all the perks.
- If you wish to change the position of a perk machine I have detailed how you may do so [here](https://github.com/Viren070/BO2-Zombies-Custom-Perk-Machines/blob/main/README.md#how-to-modify-perk-machine-position)

## Instructions to download 
1. Download the file in the compiled folder
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

![tranzit-custom-perks](https://github.com/Viren070/BO2-Zombies-Custom-Perk-Machines/raw/main/Images/TranZit/tranzit.gif)

### Buried 

![buried-custom-perks](https://github.com/Viren070/BO2-Zombies-Custom-Perk-Machines/raw/main/Images/Buried/buried.gif)

### Town 

![town-custom-perks](https://github.com/Viren070/BO2-Zombies-Custom-Perk-Machines/raw/main/Images/Town/town.gif)

### Farm

![farm-custom-perks](https://github.com/Viren070/BO2-Zombies-Custom-Perk-Machines/raw/main/Images/Farm/farm.gif)

### Nuketown

No pictures yet

### MOTD

Perk-a-colas not added yet

### Origins

No pictures yet

### Die Rise

Perk-a-colas not added yet


## How to modify perk machine position
If you wish to change the position of the perk machines or add new ones, add this line to your OnPlayerSpawned function:
```
self thread doGetposition();
```
and add these two functions to the code:
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
With this you can get the position and angles required to spawn a perk machine in the correct place. The next step is to edit the lines of code that look like this that can be found under the init_custom_map() function:
```
perk_system( "script_model", (847, -1037, 120), "zombie_vending_revive_on", ( 0, 326, 0 ), "custom", "mus_perks_sleight_sting", "Downer's Delight", 3000, "revive_light", "Downers_Delight","zombie_perk_bottle_revive" );
```
```
perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk, bottle)
```

```(847, -1037, 1200) / pos``` - the position

```( 0, 326, 0)` / angle`` - the angle, you will likely only need to change the middle value. 

The position and angles can be found using the code above.

Other parameters:

```"zombie_vending_revive_on / model" ```- the model to be used (only models that exist in the map can be used, use this [model list](https://pastebin.com/raw/bH8weGDP) to help

```"Downer's Delight" / name ``` - the name that appears in the hint when you approach the perk machine

```"Downers_Delight" / perk```- the actual perk, the names of which can be found under the drawshader_and_shadermove() function

```"zombie_perk_bottle_revive / bottle" ```- the perk bottle, the bottles names can be found [here](https://pastebin.com/aKBQg9RJ)






## Credits
whydoesanyonecare. I took the base code for the perk systems from [dog town plutonium](https://github.com/whydoesanyonecare/Plutonium-versions-of-T6-custom-survival-maps/blob/main/dog_town_plutonium.gsc)
