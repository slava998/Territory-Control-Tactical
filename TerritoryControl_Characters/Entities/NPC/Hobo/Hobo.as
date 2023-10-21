#include "RunnerCommon.as"
#include "Help.as";
#include "Hitters.as";
#include "Requirements.as";
#include "ShopCommon.as";

const string[] firstnames =
{
	"Kevin",
	"Eughene",
	"Lawrence",
	"Macaulay",
	"Johnny",
	"Steve",
	"Sid",
	"Johnny",
	"Jethro",
	"Nelson",
	"Bobby",
	"Harry",
	"Barry",
	"Jerry",
	"Garry",
	"Bohdanu"
};

const string[] surnames =
{
	"Bobington",
	"Culkin",
	"Stud",
	"Garbel",
	"Bud",
	"Nelson",
	"Snot",
	"Aqualung",
	"Ugh",
	"Dump"
};

const string[] soundsTalk =
{
	"MigrantHmm.ogg",
	"drunk_fx2.ogg",
	"drunk_fx3.ogg",
	"drunk_fx4.ogg"
};

const string[] soundsDanger =
{
	"trader_scream_0.ogg",
	"trader_scream_1.ogg",
	"trader_scream_2.ogg"
};

const string[] textsIdle =
{
	"give me ya money 'itch",
	"c'mere here ya shit",
	"oi ya shit",
	"ay give me ya stuff",
	"did ya brin' the wine",
	"let's 'eat up 'arry tomorra",
	"aye, we'll fuck him up",
	"hav ya seen garry lately?",
	"gnarly",
	"yar",
	"arrrr",
	"*gurgle*",
	"ayy shit!",
	"psftush",
	"ohoho",
	"ya bloody idiot",
	"damn right innit?",
	"wanna fight ya cunt?",
	"sit on ya arse",
	"ill bash ye fookin 'ead in i sware on me mum"
};

const string[] textsDanger =
{
	"ya weenie 'lil shit",
	"i'll get ya asshole",
	"kill yarself",
	"get out of here ya weenie 'lil shit",
	"so wanna fight huh?",
	"give me ya money 'itch",
	"c'mere here ya shit",
	"oi ya shit",
	"aye, we'll fuck him up",
	"yar",
	"arrrr",
	"ayy shit!",
	"ya bloody idiot",
	"damn right innit?",
	"wanna fight ya cunt?",
	"sit on ya arse",
	"ill bash ye fookin ead in i sware on me mum",
	"ow shid"
};

const string[] textsWon =
{
	"put me 'ack ya shitbag",
	"go to hell",
	"scrub",
	"na give me ya money",
	"oi ya shit",
	"ay give me ya stuff",
	"aye, we did fuck him up",
	"yar",
	"arrrr",
	"*gurgle*",
	"ayy shit!",
	"ya bloody idiot",
	"damn right innit?",
	"wanna fight ya cunt?",
	"sit on ya arse"
};

