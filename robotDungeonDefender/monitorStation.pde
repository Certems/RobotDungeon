class monitorStation{
    /*
    The monitor station acts as the camera screen.
    It gathers all the rooms of the lair together and connects them.
    Rooms can be moved around here and fit back together
    It also lets the player change their currently viewed room by selecting it here

    DoorTable notation;
    doorIndex    = index in full table
    doorMapIndex = index in given map's door list
    doorVec      = vector specifying door in full table (e.g [mapInd, doorMapInd])
    doorPos      = vector stating coords of door on the physical map
    */
    ArrayList<mapForm> mapSets = new ArrayList<mapForm>();
    ArrayList<ArrayList<Boolean>> doorTable = new ArrayList<ArrayList<Boolean>>();    //'Truth Table' style grid for which doors link to which
    ArrayList<ArrayList<Integer>> dConTable = new ArrayList<ArrayList<Integer>>();    //Similar to above, but shows distance to directly connected doors from other doors

    PVector startPos = new PVector(0,0);    //Top left corner of the whole screen

    float tRatio = 5.0;

    boolean linking = false;
    PVector linkObj = new PVector(0,0);

    int movingMap = -1;
    boolean movingOccurring = false;
    PVector clickPos   = new PVector(0,0);
    PVector objOrigPos = new PVector(0,0);

    monitorStation(){
        //pass
    }

    void display(){
        displayMaps();
        displayLinks();
    }
    void displayMaps(){
        for(int i=0; i<mapSets.size(); i++){
            mapSets.get(i).display(startPos, tRatio);
        }
    }
    void displayLinks(){
        pushStyle();  

        //Goes through whole of upper trianglular -> i & j are door inds
        for(int j=0; j<doorTable.size(); j++){
            PVector iVec1 = findDoorVecFromInd(j);            //Ind vector -> x=Map#, y=door#
            for(int i=0; i<doorTable.get(j).size(); i++){
                PVector iVec2 = findDoorVecFromInd(i);        //Ind vector -> x=Map#, y=door#
                if(doorTable.get(j).get(i)){
                    //If is a connection here, Draw it
                    PVector pos1 = new PVector( startPos.x +mapSets.get(int(iVec1.x)).cPos.x +tRatio*mapSets.get(int(iVec1.x)).doors.get(int(iVec1.y)).x,
                                                startPos.y +mapSets.get(int(iVec1.x)).cPos.y +tRatio*mapSets.get(int(iVec1.x)).doors.get(int(iVec1.y)).y );
                    PVector pos2 = new PVector( startPos.x +mapSets.get(int(iVec2.x)).cPos.x +tRatio*mapSets.get(int(iVec2.x)).doors.get(int(iVec2.y)).x,
                                                startPos.y +mapSets.get(int(iVec2.x)).cPos.y +tRatio*mapSets.get(int(iVec2.x)).doors.get(int(iVec2.y)).y );
                    door currentDoor = (door)(cEnviro.cLair.maps.get( int(iVec1.x) ).tiles.get( int(mapSets.get(int(iVec1.x)).doors.get(int(iVec1.y)).y) ).get( int(mapSets.get(int(iVec1.x)).doors.get(int(iVec1.y)).x) ).cVolume);
                    boolean isDoor   = !currentDoor.isPortal;   //**Note; If one is a portal, both must be
                    if(isDoor){     //If is a door, connect with line
                        stroke(255);
                        fill(255);
                        strokeWeight(tRatio/2.0);
                        line(pos1.x, pos1.y, pos2.x, pos2.y);
                    }
                    else{           //If is a portal, connect with coloured dots
                        PVector col = portalColourMapper(iVec1, iVec2);
                        noStroke();
                        fill(col.x, col.y, col.z);
                        ellipse(pos1.x, pos1.y, 10,10);
                        ellipse(pos1.x, pos1.y, 10,10);
                    }
                }
            }
        }

        popStyle();
    }
    PVector portalColourMapper(PVector doorVec1, PVector doorVec2){
        /*
        Takes table vectors and assigns a colour to the pair
        */
        return new PVector(255.0*sin( ( (doorVec1.x +doorVec2.x)%(8.0*PI) )/4.0 ), 255.0*cos( ( (doorVec1.y +doorVec2.y)%(8.0*PI) )/4.0 ), ( pow(doorVec1.x +5,3) + pow(doorVec2.x +5,3) +pow(doorVec1.y +2,3) + pow(doorVec2.y +2,3) )%255.0);
    }


    ArrayList<PVector> findEntranceVecs(){
        /*
        Returns list of vectors specifying the map(x) and index in entrance list(y) of each entrance
        */
        ArrayList<PVector> entranceVecSet = new ArrayList<PVector>();
        for(int i=0; i<mapSets.size(); i++){
            for(int j=0; j<mapSets.get(i).entrances.size(); j++){
                entranceVecSet.add( new PVector(i,j) );
            }
        }
        return entranceVecSet;
    }


    void createDConTable(ArrayList<map> maps){
        /*
        Creates a table showing distance from any given door to any other door
        No connection      = -1 dist
        Actual connections >  0 dist

        Split into;
        Which map#? AND
        Which door index in map?
        1    2   3  4       MAP
        01 01234 0 01       DOOR INDEX
        __|_____|_|__
        -------------       Same is done for y-axis of table
        |           |
        |           |
        |           |
        |           |
        -------------

        1.Go through all doors
        2.  Go through all doors in the same map as this door
        3.  Try pathfind to it, if no path, set dist as -1, if is a path, set dist to size of path      #### LATER ON CAN ADD WEIGHT BASED ON RISKINESS####
        */
        //println("Making dConTable...");
        dConTable.clear();
        enemy testEntity = new enemy( new PVector(-1,-1), -1 ); //Introduced so pathing finding in a given map can be used
        int cInd = 0;   //Counts indices for easier calculations -> Counts for each door
        for(int j=0; j<mapSets.size(); j++){
            for(int i=0; i<mapSets.get(j).doors.size(); i++){
                //For every door
                dConTable.add( new ArrayList<Integer>() );  //Add space for door
                for(int q=0; q<mapSets.size(); q++){
                    for(int p=0; p<mapSets.get(q).doors.size(); p++){
                        //Go through all other doors
                        if(j == q){                                 //If in the same map as this door, TRY path to it
                            if(i != p){
                                ArrayList<PVector> cPath = testEntity.calcMapPathing(maps.get(j), mapSets.get(j).doors.get(i), mapSets.get(q).doors.get(p), 0); //##RANGE 0 ALWAYS ??
                                boolean pathExists = cPath.size() > 0;
                                if(pathExists){                                 //If is a valid path, add weight = cPath size
                                    //println("--VALID PATH--");
                                    dConTable.get(cInd).add( cPath.size() );
                                }
                                else{                                       //If no path, add weight -1
                                    dConTable.get(cInd).add( -1 );
                                }
                            }
                            else{                                           //If no path, add weight -1
                                dConTable.get(cInd).add( -1 );
                            }
                        }
                        else{                                       //If in different map, check if linked
                            int dVec1 = findDoorIndexFromVec( new PVector(j,i) );
                            int dVec2 = findDoorIndexFromVec( new PVector(q,p) );
                            if(doorTable.get(dVec1).get(dVec2)){      //If linked, add weight of 0 (infinitely fast)
                                dConTable.get(cInd).add( 0 );
                            }
                            else{                                           //If not linked, add weight -1 (no connection)
                                dConTable.get(cInd).add( -1 );
                            }
                        }
                    }
                }
                cInd++;
            }
        }
        //println("Finished making dConTable");
    }
    void createDoorTable(){
        /*
        Creates a fresh table
        */
        //Find # doors
        int doorNumber = 0;
        for(int i=0; i<mapSets.size(); i++){
            for(int j=0; j<mapSets.get(i).doors.size(); j++){
                //For all doors in all maps
                doorNumber++;
            }
        }
        //Create table
        doorTable.clear();
        for(int j=0; j<doorNumber; j++){
            doorTable.add( new ArrayList<Boolean>() );
            for(int i=0; i<doorNumber; i++){
                doorTable.get(j).add(false);
            }
        }
    }
    void printDoorTable(){
        /*
        Prints door table into console
        */
        println("DoorTable");
        println("---------");
        for(int j=0; j<doorTable.size(); j++){
            for(int i=0; i<doorTable.get(j).size(); i++){
                if(doorTable.get(j).get(i)){
                    print("T ");
                }
                else{
                    print(". ");
                }
            }
            println(" ");
        }
    }
    void extendDoorTable(){
        /*
        Adds another map's worth of space to the table (+n row and col)
        */
        //pass
    }
    int findDoorIndexFromPos(PVector pos){
        /*
        Given a physical map position, as (tileX, tileY, map#), then the index in the table is given
        ######################################################
        ## CHECK MAKE SURE WORKS ALRIGHT, IS A NEW FUNCTION ##
        ######################################################
        */
        int dInd = 0;
        //Account for all doors from maps beforehand
        for(int i=0; i<int(pos.z); i++){
            dInd += mapSets.get(i).doors.size();
        }
        //Account for doors in this map beforehand
        for(int i=0; i<mapSets.get( int(pos.z) ).doors.size(); i++){
            boolean xMatch = int(pos.x) == int(mapSets.get(int(pos.z)).doors.get(i).x);
            boolean yMatch = int(pos.y) == int(mapSets.get(int(pos.z)).doors.get(i).y);
            if(xMatch && yMatch){   //At the given door
                break;
            }
            dInd++; //**Note; Shouldn't add if break happens first
        }
        return dInd;
    }
    PVector findDoorPosFromIndex(int cInd){
        /*
        Given the index, it returns the physical position on the map of the door
        */
        PVector dVec = findDoorVecFromInd(cInd);
        PVector dPos = mapSets.get( int(dVec.x) ).doors.get( int(dVec.y) );
        return new PVector(dPos.x, dPos.y, dVec.x);
    }
    PVector findLinkedDoorVecFromPos(PVector pos, int iMap){
        /*
        Given the doorPos (physical position on map) and the map that that door is from (iMap), the 
        function will return the linked doorVec (vector in table of LINKED door)

        iDoorVec = initial door vector (one given to function intially)
        lDoorVec = linked door vector (found by function)
        */
        int doorInd      = findDoorIndexFromPos(pos, iMap);
        PVector iDoorVec = findDoorVecFromInd(doorInd);
        PVector lDoorVec = findLinkedDoorVec(iDoorVec);
        return lDoorVec;
    }
    int findDoorIndexFromPos(PVector pos, int iMap){
        /*
        Returns the doorIndex of the door at the given doorPos, in the map given
        */
        int doorIndex = -1;
        for(int i=0; i<mapSets.get(iMap).doors.size(); i++){
            boolean xMatch = pos.x == mapSets.get(iMap).doors.get(i).x;
            boolean yMatch = pos.y == mapSets.get(iMap).doors.get(i).y;
            if(xMatch && yMatch){
                //Now account for previous indices
                doorIndex = 0;
                for(int j=0; j<iMap; j++){
                    doorIndex += mapSets.get(j).doors.size();
                }
                doorIndex += i;
                break;
            }
        }
        return doorIndex;
    }
    int findDoorIndexFromVec(PVector d){
        /*
        Finds the doorIndex from the specified doorVec d
        */
        int doorTotal = 0;
        for(int i=0; i<int(d.x); i++){
            doorTotal += mapSets.get(i).doors.size();
        }
        return doorTotal +int(d.y);
    }
    PVector findDoorVecFromInd(int iDoor){
        /*
        Finds the doorVec from specifying doorIndex
        */
        PVector vDoor = new PVector(-1,-1);
        for(int i=0; i<mapSets.size(); i++){
            if(iDoor -mapSets.get(i).doors.size() < 0){
                vDoor = new PVector(i, iDoor);
                break;
            }
            else{
                iDoor -= mapSets.get(i).doors.size();
            }
        }
        return vDoor;
    }
    PVector findLinkedDoorVec(PVector vDoor){
        /*
        Finds the doorVec that is lead to by the given doorVec
        */
        int doorRow = findDoorIndexFromVec(vDoor);
        PVector linkedDoor = new PVector(-1,-1);
        if(doorRow < doorTable.size()){
            for(int i=0; i<doorTable.get(doorRow).size(); i++){
                if( doorTable.get(doorRow).get(i) ){
                    //If finds a linked door
                    linkedDoor = findDoorVecFromInd(i);
                    break;
                }
            }
        }
        return linkedDoor;
    }
    void linkDoors(PVector d1, PVector d2){
        /*
        Links/unlinks doors d1 and d2 together, where;
        Reverses the doors current linkage state
        x = map ind
        y = door ind
        */
        int val1 = findDoorIndexFromVec(d1);
        int val2 = findDoorIndexFromVec(d2);
        boolean linkageState = doorTable.get(val1).get(val2);
        //Upper Tri half
        doorTable.get(val1).remove(val2);
        doorTable.get(val1).add(val2, !linkageState);
        //Lower Tri half
        doorTable.get(val2).remove(val1);
        doorTable.get(val2).add(val1, !linkageState);
    }


    void moveComponent(){
        /*
        Moves either the selected map or the whole screen
        */
        if(movingOccurring){
            if(movingMap == -1){
                //Screen
                PVector vDiff = new PVector(mouseX -clickPos.x, mouseY -clickPos.y);
                startPos.x = objOrigPos.x +vDiff.x;
                startPos.y = objOrigPos.y +vDiff.y;
            }
            else{
                //Maps
                PVector vDiff = new PVector(mouseX -clickPos.x, mouseY -clickPos.y);
                mapSets.get(movingMap).cPos.x = objOrigPos.x +vDiff.x;
                mapSets.get(movingMap).cPos.y = objOrigPos.y +vDiff.y;
            }
        }
    }



    void determineClickAction(){
        if(mouseButton == LEFT){
            checkLinkingClickStart();
            if(!linking){
                checkMapMoveClicks();
            }
        }
        if(mouseButton == RIGHT){
            checkCameraSwitch();
        }
    }
    void determineReleaseAction(){
        if(mouseButton == LEFT){
            movingOccurring = false;
            checkLinkingClickEnd();
        }
        if(mouseButton == RIGHT){
            //pass
        }
    }
    void checkCameraSwitch(){
        for(int i=0; i<mapSets.size(); i++){
            boolean withinX = (startPos.x +mapSets.get(i).cPos.x < mouseX) && (mouseX < startPos.x +mapSets.get(i).cPos.x +tRatio*mapSets.get(i).lMap.tiles.get(0).size());
            boolean withinY = (startPos.y +mapSets.get(i).cPos.y < mouseY) && (mouseY < startPos.y +mapSets.get(i).cPos.y +tRatio*mapSets.get(i).lMap.tiles.size());
            if(withinX && withinY){
                //Map has been clicked => switch to it
                cEnviro.cLair.cMap = i;
                cEnviro.switchGoBack();
            }
        }
    }
    void checkLinkingClickStart(){
        //Door linking check
        float linkRange = 3.0*tRatio;
        for(int i=0; i<mapSets.size(); i++){
            for(int j=0; j<mapSets.get(i).doors.size(); j++){
                PVector dPos = new PVector(startPos.x +mapSets.get(i).cPos.x +tRatio*mapSets.get(i).doors.get(j).x, startPos.y +mapSets.get(i).cPos.y +tRatio*mapSets.get(i).doors.get(j).y);
                float dist = vecDist(new PVector(mouseX, mouseY), dPos);
                if(dist < linkRange){
                    //Link occurs
                    linkObj = new PVector(i,j);
                    linking = true;
                    break;
                }
            }
        }
    }
    void checkLinkingClickEnd(){
        //Door linking check
        float linkRange = 3.0*tRatio;
        for(int i=0; i<mapSets.size(); i++){
            for(int j=0; j<mapSets.get(i).doors.size(); j++){
                PVector dPos = new PVector(startPos.x +mapSets.get(i).cPos.x +tRatio*mapSets.get(i).doors.get(j).x, startPos.y +mapSets.get(i).cPos.y +tRatio*mapSets.get(i).doors.get(j).y);
                float dist = vecDist(new PVector(mouseX, mouseY), dPos);
                if(dist < linkRange){
                    //Link occurs
                    linkDoors(linkObj, new PVector(i,j));
                    break;
                }
            }
        }
        linking = false;
    }
    void checkMapMoveClicks(){
        /*
        When mousePressed, finds which map was clicked (ith)
        OR if no map was pressed then you can drag move the screen (-1)
        */
        clickPos   = new PVector(mouseX, mouseY);
        objOrigPos = new PVector(startPos.x, startPos.y);
        movingOccurring = true;
        movingMap = -1;
        for(int i=0; i<mapSets.size(); i++){
            if(mapSets.get(i).mapClicked(startPos, tRatio)){
                movingMap = i;
                objOrigPos = new PVector(mapSets.get(i).cPos.x, mapSets.get(i).cPos.y);
                break;
            }
        }
    }
}