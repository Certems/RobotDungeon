class entity{
    int ID = floor(random(1000000, 9999999));

    PVector iPos;   //Index position for this entity    #### SHOULD PROBABLY JUST ROLL THESE 2 INTO A 3D VECTOR LIKE EVERYTHING ELSE NOW ####
    int mPos;       //Index of map for this entity      #####################################################################################

    ArrayList<job> jobs = new ArrayList<job>();

    ArrayList<PVector> path = new ArrayList<PVector>(); //Path they take for routing (x,y) = pos in map, (z) = map they are in

    int health;
    int motionSpd;  //Number of generations before a movement occurs 
    int motionVal=0;//Frame of progress currently
    //##MAYBE ADD SOME RANDOMNESS TO IT## -> DEPENDENT ON PANIC

    entity(PVector position, int mapPosition){
        iPos = position;
        mPos = mapPosition;
    }

    void display(PVector pos, float dim){
        //pass
    }
    void displayPath(){
        //pass
    }


    void calcAction(){
        /*
        Determines whether the entity can act yet, or if it needs to wait for some associated cooldown
        May want to split into separate timers
        e.g motionTimer, AttackTimer, specialAbilityTimer, etc
            -> Then have "doActionMove", "doActionAttack", "doActionSpecial", etc
        */
        //Progress action timer
        motionVal++;
        if(motionVal > motionSpd){
            //Reset timer
            motionVal = 0;
            doAction();
        }
    }
    void doAction(){
        /*
        Determines actual action to be performed
        This will usually be a job, but if it has no job it will do some idle action
        */
        //Do action once timer finished
        if(jobs.size() > 0){
            //If has a job it can do, do next job
            jobs.get(0).doJob();
        }
        else{
            //If no job, do an idle action
            doIdleAction();
        }
    }
    void doIdleAction(){
        /*
        Action performed by entity while it has no job
        Specific to enemies and allies
        */
    }


    void travelHyperPath(ArrayList<map> maps){
        /*
        Moves the entity through its hyper path
        Specified inside the ally / enemy
        */
        //Do like lair pathing but with this larger table + some differences
    }
    void wanderCurrentMap(ArrayList<map> maps){
        /*
        Walks a step (or no steps) within the current map to a valid space
        Usual for idle behaviour

        choice;
        -1 = stay still
        n  = move to nth option

        1. List valid options to travel to
        2. Roll dice, pick an option
        3. Move to that choice
        */
        //1
        ArrayList<PVector> possiblePoints = new ArrayList<PVector>();
        for(int i=-1; i<2; i+=2){
            //**Note; Y will always be valid here as y already was valid and only X changes + rectangular maps
            boolean validX   = (0 <= int(iPos.x)+i) && (int(iPos.x)+i < maps.get(mPos).tiles.get(0).size());    //Not outside map bounds
            if(validX){
                boolean validCol = !maps.get(mPos).tiles.get(int(iPos.y)).get(int(iPos.x) +i).cVolume.isCollideable;   //Is not collideable
                if(validX && validCol){
                    possiblePoints.add( new PVector(iPos.x+i, iPos.y, mPos) );
                }
            }
        }
        for(int j=-1; j<2; j+=2){
            //**Note; X will always be valid here as x already was valid and only Y changes + rectangular maps
            boolean validY   = (0 <= int(iPos.y)+j) && (int(iPos.y)+j < maps.get(mPos).tiles.size());    //Not outside map bounds
            if(validY){
                boolean validCol = !maps.get(mPos).tiles.get(int(iPos.y) +j).get(int(iPos.x)).cVolume.isCollideable;   //Is not collideable
                if(validCol){
                    possiblePoints.add( new PVector(iPos.x, iPos.y +j, mPos) );
                }
            }
        }
        //2
        float rVal = random(0.0, 1.0);
        float stayProb = 1.0;
        float moveProb = 0.0;
        if(possiblePoints.size() > 0){
            stayProb = 0.3;   //30% chance to stay always
            moveProb = (1.0-stayProb)/possiblePoints.size();
        }
        int choice = -1;
        if(rVal >= stayProb){
            choice = floor((rVal-stayProb)/ moveProb);}
        //3
        if(choice != -1){
            path.add(0, possiblePoints.get(choice));
            travelHyperPath(maps);
        }
    }


    ArrayList<PVector> calcHyperPathing(ArrayList<map> maps, PVector sPoint, PVector ePoint, int range){
        /*
        Uses the doorPath to find the full individual tile pathing

        startPoint = sPoint = (tileX, tileY, map#)
        endPoint   = ePoint = (tileX, tileY, map#)
        range      = Tolerance on how close to endPoint you have to be

        1. Find door pathing
        2. Use door pathing to find individual map paths
        2.1 -> Add starting path from sPoint to 0th door
        2.2 -> Add all paths between doors
        2.3 -> Add final path from last door to ePoint
        3. Stitch map paths together
        */
        ArrayList<PVector> finalPath = new ArrayList<PVector>();
        //1
        ArrayList<PVector> doorPath = calcDoorPathing(sPoint, ePoint);  //Door map positions (x,y,map#)
        //println("doorPath -> ",doorPath);

        //2
        //2.1
        ArrayList<PVector> beginningPath = calcMapPathing(maps.get(int(sPoint.z)), sPoint, doorPath.get(0), range); //Careful with range ## WILL CAUSE WEIRD PROBLEMS WHEN PATHING WITH RANGE ##
        for(int j=0; j<beginningPath.size(); j++){
            finalPath.add(beginningPath.get(j));}
        //2.2
        for(int i=1; i<doorPath.size()-1; i+=2){
            //**Note; Does += 2 so it calculates pathing between doors in a given map and NOT for doors where you teleport instantly (wouldnt make sense here, so skipped)
            //**    [i=1 jumps initial SINGLE], [size()-1 jumps final SINGLE]
            ArrayList<PVector> middlePath = calcMapPathing(maps.get(int(doorPath.get(i).z)), doorPath.get(i), doorPath.get(i+1), range);
            for(int j=0; j<middlePath.size(); j++){
                finalPath.add(middlePath.get(j));}
        }
        //2.3
        ArrayList<PVector> endingPath = calcMapPathing(maps.get(int(ePoint.z)), doorPath.get( doorPath.size()-1 ), ePoint, range);
        for(int j=0; j<endingPath.size(); j++){
            finalPath.add(endingPath.get(j));}

        //3
        return finalPath;
    }
    ArrayList<PVector> calcDoorPathing(PVector sPoint, PVector ePoint){
        /*
        Calculates a path through doors, through the lair, from the startPoint to the endPoint

        startPoint = sPoint = (tileX, tileY, map#)
        endPoint   = ePoint = (tileX, tileY, map#)

        openPoints  = nodes that can be travelled to as [INDEX_X, INDEX_Y]
        marked      = nodes that have been travelled to (if reached that is the fastest path to it)
        revDir      = points to index of door ENTERED FROM
        travelWeight= total weight to given door so far
        viableEDoors= indices of doors that be ended on and result in a complete path (can reach ePoint)

        ...
        */
        monitorStation mStat = cEnviro.cLair.mStation;  //Links to connection table and table commands
        ArrayList<PVector> doorPath  = new ArrayList<PVector>();
        ArrayList<PVector> openPoints = new ArrayList<PVector>();
        ArrayList<Boolean> marked     = new ArrayList<Boolean>();
        ArrayList<Integer> revDir     = new ArrayList<Integer>();
        ArrayList<Float> travelWeight = new ArrayList<Float>();
        ArrayList<Integer> viableEDoors = new ArrayList<Integer>();

        //--Initial
        //-Initialise
        for(int i=0; i<mStat.dConTable.size(); i++){
            //Marked init
            marked.add(false);
            //RevDir init
            revDir.add(-1);
            //TravelWeight init
            travelWeight.add(0.0);
        }
        //println("dConTable size -> ",mStat.dConTable.size());
        //printTable(mStat.dConTable, "dCon");
        //-Add openPoints
        //    1. Add to openPoints ALL doors starting in sPoint map, and ending at their linked location
        //    2. Then try path to each door FROM sPoint TO the starting location
        //    3. Remove unreachable paths
        //1
        for(int i=0; i<mStat.mapSets.get( int(sPoint.z) ).doors.size(); i++){
            PVector dStartVec = new PVector(int(sPoint.z), i);                          //## SWAPPED, MAKE SURE IS RIGHT ##
            int dStartInd = mStat.findDoorIndexFromVec(dStartVec);
            int dLinkInd  = mStat.findDoorIndexFromVec( mStat.findLinkedDoorVec(dStartVec) );
            openPoints.add( new PVector(dStartInd, dLinkInd) );
        }
        //2
        for(int i=openPoints.size()-1; i>=0; i--){
            PVector dStartPos = mStat.findDoorPosFromIndex( int(openPoints.get(i).x) );
            ArrayList<PVector> testPathing = calcMapPathing(cEnviro.cLair.maps.get( int(sPoint.z) ), sPoint, dStartPos, 0);
            //3
            if(testPathing.size() == 0){
                openPoints.remove(i);
            }
        }
        //-Add viableEDoors
        //    1. Add to viableEDoors ALL doors in ePoint map (index of doors)
        //    2. Then try path to each door FROM viableEDoors at ind TO ePoint
        //    3. Remove unreachable paths
        //1
        for(int i=0; i<mStat.mapSets.get( int(ePoint.z) ).doors.size(); i++){
            PVector dVec = new PVector(int(ePoint.z), i);                               //## SWAPPED, MAKE SURE IS RIGHT ##
            int dInd     = mStat.findDoorIndexFromVec(dVec);
            viableEDoors.add(dInd);
        }
        //2
        for(int i=viableEDoors.size()-1; i>=0; i--){
            PVector dPos = mStat.findDoorPosFromIndex( viableEDoors.get(i) );
            ArrayList<PVector> testPathing = calcMapPathing(cEnviro.cLair.maps.get( int(ePoint.z) ), dPos, ePoint, 1);  //## had trouble with pathing to 0 or 1 for this -> 1 GOOD FOR SOME CASES (DESK), 0 FOR OTHERS (DOOR)
            //3
            if(testPathing.size() == 0){
                viableEDoors.remove(i);
            }
        }
        //-Sort openPoints
        //## SHOULD CHANGE TO BINARY SORT POSSIBLY, ALTHOUGH NOT 100% NEEDED FOR THESE SMALL SCALES ##
        for(int j=0; j<openPoints.size(); j++){
            boolean hasSwitched = false;
            for(int i=0; i<openPoints.size()-1; i++){
                float weight1 = travelWeight.get( int(openPoints.get(i  ).x) ) +mStat.dConTable.get( int(openPoints.get(i  ).x) ).get( int(openPoints.get(i  ).y) );
                float weight2 = travelWeight.get( int(openPoints.get(i+1).x) ) +mStat.dConTable.get( int(openPoints.get(i+1).x) ).get( int(openPoints.get(i+1).y) );
                if(weight1 > weight2){
                    hasSwitched = true;
                    PVector oPoint = openPoints.get(i+1);
                    openPoints.remove(i+1);
                    openPoints.add(i, new PVector(oPoint.x, oPoint.y));  //## MAY NOT BE NEEDED, JUST CAREFUL FOR REFERENCING ##
                }
            }
            if(!hasSwitched){
                break;
            }
        }
        boolean pathFound = false;
        boolean noStartPoints = openPoints.size()   == 0;
        boolean noEndPoints   = viableEDoors.size() == 0;
        //**Edge cases
        if(noStartPoints || noEndPoints){   //If cannot path
            pathFound = true;
        }
        //boolean zMatch = sPoint.z == ePoint.z;                                    ### LIKELY NOT NEEDED -> WAS USED TO FIX PATHING WITHIN SAME MAP ###
        //if(zMatch){                         //If start and end in same map        ###
        //    pathFound = true;                                                     ###
        //    doorPath.add( new PVector(sPoint.x, sPoint.y, sPoint.z) );            ###
        //}                                                                         ### LIKELY NOT NEEDED -> WAS USED TO FIX PATHING WITHIN SAME MAP ###
        //**Edge cases
        while(!pathFound){                  //**Main case
            //println("openPoints-> ",openPoints);
            //1
            PVector cPoint = openPoints.get(0);     //Pick point
            openPoints.remove(0);
            //2
            if(!marked.get( int(cPoint.y) )){  //If can go to leading point
                //3
                marked.remove( int(cPoint.y) );
                marked.add(int(cPoint.y), true);

                revDir.remove( int(cPoint.y) );
                revDir.add(int(cPoint.y), int(cPoint.x));

                float newWeight = travelWeight.get( int(cPoint.x) ) +mStat.dConTable.get( int(cPoint.x) ).get( int(cPoint.y) );
                travelWeight.remove( int(cPoint.y) );
                travelWeight.add(int(cPoint.y), newWeight);
                //4
                //-Add openPoints
                for(int i=0; i<mStat.dConTable.get( int(cPoint.y) ).size(); i++){
                    if(mStat.dConTable.get( int(cPoint.y) ).get(i) >= 0){
                        if( !marked.get(i) ){
                            openPoints.add(new PVector(cPoint.y, i));
                        }
                    }
                }
                //-Sort openPoints
                //## SHOULD CHANGE TO BINARY SORT POSSIBLY, ALTHOUGH NOT 100% NEEDED FOR THESE SMALL SCALES ##
                for(int j=0; j<openPoints.size(); j++){
                    boolean hasSwitched = false;
                    for(int i=0; i<openPoints.size()-1; i++){
                        float weight1 = travelWeight.get( int(openPoints.get(i  ).x) ) +mStat.dConTable.get( int(openPoints.get(i  ).x) ).get( int(openPoints.get(i  ).y) );
                        float weight2 = travelWeight.get( int(openPoints.get(i+1).x) ) +mStat.dConTable.get( int(openPoints.get(i+1).x) ).get( int(openPoints.get(i+1).y) );
                        if(weight1 > weight2){
                            hasSwitched = true;
                            PVector oPoint = openPoints.get(i+1);
                            openPoints.remove(i+1);
                            openPoints.add(i, new PVector(oPoint.x, oPoint.y));  //## MAY NOT BE NEEDED, JUST CAREFUL FOR REFERENCING ##
                        }
                    }
                    if(!hasSwitched){
                        break;
                    }
                }
            }
            if(openPoints.size() == 0){ //if no points left, return empty
                //**Note; this empty can be overwritten by a real path IF this point is the very last checked and the last needed to reach the end
                pathFound = true;
            }
            for(int i=0; i<viableEDoors.size(); i++){           //Check all viable ends...
                if( int(cPoint.y) == viableEDoors.get(i) ){     //If found end, then create path ( by backwards)
                    int breaker = 0;
                    int revMap = int(cPoint.y); //Seed first point
                    while(breaker < 100){
                        //**Will terminate by a break naturally, breaker is a backup
                        if(revMap > -1){                            //If a valid map, add to path
                            PVector dPos = mStat.findDoorPosFromIndex(revMap);  //Adds the positions of the doors with (tileX, tileY, map#)
                            doorPath.add(0, dPos);}  //
                        else{                                   //If NOT valid, path has been found (got back to start with -1)
                            break;}                             //
                        revMap = revDir.get(revMap);
                        breaker++;
                    }
                    pathFound = true;
                }
            }
        }
        return doorPath;
    }
    Integer findEntityInd(ArrayList<map> maps){
        /*
        Finds what number this entity is in the list on entities on its tile
        **Function is specified inside class for exact entity type
        */
        return -1;
    }
    float findWeightedVal(ArrayList<map> maps, int n1, int n2){
        /*
        Finds a value for the 'distance' needed to travel through one map TO another
        n1 = index # of map 1
        n2 = index # of map 2
        Value is negative, hence faster routes are MORE negative
        Used in hyper pathfinding
        */
        map m1 = maps.get(n1);
        map m2 = maps.get(n2);
        boolean mapsAreLinked = false;
        for(int j=0; j<m1.tiles.size(); j++){                                                                   //Search given map
            for(int i=0; i<m1.tiles.get(j).size(); i++){
                if(m1.tiles.get(j).get(i).cVolume.type == "door"){                                              //If a door is found
                    PVector lDoorVec = cEnviro.cLair.mStation.findLinkedDoorVecFromPos(new PVector(i,j), n1);   //Find its linked door
                    if(int(lDoorVec.x) == n2){                                                                  //If the door leads to map n2, then the maps are connected so can have a non-0 weighting
                        mapsAreLinked = true;
                        break;
                    }
                }
            }
        }
        float fVal = 0.0;
        if(mapsAreLinked){
            float val1 = -100.0/ ( m1.tiles.size()*m1.tiles.get(0).size() );
            float val2 = -100.0/ ( m2.tiles.size()*m2.tiles.get(0).size() );
            fVal = (val1 + val2) / 2.0;
        }        
        return fVal;
    }
    ArrayList<PVector> findMapFinalPoints(ArrayList<map> maps, int mGiven, int mRequired, PVector targetPoint){
        /*
        Finds possible end points
        If a map is given, it will find all doors in THAT map that LEAD to the given map
        Returns the map vectors of those doors the fit the requirement
        mGiven    = map being looked at
        mRequired = destination wanted

        **Note; If mRequired is -1, indicates to go to EXIT IN MGIVEN
        */
        ArrayList<PVector> endPoints = new ArrayList<PVector>();
        for(int j=0; j<maps.get(mGiven).tiles.size(); j++){
            for(int i=0; i<maps.get(mGiven).tiles.get(j).size(); i++){
                if(mRequired != -1){                                                                        //IF FINDING DOOR
                    if(maps.get(mGiven).tiles.get(j).get(i).cVolume.type == "door"){                            //If is a door...
                        PVector lDoorVec = cEnviro.cLair.mStation.findLinkedDoorVecFromPos(new PVector(i,j), mGiven);
                        boolean linksToRequired = (int(lDoorVec.x) == mRequired);
                        if(linksToRequired){                                                                    //And door leads to correct place...
                            endPoints.add(new PVector(i,j));                                                    //Mark it as an end point
                        }
                    }
                }
                else{                                                                                       //Find target destination (e.g the exit or specified point)
                    if( (int(targetPoint.x) == i) && (int(targetPoint.y) == j) ){
                        endPoints.add(new PVector(i,j));
                    }
                }
            }
        }
        return endPoints;
    }
    ArrayList<PVector> calcMapPathing(map cMap, PVector sPoint, PVector fPoint, int range){
        /*
        Calculates the pathing through its current map
        Will sometimes make random moves too ## -> NOT ADDED YET

        cMap    = map to calc pathing through
        sPoint  = start location of this entity
        fPoint  = location for this entity to end at
        range   = How many tiles off you can be from target and still end pathing -> lazy pathing

        Uses A* +RandomMovement
        Loops;
        1. Choose smallest end point from 'ePoints'
        2. Look for possible places to go
        2.1.    If none, remove end point from list and RESTART
        3. Find 'tWeight' of all options and select the smallest (and mark as used)
        4. Create a new end point =to this+newTile that has been moved to +Mark dir backwards +Add weight
        5. If this newTile is an exit tile, then process finished
        5.1.    If not, RESTART
        6 Once finished, work backwards through from the end to construct the path
        */
        ArrayList<PVector> mPath = new ArrayList<PVector>();
        
        ArrayList<ArrayList<Boolean>> mMarked = new ArrayList<ArrayList<Boolean>>();
        ArrayList<ArrayList<String>> mRevDir  = new ArrayList<ArrayList<String>>();
        ArrayList<ArrayList<Integer>> mWeight = new ArrayList<ArrayList<Integer>>();
        ArrayList<PVector> ePoints = new ArrayList<PVector>();
        //Initialise
        for(int j=0; j<cMap.tiles.size(); j++){
            mMarked.add( new ArrayList<Boolean>() );
            mRevDir.add( new ArrayList<String>() );
            mWeight.add( new ArrayList<Integer>() );
            for(int i=0; i<cMap.tiles.get(j).size(); i++){
                mMarked.get(j).add(false);
                mRevDir.get(j).add("null");
                mWeight.get(j).add(0);
            }
        }
        ePoints.add(new PVector(sPoint.x, sPoint.y));           //
        mMarked.get(int(sPoint.y)).remove(int(sPoint.x));       //
        mMarked.get(int(sPoint.y)).add(int(sPoint.x), true);    //

        //Main loop
        boolean endFound = false;
        while(!endFound){
            //1
            //println("ePoints -> ", ePoints);
            if(ePoints.size() <= 0){  //If route CANNOT be found
                endFound = true;
            }
            else{   //If routing is STILL POSSIBLE
                PVector cPoint = new PVector(ePoints.get(0).x, ePoints.get(0).y);
                //2
                ArrayList<PVector> possiblePoints = new ArrayList<PVector>();
                for(int i=-1; i<2; i+=2){
                    boolean possibleSpace = (0 <= cPoint.x +i) && (cPoint.x +i < cMap.tiles.get(int(cPoint.y)).size());
                    if(possibleSpace){
                        boolean validSpace = (!cMap.tiles.get(int(cPoint.y)).get(int(cPoint.x +i)).cVolume.isCollideable) && (!mMarked.get(int(cPoint.y)).get(int(cPoint.x +i)));
                        if(validSpace){
                            possiblePoints.add(new PVector(cPoint.x +i, cPoint.y));
                        }
                    }
                }
                for(int j=-1; j<2; j+=2){
                    boolean possibleSpace = (0 <= cPoint.y +j) && (cPoint.y +j < cMap.tiles.size());
                    if(possibleSpace){
                        boolean validSpace = (!cMap.tiles.get(int(cPoint.y +j)).get(int(cPoint.x)).cVolume.isCollideable) && (!mMarked.get(int(cPoint.y +j)).get(int(cPoint.x)));
                        if(validSpace){
                            possiblePoints.add(new PVector(cPoint.x, cPoint.y +j));
                        }
                    }
                }
                //2.1
                if(possiblePoints.size() > 0){  //If valid option
                    //3
                    int sInd = 0;   //Index of smallest weight (assumed 0th at start)
                    float sWeight = findTotalWeight(possiblePoints.get(0), mWeight, fPoint);
                    for(int i=0; i<possiblePoints.size(); i++){
                        float tWeight = findTotalWeight(possiblePoints.get(i), mWeight, fPoint);
                        if(tWeight < sWeight){
                            sInd    = i;
                            sWeight = tWeight;
                        }
                    }
                    PVector chosenPoint = new PVector(possiblePoints.get(sInd).x, possiblePoints.get(sInd).y);
                    int newWeight = int(mWeight.get(int(cPoint.y)).get(int(cPoint.x)) +1);
                    mMarked.get(int(chosenPoint.y)).remove(int(chosenPoint.x));
                    mMarked.get(int(chosenPoint.y)).add(int(chosenPoint.x), true);
                    mWeight.get(int(chosenPoint.y)).remove(int(chosenPoint.x));
                    mWeight.get(int(chosenPoint.y)).add(int(chosenPoint.x), newWeight);
                    //4
                    ePoints.add( new PVector(int(chosenPoint.x), int(chosenPoint.y)) );
                    String dir = "";
                    if(chosenPoint.y -cPoint.y ==  1){//Gone Up => mark to go down
                        dir = "North";}
                    if(chosenPoint.y -cPoint.y == -1){//Gone Down => mark to go up
                        dir = "South";}
                    if(chosenPoint.x -cPoint.x == -1){//Gone left => mark to go right
                        dir = "East";}
                    if(chosenPoint.x -cPoint.x ==  1){//Gone right => mark to go left
                        dir = "West";}
                    mRevDir.get(int(chosenPoint.y)).remove(int(chosenPoint.x));
                    mRevDir.get(int(chosenPoint.y)).add(int(chosenPoint.x), dir);
                    //5
                    //For all end points...
                    boolean inRangeR = (sqrt( pow(fPoint.x -chosenPoint.x,2) + pow(fPoint.y -chosenPoint.y,2) )) <= range;    //Radial range not xy based (cirle not square)
                    if(inRangeR){   //If within range of given end point, finish pathing
                        //println("--IN RANGE--");
                        endFound = true;
                    }
                    if(endFound){
                        //6
                        boolean mPathConstructed = false;
                        PVector iPoint = chosenPoint;  //Interest point
                        while(!mPathConstructed){
                            //println("mPath -> ",mPath);
                            boolean dirChosen = false;
                            mPath.add(0, new PVector(iPoint.x, iPoint.y, int(sPoint.z)));
                            if(mRevDir.get(int(iPoint.y)).get(int(iPoint.x)) == "North" && !dirChosen){
                                iPoint = new PVector(iPoint.x, iPoint.y -1);
                                dirChosen = true;}
                            if(mRevDir.get(int(iPoint.y)).get(int(iPoint.x)) == "South" && !dirChosen){
                                iPoint = new PVector(iPoint.x, iPoint.y +1);
                                dirChosen = true;}
                            if(mRevDir.get(int(iPoint.y)).get(int(iPoint.x)) == "East" && !dirChosen){
                                iPoint = new PVector(iPoint.x +1, iPoint.y);
                                dirChosen = true;}
                            if(mRevDir.get(int(iPoint.y)).get(int(iPoint.x)) == "West" && !dirChosen){
                                iPoint = new PVector(iPoint.x -1, iPoint.y);
                                dirChosen = true;}
                            if(mRevDir.get(int(iPoint.y)).get(int(iPoint.x)) == "null"){    //Back at start tile (entity already on it => dont add [would waste one movement step])
                                mPathConstructed = true;}
                        }
                        //## DRAWING ##
                        //printDirectedMap(mRevDir);
                        //## DRAWING ##
                    }
                }
                else{   //If no valid options
                    ePoints.remove(0);
                    //Then start again
                }
                //Sort ePoints for lowest weight again
                for(int i=0; i<ePoints.size(); i++){
                    boolean swapped = false;
                    for(int j=0; j<ePoints.size()-1; j++){
                        int cWeight = mWeight.get(int(ePoints.get(j  ).y)).get(int(ePoints.get(j  ).x)); //Current weight
                        int nWeight = mWeight.get(int(ePoints.get(j+1).y)).get(int(ePoints.get(j+1).x)); //Next weight (+1th index)
                        if(nWeight < cWeight){
                            //Swap
                            ePoints.add(j, ePoints.get(j+1));
                            ePoints.remove(j+2);
                            swapped = true;
                        }
                    }
                    if(!swapped){   //!swapped => ordered already
                        break;}
                }
            }
        }
        return mPath;
    }
    float findTotalWeight(PVector mPoint, ArrayList<ArrayList<Integer>> mWeight, PVector fPoint){
        float cWeight  = mWeight.get(int(mPoint.y)).get(int(mPoint.x)) +1;   //Current path weight
        //Considers all running weights and selects the smallest (e.g considers closest final point)
        float drWeight = vecDist(mPoint, fPoint);                            //Running weight
        float tWeight  = cWeight +drWeight;
        return tWeight;
    }
    void printTable(ArrayList<ArrayList<Integer>> table, String tableName){
        println(tableName +" Table");
        println("-----------------");
        for(int j=0; j<table.size(); j++){
            for(int i=0; i<table.get(j).size(); i++){
                print( floor(10.0*table.get(j).get(i))/10.0 +", " );
            }
            println(" ");
        }
    }
    void printDirectedMap(ArrayList<ArrayList<String>> mRevDir){
        println("--");
        println("pathSize -> ",path.size());
        for(int j=0; j<mRevDir.size(); j++){
            println("");
            for(int i=0; i<mRevDir.get(j).size(); i++){
                if(mRevDir.get(j).get(i) == "North"){
                    print("N");}
                if(mRevDir.get(j).get(i) == "South"){
                    print("S");}
                if(mRevDir.get(j).get(i) == "East"){
                    print("E");}
                if(mRevDir.get(j).get(i) == "West"){
                    print("W");}
                if(mRevDir.get(j).get(i) == "null"){
                    print(".");}
            }
        }
    }
}