void onInit(CBlob@ this)
{
	Random@ rand = Random(this.getNetworkID());
	string name = firstnames[rand.NextRanged(firstnames.length)] + " " + surnames[rand.NextRanged(surnames.length)];
	this.set_string("trader name", name);

	this.getShape().SetRotationsAllowed(false);
	this.set_f32("gib health", -2.0f);
	this.set_f32("crak_effect", 1.00f);
	this.set_f32("drunk_effect", 4.00f);
	this.Tag("flesh");
	this.Tag("migrant");
	this.Tag("human");
	this.getBrain().server_SetActive(true);

	this.set_u32("nextTalk", getGameTime() + XORRandom(60));
	this.set_u32("nextFood", 0);
	this.set_u32("shop_space", 0);

	this.addCommandID("traderChat");

	addTokens(this); //colored shop icons

	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_string("shop description", name + " the Hobo");
	this.setInventoryName(name + " the Hobo");
	this.set_u8("shop icon", 25);

	this.set_u32("lastDanger", 0);

	if (rand.NextRanged(100) < 50)
	{
		ShopItem@ s = addShopItem(this, "honking shite", "$klaxon$", "klaxon", "throw it away");
		AddRequirement(s.requirements, "coin", "", "Coins", 50 + rand.NextRanged(500));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 50)
	{
		ShopItem@ s = addShopItem(this, "sticky stick", "$nightstick$", "nightstick", "a stick for beating up");
		AddRequirement(s.requirements, "coin", "", "Coins", 50 + rand.NextRanged(150));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 50)
	{
		ShopItem@ s = addShopItem(this, "poppin shit", "$icon_firework$", "firework", "the main thing is to move fucking away when you activate");
		AddRequirement(s.requirements, "coin", "", "Coins", 75 + rand.NextRanged(200));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 30)
	{
		ShopItem@ s = addShopItem(this, "bitch", "$icon_trader$", "trader", "huh");
		AddRequirement(s.requirements, "coin", "", "Coins", 500 + rand.NextRanged(2000));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 5)
	{
		ShopItem@ s = addShopItem(this, "guy", "$icon_hobo$", "hobo", "fuck off");
		AddRequirement(s.requirements, "coin", "", "Coins", 200 + rand.NextRanged(2000));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 20)
	{
		ShopItem@ s = addShopItem(this, "nuke", "$icon_mininuke$", "mat_dirt-10", "get fucked");
		AddRequirement(s.requirements, "coin", "", "Coins", 1000 + rand.NextRanged(10000));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 20)
	{
		ShopItem@ s = addShopItem(this, "gae", "$icon_princess$", "princess", "found him hanging around the tannhauser gate");
		AddRequirement(s.requirements, "coin", "", "Coins", 69 + rand.NextRanged(10000));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 25)
	{
		ShopItem@ s = addShopItem(this, "cat", "$icon_kitten$", "badger", "yea");
		AddRequirement(s.requirements, "coin", "", "Coins", 250 + rand.NextRanged(500));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}
	if (rand.NextRanged(100) < 30)
	{
		ShopItem@ s = addShopItem(this, "same sheeeeeesht parody", "$macrogun$", "macrogun", "dumb toy shot mAh nosee offf");
		AddRequirement(s.requirements, "coin", "", "Coins", 3500 + rand.NextRanged(3000));
		s.buttonwidth = 2;
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 2);
	}

	if (rand.NextRanged(100) < 40)
	{
		ShopItem@ s = addShopItem(this, "boots that smell of piss", "$icon_rendeboots$", "rendeboots", "old pair of shoes i won from a chicken");
		AddRequirement(s.requirements, "coin", "", "Coins", 150 + rand.NextRanged(500));
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 30)
	{
		ShopItem@ s = addShopItem(this, "dichlorvos", "$icon_mustard$", "mat_mustard-50", "ok so now listen carefully my dear this is illegal as fUCK");
		AddRequirement(s.requirements, "coin", "", "Coins", 170);
		s.spawnNothing = true;
		this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 50)
	{
			ShopItem@ s = addShopItem(this, "disc", "$musicdisc$", "musicdisc", "the best disc I could find in the trash");
			AddRequirement(s.requirements, "coin", "", "Coins", 40);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 30)
	{
			ShopItem@ s = addShopItem(this, "jetpack", "$icon_jetpack$", "jetpack", "this thihng almost killed mE");
			AddRequirement(s.requirements, "coin", "", "Coins", 290 + rand.NextRanged(50));
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 40)
	{
			ShopItem@ s = addShopItem(this, "zoomzoom", "$icon_binoculars$", "binoculars", "i call it zOom zoOm");
			AddRequirement(s.requirements, "coin", "", "Coins", 190 + rand.NextRanged(40));
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 50)
	{
			ShopItem@ s = addShopItem(this, "ligter", "$icon_lighter$", "lighter", "I quit smoking a long time ago, crak is bettar'");
			AddRequirement(s.requirements, "coin", "", "Coins", 100 + rand.NextRanged(15));
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 20)
	{  
		   	ShopItem@ s = addShopItem(this, "plush shit", "$icon_sugoma$", "amogusplushie", "stupid kids always buy them and then throw them away");
			AddRequirement(s.requirements, "coin", "", "Coins", 50 + rand.NextRanged(1000));
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 40)
	{
		if (rand.NextRanged(100) < 60)
		{
				ShopItem@ s = addShopItem(this, "gun", "$revolver$", "revolver", "I hope you're not going to kill me with this for money?  I am poor");
				AddRequirement(s.requirements, "coin", "", "Coins", 40  + rand.NextRanged(15));
				s.spawnNothing = true;
				this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}
		else
		{
				ShopItem@ s = addShopItem(this, "black gun", "$fuger$", "fuger", "this gun is saturated with radical ideas");
				AddRequirement(s.requirements, "coin", "", "Coins", 200  + rand.NextRanged(100));
				s.spawnNothing = true;
				this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}
		{
			ShopItem@ s = addShopItem(this, "amo (20)", "$icon_pistolammo$", "mat_pistolammo-20", "great for my pistals");
			AddRequirement(s.requirements, "coin", "", "Coins", 30);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}
	}

	if (rand.NextRanged(100) < 25)
	{  
			ShopItem@ s = addShopItem(this, "pape", "$bp_energetics$", "bp_energetics", "you can wipe your ass with it", true);
			AddRequirement(s.requirements, "coin", "", "Coins", 2500 +  rand.NextRanged(1600));
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	if (rand.NextRanged(100) < 25)
	{  
			ShopItem@ s = addShopItem(this, "pape", "$bp_weapons$", "bp_weapons", "I already have enough toilet paper", true);
			AddRequirement(s.requirements, "coin", "", "Coins", 3000 +  rand.NextRanged(2000));
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
	}

	else if (rand.NextRanged(100) < 40)
	{

		if (rand.NextRanged(100) < 70)
		{
			u32 cost = getRandomCost(@rand, 300, 500);
			ShopItem@ s = addShopItem(this, "sell boof", "$COIN$", "coin-" + cost, "ill take this giggly shit off yer hands fer " + cost + " coins.");
			AddRequirement(s.requirements, "blob", "boof", "Boof", 1);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}

		if (rand.NextRanged(100) < 50)
		{
			u32 cost = getRandomCost(@rand, 500, 700);
			ShopItem@ s = addShopItem(this, "sell crak", "$COIN$", "coin-" + cost, "ill take this cracker shit off yer hands fer " + cost + " coins.");
			AddRequirement(s.requirements, "blob", "crak", "Crak", 1);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}

		if (rand.NextRanged(100) < 50)
		{
			u32 cost = getRandomCost(@rand, 1000, 1500);
			ShopItem@ s = addShopItem(this, "sell rippio", "$COIN$", "coin-" + cost, "ill take this fucker shit off yer hands fer " + cost + " coins.");
			AddRequirement(s.requirements, "blob", "rippio", "Rippio", 1);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}

		if (rand.NextRanged(100) < 50)
		{
			u32 cost = getRandomCost(@rand, 500, 800);
			ShopItem@ s = addShopItem(this, "sell stim pill", "$COIN$", "coin-" + cost, "ill take this hedgehog shit off yer hands fer " + cost + " coins.");
			AddRequirement(s.requirements, "blob", "stimpill", "Stim pill", 1);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}

		if (rand.NextRanged(100) < 50)
		{
			u32 cost = getRandomCost(@rand, 500, 750);
			ShopItem@ s = addShopItem(this, "sell paxilon", "$COIN$", "coin-" + cost, "ill take this sleepy shit off yer hands fer " + cost + " coins.");
			AddRequirement(s.requirements, "blob", "paxilon", "Paxilon", 1);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}

		if (rand.NextRanged(100) < 50)
		{
			u32 cost = getRandomCost(@rand, 1500, 1750);
			ShopItem@ s = addShopItem(this, "sell fumes", "$COIN$", "coin-" + cost, "Ill take this smelly shit off yer hands fer " + cost + " coins.");
			AddRequirement(s.requirements, "blob", "fumes", "Fumes", 1);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}

		if (rand.NextRanged(100) < 50)
		{
			u32 cost = getRandomCost(@rand, 750, 1250);
			ShopItem@ s = addShopItem(this, "sell schisk", "$COIN$", "coin-" + cost, "ill take this schizo shit off yer hands fer " + cost + " coins.");
			AddRequirement(s.requirements, "blob", "schisk", "Schisk", 1);
			s.spawnNothing = true;
			this.set_u32("shop_space", this.get_u32("shop_space") + 1);
		}
	}
	
	u8 shop_width = 6;
	this.set_Vec2f("shop menu size", Vec2f(shop_width, 1+(Maths::Floor(this.get_u32("shop_space")/shop_width))));

	if (isServer())
	{
		this.server_setTeamNum(-1);
	}

	this.getCurrentScript().runFlags |= Script::tick_onscreen;
	this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;
	this.getCurrentScript().runProximityTag = "player";
	this.getCurrentScript().runProximityRadius = 320.0f;

	this.set_f32("voice pitch", 0.75f);
	this.getSprite().PlaySound("drunk_fx4");
}

