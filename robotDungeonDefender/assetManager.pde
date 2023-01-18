/*
A space where asset related loading can be managed
type - subType/s - ... - stateOfTexture
*/
PImage missingTexture;

PImage robotPortrait_0;PImage robotPortrait_1;
PImage orcPortrait_0;PImage orcPortrait_1;

PImage tile_volume_wall;
PImage tile_volume_door;
PImage tile_volume_exit;
PImage tile_volume_entrance;
PImage tile_volume_fireTrap_active;
PImage tile_volume_fireTrap_inactive;
PImage tile_volume_spikeTrap_active;
PImage tile_volume_spikeTrap_inactive;
PImage tile_volume_brainCase;
PImage tile_volume_buildDesk;
PImage tile_floor_slab;

PImage enemy_orc_static;
PImage enemy_goblin_static;
PImage enemy_shieldBearer_static;
PImage enemy_berserker_static;
PImage enemy_brute_static;
PImage enemy_sprinter_static;
PImage enemy_warlord_static;
PImage enemy_beast_static;


void loadAll(){
    loadAllTextures();
    loadAllSounds();
}


void loadAllTextures(){
    loadTextures_Portaits();
    loadTextures_Entities();
    loadTextures_Tiles();
    loadTextures_Menus();
    loadTextures_Misc();
}
void loadAllSounds(){
    loadSounds_BackgroundMusic();
    loadSounds_ClickEffects();
    loadSounds_Misc();
}


void loadTextures_Portaits(){
    loadTextures_RobotPortait();
    loadTextures_OrcPortait();
}


void loadTextures_RobotPortait(){
    robotPortrait_0 = loadImage("robotPortrait_0.png");
    robotPortrait_1 = loadImage("robotPortrait_1.png");
}
void loadTextures_OrcPortait(){
    orcPortrait_0 = loadImage("orcPortrait_0.png");
    orcPortrait_1 = loadImage("orcPortrait_1.png");
}


void loadTextures_Entities(){
    loadTextures_OrcClan();
    //loadTextures_FishClan();
    //...
}
void loadTextures_Menus(){
    //pass
}
void loadTextures_Tiles(){
    loadTextures_Ceilings();
    loadTextures_Volumes();
    loadTextures_Floors();
}
void loadTextures_Misc(){
    loadTextures_missingTexture();
}


void loadTextures_OrcClan(){
    loadTextures_Orc();
    loadTextures_Goblin();
    loadTextures_ShieldBearer();
    loadTextures_Berserker();
    loadTextures_Brute();
    loadTextures_Sprinter();
    loadTextures_Warlord();
    loadTextures_Beast();
}
void loadTextures_FishClan(){
    //...
}


void loadTextures_Ceilings(){
    //pass
}
void loadTextures_Volumes(){
    loadTextures_volume_brainCase();
    loadTextures_volume_buildDesk();
    loadTextures_volume_fireTrap();
    loadTextures_volume_spikeTrap();
    loadTextures_volume_wall();
    loadTextures_volume_door();
    loadTextures_volume_exit();
    loadTextures_volume_entrance();
}
void loadTextures_Floors(){
    loadTextures_floor_slab();
}


void loadTextures_volume_wall(){
    tile_volume_wall = loadImage("tile_volume_wall.png");
}
void loadTextures_volume_door(){
    tile_volume_door = loadImage("tile_volume_door.png");
}
void loadTextures_volume_exit(){
    tile_volume_exit = loadImage("tile_volume_exit.png");
}
void loadTextures_volume_entrance(){
    tile_volume_entrance = loadImage("tile_volume_entrance.png");
}
void loadTextures_volume_brainCase(){
    tile_volume_brainCase = loadImage("tile_volume_brainCase.png");
}
void loadTextures_volume_buildDesk(){
    tile_volume_buildDesk = loadImage("tile_volume_buildDesk.png");
}
void loadTextures_volume_spikeTrap(){
    tile_volume_spikeTrap_active   = loadImage("tile_volume_spikeTrap_active.png");
    tile_volume_spikeTrap_inactive = loadImage("tile_volume_spikeTrap_inactive.png");
}
void loadTextures_volume_fireTrap(){
    tile_volume_fireTrap_active   = loadImage("tile_volume_fireTrap_active.png");
    tile_volume_fireTrap_inactive = loadImage("tile_volume_fireTrap_inactive.png");
}


void loadTextures_floor_slab(){
    tile_floor_slab = loadImage("tile_floor_slab.png");
}


void loadTextures_missingTexture(){
    missingTexture = loadImage("missingTexture.png");
}


void loadTextures_Orc(){
    enemy_orc_static = loadImage("enemy_orc_static.png");
}
void loadTextures_Goblin(){
    enemy_goblin_static = loadImage("enemy_goblin_static.png");
}
void loadTextures_ShieldBearer(){
    enemy_shieldBearer_static = loadImage("enemy_shieldBearer_static.png");
}
void loadTextures_Berserker(){
    enemy_berserker_static = loadImage("enemy_berserker_static.png");
}
void loadTextures_Brute(){
    enemy_brute_static = loadImage("enemy_brute_static.png");
}
void loadTextures_Sprinter(){
    enemy_sprinter_static = loadImage("enemy_sprinter_static.png");
}
void loadTextures_Warlord(){
    enemy_warlord_static = loadImage("enemy_warlord_static.png");
}
void loadTextures_Beast(){
    enemy_beast_static = loadImage("enemy_beast_static.png");
}




void loadSounds_BackgroundMusic(){
    //pass
}
void loadSounds_ClickEffects(){
    //pass
}
void loadSounds_Misc(){
    //pass
}