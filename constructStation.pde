class constructStation{
    /*
    Holds details relating to construction and the construct menu
    Also stores temporary information about building

    Blueprints hold the location of given items to be placed and the items themselves (2 separate arrays)

    As a note on building, 
        . If a build project is 'SMALL' (e.g no moving of collideable objects) then can 
        do mid round whenever
        . If a build project is 'BIG' (e.g collideables moved or added) then as soon as the 
        blueprint is made the given map is 'closed for cleaning', meaning no entities can 
        enter it and entities currently inside it will slowly leave it (as they normally do), 
        and entities who have pathed to go through it will need to repath to go through the
        'substitute' room that has now been introduced (essentially a blank room with some 
        waiting room visuals as a gap closer). Once the build is done, everything will return 
        to normal and likewise the entities in the substitute room will leave slowly as they 
        normally would.

    Generally;
    Options = the type of set (e.g traps, utilities, etc)
    Choices = the things available in the given set (e.g arrow trap, pipe, etc)

    setChoice    = which MAIN type of item is selected (e.g blocker, trigger, utility, etc)
    chosenChoice = which SUB tyoe of item is selected (e.g which PARTICULAR blocker)

    Construction modes;
    0 = build
    1 = activate
    */
    //################################
    //## MAKE SPECIFIC TO GIVEN MAP ##
    //################################
    int nMode    = 0;   //Type of construction mode
    int nModeMax = 2;   //** Needs to be CHANGED when more construct modes are added

    int coinFloat = 0;  //Shows how much is being proposed to be spend

    int setChoice    = -1;
    int chosenChoice = -1;
    int setChoiceMax = 4;
    blueprint cBlueprint = new blueprint();   //The temporary blueprint used while blueprint is being made

    ArrayList<PVector> actMarkers = new ArrayList<PVector>();   //Activation markers

    PVector iRow  = new PVector(width/10.0, 3.0*height/10.0);   //Initial row position, left most, top most
    float boxSize = width/30.0;                                 //Width of a box (that the item is shown in)
    float bMultiSpacing = 1.2;                                  //Determines spacing of boxes through this multiplier

    constructStation(){
        //pass
    }

    void display(){
        if(nMode == 0){
            displayBuildMode();}
        if(nMode == 1){
            displayActivateMode();}
    }
    void displayBuildMode(){
        displayArrows();
        displayChoices();
        displayBlueprint();
        displayCoinFloat();
    }
    void displayActivateMode(){
        displayActivateMarkers(cEnviro.cLair.maps.get(cEnviro.cLair.cMap).startPos, cEnviro.cLair.maps.get(cEnviro.cLair.cMap).tileWidth);
    }
    void displayCoinFloat(){
        pushStyle();

        textSize(15);
        textAlign(CENTER, CENTER);
        noStroke();
        rectMode(CENTER);
        PVector cPos = new PVector(mouseX +15, mouseY -15);
        PVector dim  = new PVector(30,20);
        fill(180,180,180);
        rect(cPos.x, cPos.y, dim.x, dim.y);
        fill(0);
        text(coinFloat, cPos.x, cPos.y);

        popStyle();
    }
    void displayChoices(){
        /*
        Lists out choices in rows below the options
        */
        int chosenOne = checkChoiceSelection();                                                 //## BUG FIXING -> SHOWS HOVERED
        if(setChoice != -1){
            for(int i=0; i<setChoiceMax; i++){
                giveItem(setChoice, i).display( new PVector(iRow.x +bMultiSpacing*i*boxSize, iRow.y), new PVector(boxSize, boxSize) );
                if(i == chosenOne){                                                             //##
                    pushStyle();                                                                //##
                    rectMode(CENTER);                                                           //##
                    fill(0,0,255,75);                                                           //##
                    noStroke();                                                                 //##
                    rect(iRow.x +bMultiSpacing*i*boxSize, iRow.y, 0.6*boxSize, 0.6*boxSize);    //##
                    popStyle();                                                                 //## BUG FIXING -> SHOWS HOVERED
                }
            }
        }
    }
    void displayArrows(){
        /*
        Draws lines to each choice from the given option to signify which option is being viewed currently
        [] [X] [] []
            |           <- Output line
        -------         <- Main line
        |  |  |         <- Sub lines
        0  0  0
        */
        if(setChoice != -1){
            pushStyle();

            float mainOffset = 1.4;

            noFill();
            stroke(255);
            strokeWeight(4);
            //Output line
            line(iRow.x +(2.0*width/10.0)*setChoice +1.0*width/10.0, iRow.y -2.0*mainOffset*boxSize, iRow.x +(2.0*width/10.0)*setChoice +1.0*width/10.0, iRow.y -mainOffset*boxSize);
            
            //Main Line
            line(iRow.x, iRow.y -mainOffset*boxSize, 8.0*width/10.0, iRow.y -mainOffset*boxSize);
            //################
            //## CHANGE SO MAIN LINE TAKES THE MAX OF 8.0*WIDTH/10.0 (UP TO LAST BUTTON) OR I*BSPACING*BOXSIZE (SIZE OF ORDERED CHOICES, TOTAL LENGTH)
            //################

            //Sub Lines
            for(int i=0; i<setChoiceMax; i++){
                line(iRow.x +i*bMultiSpacing*boxSize, iRow.y -mainOffset*boxSize, iRow.x +i*bMultiSpacing*boxSize, iRow.y);
            }

            popStyle();
        }
    }
    void displayBlueprint(){
        cBlueprint.display( cEnviro.cLair.maps.get(cEnviro.cLair.cMap).startPos, cEnviro.cLair.maps.get(cEnviro.cLair.cMap).tileWidth );
    }
    void displayActivateMarkers(PVector startPos, float tileWidth){
        /*
        Displays proposed locations to be activated
        actMarkers stores coordinate position of tile it acts on NOT pixel pos
        */
        for(int i=0; i<actMarkers.size(); i++){
            displayMarker(new PVector( startPos.x +tileWidth*actMarkers.get(i).x, startPos.y +tileWidth*actMarkers.get(i).y ), tileWidth);
        }
    }
    void displayMarker(PVector pos, float tileWidth){
        /*
        Displays marker at given screen pos
        */
        pushStyle();
        rectMode(CENTER);
        fill(66, 38, 145);
        noStroke();
        rect(pos.x, pos.y, 0.4*tileWidth, 0.4*tileWidth);
        popStyle();
    }


    void resetStation(){
        cBlueprint = new blueprint();
        coinFloat = 0;
    }


    item giveItem(int sChoice, int cChoice){
        item newItem = new item();
        if(sChoice == 0){
            if(cChoice == 0){
                newItem = new itemWall();}
            if(cChoice == 1){
                newItem = new itemBarricade();}
        }
        if(sChoice == 1){
            if(cChoice == 0){
                newItem = new itemSpikeTrap();}
            if(cChoice == 1){
                newItem = new itemArrowTrap();}
            if(cChoice == 2){
                newItem = new itemFireTrap();}
        }
        if(sChoice == 2){
            if(cChoice == 0){
                newItem = new itemLever();}
            if(cChoice == 1){
                newItem = new itemSensor();}
        }
        if(sChoice == 3){
            if(cChoice == 0){
                newItem = new itemWire();}
            if(cChoice == 1){
                newItem = new itemPipe();}
        }
        return newItem;
    }


    blueprint generateBuildBlueprint(ArrayList<map> maps){
        /*
        Returns current blueprint and then resets it
        Also marks the room for cleaning if required
        */
        cBlueprint.isBigProject = checkForBigProject();
        maps.get( int(cBlueprint.posSet.get(0).z) ).cleaning = cBlueprint.isBigProject;
        blueprint newBlueprint = cBlueprint;
        cBlueprint = new blueprint();
        return newBlueprint;
    }
    void generateActivationJobs(){
        /*
        Creates a set of jobs to activate tiles from the actMarkers list, then resets list
        */
        for(int i=0; i<actMarkers.size(); i++){
            cEnviro.cLair.cmdStation.createActivateJob( new PVector(actMarkers.get(i).x, actMarkers.get(i).y, actMarkers.get(i).z) );   //### Done to try avoid referencing errors -> THO likely not needed here ###
        }
        actMarkers.clear();
    }
    void addBlueprintToJobs(){
        /*
        Gives the current blueprint to the commandStation in order to create an approporiate build job
        */
        boolean nonEmpty  = cBlueprint.posSet.size() > 0;
        boolean canAfford = cEnviro.cLair.coins >= coinFloat;
        if(nonEmpty && canAfford){   //If blueprint has anything...
            //Allow blueprint to be made into a job
            cEnviro.cLair.coins -= coinFloat;
            coinFloat = 0;
            PVector bDeskPos = findBuildDeskPos(cEnviro.cLair.maps, int(cBlueprint.posSet.get(0).z));
            cEnviro.cLair.cmdStation.createBuildJob(generateBuildBlueprint(cEnviro.cLair.maps));
        }
    }
    PVector findBuildDeskPos(ArrayList<map> maps, int nMap){
        /*
        Searches the map for its build desk
        */
        PVector cPos = new PVector(-1,-1);
        for(int j=0; j<maps.get(nMap).tiles.size(); j++){
            for(int i=0; i<maps.get(nMap).tiles.get(j).size(); i++){
                //Go through all tiles
                if(maps.get(nMap).tiles.get(j).get(i).cVolume.type == "buildDesk"){
                    //If is build desk, return its pos
                    cPos = new PVector(i,j);
                    break;
                }
            }
        }
        return cPos;
    }
    boolean checkForBigProject(){
        /*
        Checks through the items in the blueprint and makes the blueprint for 
        big projects if any of the requirements met
        */
        boolean isBigProject = false;
        for(int i=0; i<cBlueprint.itemSet.size(); i++){
            if(cBlueprint.itemSet.get(i).sType == 0){   //Blockers
                isBigProject = true;
                break;
            }
            //...
            //## MAY NEED MANY MORE ##
        }
        return isBigProject;
    }


    void determineClickAction(){
        /*
        Determines what to do when clicking in the construct menu
        */
        //println("Clicking...");
        chosenChoice = checkChoiceSelection();
        PVector hoveredTile = findHoveredTile(cEnviro.cLair.maps, cEnviro.cLair.cMap);
        if( int(hoveredTile.x) != -1){
            if(nMode == 0){                                         //(0) If PLACING item
                if(mouseButton == LEFT){
                    if( (setChoice!=-1) && (chosenChoice!=-1) ){
                        addItemToBlueprint(giveItem(setChoice, chosenChoice), hoveredTile);
                    }
                }
                if(mouseButton == RIGHT){
                    removeItemFromBlueprint(hoveredTile);
                }
            }
            if(nMode == 1){                                         //(1) If ACTIVATING tile
                calcForHoveredToMarkers(hoveredTile);
            }
        }
    }
    void calcForHoveredToMarkers(PVector hoveredTile){
        /*
        Calculates whether to remove a marker at given point (if is FULL)
        OR add a marker to the given point (if is EMPTY)
        */
        boolean alreadyInMarkers = false;
        for(int i=actMarkers.size()-1; i>=0; i--){
            boolean xMatch = (hoveredTile.x == actMarkers.get(i).x);
            boolean yMatch = (hoveredTile.y == actMarkers.get(i).y);
            if(xMatch && yMatch){
                alreadyInMarkers = true;
                println("--Removed from Markers--");
                actMarkers.remove(i);
                break;
            }
        }
        if(!alreadyInMarkers){
            println("--Added to Markers--");
            actMarkers.add( new PVector(hoveredTile.x, hoveredTile.y, cEnviro.cLair.cMap) );
        }
    }
    //## COULD MOVE INTO BLUEPRINT CLASS ##
    void addItemToBlueprint(item cItem, PVector cPos){
        /*
        Places given item into blueprint, with given location
        Checks if something already there, if so -> overwrite it
        */
        //println("Adding to blueprint...");
        removeItemFromBlueprint(cPos);
        coinFloat += cItem.price;
        cBlueprint.posSet.add( new PVector(cPos.x, cPos.y) );
        cBlueprint.itemSet.add(cItem);
    }
    //## COULD MOVE INTO BLUEPRINT CLASS ##
    void removeItemFromBlueprint(PVector cPos){
        /*
        Removes any items in blueprint at given position
        */
        //println("Removing from blueprint...");
        for(int i=0; i<cBlueprint.posSet.size(); i++){
            boolean xMatch = cPos.x == cBlueprint.posSet.get(i).x;
            boolean yMatch = cPos.y == cBlueprint.posSet.get(i).y;
            if(xMatch && yMatch){
                //Something here, so must remove it and place this in the list
                coinFloat -= cBlueprint.itemSet.get(i).price;
                cBlueprint.posSet.remove(i);
                cBlueprint.itemSet.remove(i);
                break;
            }
        }
    }
    PVector findHoveredTile(ArrayList<map> maps, int nMap){
        /*
        Returns the coords of the tile being hovered
        relativePos |
        currentPos  |
        finalPos    |
        */
        PVector rPos = new PVector(mouseX -maps.get(nMap).startPos.x +maps.get(nMap).tileWidth/2.0, mouseY -maps.get(nMap).startPos.y +maps.get(nMap).tileWidth/2.0);   //Relative pos of mouse to start of map
        PVector cPos = new PVector( floor(rPos.x/maps.get(nMap).tileWidth), floor(rPos.y/maps.get(nMap).tileWidth) );
        PVector fPos = new PVector(-1, -1);             //If not on map, give (-1,-1) coords symbollically
        boolean withinX = ( 0 <= int(cPos.x) ) && ( int(cPos.x) < maps.get(nMap).tiles.get(0).size() );  //If is on the map
        boolean withinY = ( 0 <= int(cPos.y) ) && ( int(cPos.y) < maps.get(nMap).tiles.size() );         //
        if(withinX && withinY){
            fPos = new PVector(cPos.x, cPos.y);}        //Make coords on map if is on map
        return fPos;
    }
    int checkChoiceSelection(){
        /*
        When called (when mouse clicked), return index of item chosen from set (being hovered)
        If none chosen, return -1
        */
        int chosenInd = -1;
        if(setChoice != -1){
            for(int i=0; i<setChoiceMax; i++){
                boolean withinX = (iRow.x +bMultiSpacing*i*boxSize -boxSize/2.0 < mouseX) && (mouseX < iRow.x +bMultiSpacing*i*boxSize +boxSize/2.0);
                boolean withinY = (iRow.y -boxSize/2.0                          < mouseY) && (mouseY < iRow.y +boxSize/2.0);
                if(withinX && withinY){
                    chosenInd = i;
                    break;
                }
            }
        }
        if(chosenInd == -1){            //If nothing new selected, keep the same
            chosenInd = chosenChoice;
        }
        return chosenInd;
    }
    void switchToOptions(int type){
        /*
        Switches to the type'th type of construction type
        This will result in the display showing this set of items to be chosen from
        */
        setChoice = type;
    }
    void incrementBuildMode(){
        /*
        Changes build mode -> happens when a button is pressed
        */
        nMode++;
        if(nMode >= nModeMax){
            nMode = 0;
        }
    }
}