void onChangeTeam(CBlob@ this, const int oldTeam)
{
	// reset shop colors
	addTokens(this);
}

void addTokens(CBlob@ this)
{
	int teamnum = this.getTeamNum();
	if (teamnum > 6) teamnum = 7;

	AddIconToken("$icon_fireboom$", "FireBoom.png", Vec2f(32, 32), 0, teamnum);
	AddIconToken("$icon_firejob$", "Firejob.png", Vec2f(16, 24), 0, teamnum);
	AddIconToken("$icon_firework$", "Firework.png", Vec2f(16, 24), 0, teamnum);
	AddIconToken("$icon_trader$", "TraderCoot.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_sawrocket$", "Material_SawRocket.png", Vec2f(8, 24), 0, teamnum);
	AddIconToken("$icon_illegalshit$", "IllegalGunPart.png", Vec2f(10, 6), 0, teamnum);
	AddIconToken("$icon_crakgas$", "Material_Crak.png", Vec2f(16, 16), 0, teamnum);
}

int getRandomCost(Random@ random, int min, int max, int rounding = 10)
{
	return Maths::Round(f32(min + random.NextRanged(max - min)) / rounding) * rounding;
}

void onTick(CBlob@ this)
{
	if (!this.hasTag("dead"))
	{
		if (this.getHealth() <= 0)
		{
			this.Tag("dead");
			return;
		}

		uint time = getGameTime();
		if (time >= this.get_u32("nextTalk"))
		{
			this.set_u32("nextTalk", time + (30 * 10) + XORRandom(30 * 20));

			u32 lastDanger = this.get_u32("lastDanger");
			u16 dangerBlobNetID = this.get_u16("danger blob");

			bool danger = dangerBlobNetID > 0 && time < (lastDanger + (30 * 30));

			string text = "";
			if (danger)
			{
				text = textsDanger[XORRandom(textsDanger.size())];
				this.getSprite().PlaySound(soundsDanger[XORRandom(soundsDanger.size())], 0.75f, 0.75f);
			}
			else
			{
				if (time - this.get_u32("lastDanger") < 30 * 60)
				{
					text = textsWon[XORRandom(textsWon.size())];
				}
				else
				{
					text = textsIdle[XORRandom(textsIdle.size())];
					this.getSprite().PlaySound(soundsTalk[XORRandom(soundsTalk.size())], 0.75f, 1.00f);
				}
			}

			if (isServer())
			{
				CBitStream stream;
				stream.write_string(text);
				this.SendCommand(this.getCommandID("traderChat"), stream);
			}
		}

		CBlob@[] blobs;
		getMap().getBlobsInRadius(this.getPosition(), 96, @blobs);

		int index = -1;
		f32 s_dist = 900000.00f;
		u8 myTeam = this.getTeamNum();

		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ b = blobs[i];
			u8 team = b.getTeamNum();

			f32 dist = (b.getPosition() - this.getPosition()).LengthSquared();

			if (team != myTeam && dist < s_dist && b.hasTag("flesh") && !b.hasTag("dead"))
			{
				s_dist = dist;
				index = i;
			}
		}

		if (index != -1)
		{
			CBlob@ target = blobs[index];

			if (target !is null)
			{
				if (this.get_u32("nextThrow") < time)
				{
					if (XORRandom(100) < 2)
					{
						this.set_u32("nextTalk", 0);

						Vec2f dir = target.getPosition() - this.getPosition();
						this.SetFacingLeft(dir.x < 0);

						bool isAttached = this.isAttached();

						if (isClient())
						{
							if (isAttached) this.getSprite().PlaySound(soundsDanger[XORRandom(soundsDanger.size())], 0.75f, 0.75f);
						}

						if (isServer())
						{
							f32 dist = dir.Length();
							dir.Normalize();

							CBlob@ rock = server_CreateBlob("hobo_junk", this.getTeamNum(), this.getPosition());
							if (rock !is null)
							{
								rock.setVelocity((dir * 6.00f) + Vec2f(0, -3));
								this.set_u32("nextThrow", time + (isAttached ? 20 : (30 + XORRandom(90))));
							}
						}
					}
				}
			}
		}
	}
}

