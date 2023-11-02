// A script by TFlippy & Pirate-Rob
#include "Requirements.as";
#include "MakeMat.as";
#include "BuilderHittable.as";
#include "Survival_Structs.as";
const u8 inventory_size = 2 * 3;

void onInit(CBlob@ this)
{
	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	this.set_TileType("background tile", CMap::tile_castle_back);

	this.Tag("builder always hit");
	this.Tag("extractable");
	this.Tag("change team on fort capture");
	
	this.getCurrentScript().tickFrequency = 30*5;
}


////////////////////////////////////////////////////////
//Coal mine and drillrig production code is duplicated here 
//This is necessary so that if a faction builds a factory, one building will tick instead of several buildings.

const string[] resources = 
{
	"mat_coal",
	"mat_iron",
	"mat_copper",
	"mat_stone",
	"mat_gold",
	"mat_sulphur",
	"mat_dirt"
};

const u8[] resourceYields = 
{
	10, //coal
	27,	//iron
	8,  //copper
	45, //stone
	24, //gold
	10, //sulphur
	16 //dirt
};

const string[] drillResources = 
{
	"mat_iron",
	"mat_copper",
	"mat_stone",
	"mat_gold",
	"mat_mithril"
};

const u8[] drillResourceYields = 
{
	18,
	18,
	36,
	18,
	9
};

void onTick(CBlob@ this)
{
	if (isServer())
	{	
		if(this.getTeamNum() > 6) return;
		
		u8 storages = findStorage(this.getTeamNum());
		
		TeamData@ team_data;
		GetTeamData(this.getTeamNum(), @team_data);
		if(team_data.team_mines > 0)
		{
			u8 index = XORRandom(resources.length);
			u32 amount = Maths::Max(1, Maths::Floor(XORRandom(resourceYields[index]) / storages)) * team_data.team_mines;
			//print(mod +  " " +amount);
			
			MakeMat(this, this.getPosition(), resources[index], amount);
		}
		
		if(team_data.team_drills > 0)
		{
			u8 drillIndex = XORRandom(drillResources.length - 1);
			u32 drillAmount = Maths::Max(1, Maths::Floor(XORRandom(drillResourceYields[drillIndex] * (f32(XORRandom(100)) / 40.00f)) / storages) * 1.67) * team_data.team_drills; // * 1.67 to make drill and coalmine tick frequency equal
			
			MakeMat(this, this.getPosition(), drillResources[drillIndex], drillAmount);
		}
	}
}
////////////////////////////////////////////////////////

u8 findStorage(u8 team)
{
	if (team >= 100) return 0;

	CBlob@[] blobs;
	getBlobsByName("stonepile", @blobs);

	CBlob@[] validBlobs;

	for (u32 i = 0; i < blobs.length; i++)
	{
		if (blobs[i].getTeamNum() == team && !blobs[i].getInventory().isFull())
		{
			validBlobs.push_back(blobs[i]);
		}
	}

	return validBlobs.length;
}

void onAddToInventory(CBlob@ this, CBlob@ blob)
{
	UpdateFrame(this);
}
void onRemoveFromInventory(CBlob@ this, CBlob@ blob)
{
	UpdateFrame(this);
}
void UpdateFrame(CBlob@ this)
{
	CSprite@ sprite = this.getSprite();
	if (sprite is null) return;
	
	Animation@ animation = sprite.getAnimation("default");
	if (animation is null) return;
	
	CInventory@ inv = this.getInventory();
	if (inv is null) return;
	
	sprite.animation.frame = u8((sprite.animation.getFramesCount() - 1) * (f32(inv.getItemsCount()) / f32(inventory_size)));
}