class volume{
    boolean isCollideable;
    String type;

    ArrayList<dynamicElement> dElements = new ArrayList<dynamicElement>();

    boolean vActive = false;     //Is the volume active (special effect for certain volumes -> activate with lever or manually)

    volume(){
        type = "none";
    }

    void display(PVector pos, float dim){
        //pass
    }
    void determineAction(tile cTile){
        /*
        Determines what this tile should do in a generation
        */
        progressTimers();
        updateDynamicElements();
        actionActivation(cTile);
        doAction(cTile);
    }
    void progressTimers(){
        /*
        Progresses cooldown timer +resets it
        */
    }
    void actionActivation(tile cTile){
        /*
        Determines if a tile's action should activate or not
        */
    }
    void doAction(tile cTile){
        /*
        Does the action of this tile, if it has one
        */
    }
    void updateDynamicElements(){
        /*
        Updates all dynamic elements in this tile
        */
        for(int i=0; i<dElements.size(); i++){
            dElements.get(i).update();
        }
    }
}


class brainCase extends volume{
    int points    = 0;      //Number of points currently stored here
    int pointsMax = 50;     //Number of points needed to be store in order to gain a new ability

    //#########
    //#################
    //##############################################
    //###
    //## HAVE ANIMATE AS A GLOWING BRAIN THAT FLICKERS AND BOBS EVERY NO AND THEN
    //###
    //###############################################
    //##################
    //##########

    brainCase(){
        isCollideable = true;
        type = "brainCase";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.8;
        rectMode(CENTER);
        fill(232, 121, 178);

        rect(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
    @Override
    void actionActivation(tile cTile){
        /*
        This tile will only activate of vActive && have enough points
        */
        if(vActive){    //When activated
            //Drain as many coins as needed for next tier, then deactivate
            int pointsNeeded = pointsMax -points;
            if(cEnviro.cLair.coins < pointsNeeded){
                //Cannot afford it
                points += cEnviro.cLair.coins;
                cEnviro.cLair.coins = 0;
            }
            else{
                //Can afford it (possibly with spare change)
                cEnviro.cLair.coins -= pointsNeeded;
                points += pointsNeeded;
            }
            vActive = false;
        }
    }
    @Override
    void doAction(tile cTile){
        /*
        This tile will consume 'points' and allow an upgrade to be selected
        Will deavtivate (vActove = false) itself after completing this action
        */
        if(points >= pointsMax){    //If have enough points...
            //Drain all points and bring up ability select screen
            points -= pointsMax;
            cEnviro.cLair.upgStation.makingChoice = true;
            cEnviro.switchToUpgrade();
        }
    }
}
class wall extends volume{
    //pass

    wall(){
        isCollideable = true;
        type = "wall";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.9;
        rectMode(CENTER);
        fill(80,80,80);

        rect(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
}
class spikeTrap extends volume{
    int dmg = 7;
    int duration = 2;       //How long trap stays active for
    int cooldown = 10;      //How long trap waits after being used before being able to be used again (starts from END of DURATION)
    int cdTimer  = 0;       //Times activation and cooldown

    boolean active = false;         //Is this trap currently doing its effect
    boolean cycleComplete = true;   //Whether this trap has completed its attack,active,cooldown,refreshed cycle yet

    spikeTrap(){
        isCollideable = false;
        type = "spikeTrap";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.5;
        rectMode(CENTER);
        fill(40,80,40);
        if(active){
            fill(255,0,0);}

        rect(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
    @Override
    void progressTimers(){
        if(!cycleComplete){
            cdTimer++;
        }
        boolean durationOver = cdTimer > duration;
        if(active && durationOver){
            active = false;
        }
        if(cdTimer > duration+cooldown){
            cycleComplete = true;
            cdTimer = 0;
        }
    }
    @Override
    void actionActivation(tile cTile){
        boolean enemiesPresent = cTile.enemies.size() > 0;
        if(enemiesPresent && cycleComplete){   //## ADD COOLDOWN CONDITION
            active = true;
            cycleComplete = false;
        }
    }
    @Override
    void doAction(tile cTile){
        if(active){
            for(int i=0; i<cTile.enemies.size(); i++){
                cTile.enemies.get(i).health -= dmg;
            }
        }
    }
}
class fireTrap extends volume{
    //pass

    fireTrap(){
        isCollideable = true;
        type = "fireTrap";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.8;
        rectMode(CENTER);
        fill(250,120,120);

        rect(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
    @Override
    void actionActivation(tile cTile){
        //pass
    }
    @Override
    void doAction(tile cTile){
        //pass
    }
}
class buildDesk extends volume{
    //pass

    buildDesk(){
        isCollideable = true;
        type = "buildDesk";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.95;
        rectMode(CENTER);
        fill(80,80,80);
        noStroke();

        ellipse(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
}
class door extends volume{
    boolean isPortal;   //Determines how connecting lines are shown in camera

    door(boolean portalDoor){
        isCollideable = false;
        type = "door";

        isPortal = portalDoor;
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.95;
        rectMode(CENTER);
        fill(145, 128, 126);

        rect(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
}
class exit extends volume{
    //pass

    exit(){
        isCollideable = false;
        type = "exit";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.95;
        rectMode(CENTER);
        fill(134, 156, 121);

        rect(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
}
class entrance extends volume{
    //pass

    entrance(){
        isCollideable = false;
        type = "entrance";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.95;
        rectMode(CENTER);
        fill(122, 121, 156);

        rect(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
}