void onSetPlayer(CBlob@ this, CPlayer@ player)
{
	this.set_bool("shop available", false);

	if (player !is null) player.SetScoreboardVars("ScoreboardIcons.png", 20, Vec2f(16, 16));
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	this.set_bool("shop available", this.isOverlapping(caller) || this.isAttachedTo(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("traderChat"))
	{
		this.Chat(params.read_string());
	}
	else if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("ChaChing.ogg", 1.00f, 0.75f);

		u16 caller, item;
		if (!params.saferead_netid(caller) || !params.saferead_netid(item)) return;

		string name = params.read_string();
		CBlob@ callerBlob = getBlobByNetworkID(caller);

		if (callerBlob is null) return;

		if (isServer())
		{
			string[] spl = name.split("-");

			if (spl[0] == "coin")
			{
				CPlayer@ callerPlayer = callerBlob.getPlayer();
				if (callerPlayer is null) return;

				callerPlayer.server_setCoins(callerPlayer.getCoins() +  parseInt(spl[1]));
			}
			else if (name.findFirst("mat_") != -1)
			{
				CPlayer@ callerPlayer = callerBlob.getPlayer();
				if (callerPlayer is null) return;

				CBlob@ mat = server_CreateBlob(spl[0]);

				if (mat !is null)
				{
					mat.Tag("do not set materials");
					mat.server_SetQuantity(parseInt(spl[1]));
					if (!callerBlob.server_PutInInventory(mat))
					{
						mat.setPosition(callerBlob.getPosition());
					}
				}
			}
			else
			{
				CBlob@ blob = server_CreateBlob(spl[0], callerBlob.getTeamNum(), this.getPosition());
				if (name == "oof" && isServer()) this.server_SetHealth(0.5f);

				if (blob is null || callerBlob is null) return;

				if (!blob.canBePutInInventory(callerBlob))
				{
					callerBlob.server_Pickup(blob);
				}
				else if (callerBlob.getInventory() !is null && !callerBlob.getInventory().isFull())
				{
					callerBlob.server_PutInInventory(blob);
				}
			}
		}
	}
}

