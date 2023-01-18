class animator{
    /*
    Objects that can have animation can hold an animator instance
    When displaying, the animator is asked to display instead

    AAnimator works by;
    . Being given a set of frames
    . Told how much time between each frame
    . Keeping track its current frame in the the full cycle, and displaying the required image
    */
    ArrayList<PImage> imgFrames = new ArrayList<PImage>();
    int tFull;      //Total time of whole animation
    int tSingle;    //Time to be spent per frame image
    int tCurrent;   //Current time at

    animator(){
        //imgFrames.add(missingTexture);
        tFull    = 1;
        tSingle  = 1;
        tCurrent = 0;
    }

    void display(PVector pos, PVector dim){
        /*
        Displays the current animation it has
        This will loop when exceeding tFull
        */
        if(imgFrames.size() > 0){
            if(tCurrent >= tFull){
                tCurrent = 0;}
            int cFrameNum = floor((float)tCurrent / (float)tSingle);   //Frame number (from list) that currently needs to be shown
            displayFrame(imgFrames.get(cFrameNum), pos, dim);
            tCurrent++;
        }
    }
    void displayFrame(PImage cImage, PVector pos, PVector dim){
        /*
        Displays a given image
        */
        pushStyle();

        imageMode(CENTER);
        if(cImage != null){
            image(cImage, pos.x, pos.y, dim.x, dim.y);}

        popStyle();
    }


    void init_tile_volume_wall(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_wall);
    }
    void init_tile_volume_door(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_door);
    }
    void init_tile_volume_exit(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_exit);
    }
    void init_tile_volume_entrance(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_entrance);
    }
    void init_tile_volume_spikeTrap(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_spikeTrap_inactive);
    }
    void init_tile_volume_fireTrap(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_fireTrap_inactive);
    }
    void init_tile_volume_brainCase(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_brainCase);
    }
    void init_tile_volume_buildDesk(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_volume_buildDesk);
    }
    void init_tile_floor_slab(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(tile_floor_slab);
    }


    void init_enemy_orc_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_orc_static);
    }
    void init_enemy_goblin_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_goblin_static);
    }
    void init_enemy_shieldBearer_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_shieldBearer_static);
    }
    void init_enemy_berserker_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_berserker_static);
    }
    void init_enemy_brute_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_brute_static);
    }
    void init_enemy_sprinter_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_sprinter_static);
    }
    void init_enemy_warlord_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_warlord_static);
    }
    void init_enemy_beast_static(){
        imgFrames.clear();
        tFull   = 1;
        tSingle = 1;
        imgFrames.add(enemy_beast_static);
    }
}