void onDie(CBlob@ this)
{
	if (isServer())
	{
		server_DropCoins(this.getPosition(), XORRandom(1500));
	}
}

void onReload(CSprite@ this)
{
	this.getConsts().filename = "Hobo.png";
}

void onGib(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	Vec2f pos = blob.getPosition();
	Vec2f vel = blob.getVelocity();
	vel.y -= 3.0f;
	f32 hp = Maths::Min(Maths::Abs(blob.getHealth()), 2.0f) + 1.0;
	if(!isClient()){return;}
	CParticle@ Gib1 = makeGibParticle("Entities/Special/WAR/Trading/TraderGibs.png", pos, vel + getRandomVelocity(90, hp, 80), 0, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall");
	CParticle@ Gib2 = makeGibParticle("Entities/Special/WAR/Trading/TraderGibs.png", pos, vel + getRandomVelocity(90, hp - 0.2, 80), 1, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall");
	CParticle@ Gib3 = makeGibParticle("Entities/Special/WAR/Trading/TraderGibs.png", pos, vel + getRandomVelocity(90, hp, 80), 2, 0, Vec2f(16, 16), 2.0f, 0, "/BodyGibFall");
}


bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return this.hasTag("dead") || this.getPlayer() is null;
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	this.set_u32("lastDanger", getGameTime());
	this.set_u16("danger blob", hitterBlob.getNetworkID());
	this.set_u32("nextTalk", this.get_u32("nextTalk") - (30 * damage * 13));

	if (customData == Hitters::suicide) damage = 0;

	return damage;
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	this.set_u32("nextThrow", 0);
	this.set_u32("lastDanger", 0);
	if (attached !is null) this.set_u16("danger blob", attached.getNetworkID());
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();

	if (blob.hasTag("dead"))
	{
		if (!this.isAnimation("dead")) this.PlaySound("trader_death.ogg", 1.00f, 0.75f);

		this.SetAnimation("dead");

		if (blob.isOnGround())
		{
			this.SetFrameIndex(0);
		}
		else
		{
			this.SetFrameIndex(1);
		}

		return;
	}

	Vec2f pos = blob.getPosition();
	Vec2f aimpos = blob.getAimPos();
	bool ended = this.isAnimationEnded();

	bool danger = getGameTime() < (blob.get_u32("lastDanger") + (30 * 30));

	if ((blob.isKeyPressed(key_left) || blob.isKeyPressed(key_right)) || (blob.isOnLadder() && (blob.isKeyPressed(key_up) || blob.isKeyPressed(key_down))))
	{
		if (danger)
		{
			this.SetAnimation("dangerwalk");
		}
		else
		{
			this.SetAnimation("walk");
		}
	}
	else if (ended)
	{
		this.SetAnimation("default");
	}
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if (blob is null) return;
	if (this.hasTag("dead")) return;

	if (blob.getName() == "mat_mithrilenriched" && blob.getQuantity() > 5)
	{
		if (isServer() && !this.hasTag("transformed"))
		{
			CBlob@ blob = server_CreateBlob("hoob", this.getTeamNum(), this.getPosition());
			if (this.getPlayer() !is null) blob.server_SetPlayer(this.getPlayer());

			this.Tag("transformed");
			this.server_Die();
		}
		else
		{
			ParticleZombieLightning(this.getPosition());
		}
	}
}
