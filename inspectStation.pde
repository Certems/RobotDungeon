class inspectStation{
    //pass

    inspectStation(){
        //pass
    }

    void display(ArrayList<map> maps, int nMap){
        PVector cTilePos = calcHoveredTile(maps, nMap);
        if(cTilePos.x != -1.0){    //If a tile is being hovered
            boolean hasFloor  = maps.get(nMap).tiles.get( int(cTilePos.y) ).get( int(cTilePos.x) ).cFloor.type    != "none";  //Basically, if it shows any intersting qualities, let it be inspected
            boolean hasVolume = maps.get(nMap).tiles.get( int(cTilePos.y) ).get( int(cTilePos.x) ).cVolume.type   != "none";  //
            boolean hasCeiling = maps.get(nMap).tiles.get( int(cTilePos.y) ).get( int(cTilePos.x) ).cCeiling.type != "none";  //
            if((hasFloor || hasCeiling) || hasVolume){
                displayTileDetails(cTilePos, maps.get(nMap).startPos, maps.get(nMap).tileWidth, maps, nMap);
                //#######################################
                //#######################################
                //## HAVE AN ENTITY DISPLAYER AS WELL ###
                //#######################################
                //#######################################
            }
        }
    }
    void displayTileDetails(PVector coordPos, PVector startPos, float tileWidth, ArrayList<map> maps, int nMap){
        /*
        Displays details about the inspected tile, such as;
        - The type there (for floor, volume and ceiling)
        - ...

        cPos = corner pos of whole thing (TOP LEFT)
        */
        pushStyle();
        //####
        //## HAVE IT DYNAMICALLY SHIFT FROM L->R OR U->D IF THERES ISNT ENOUGH ROOM TO FULLY SHOW IT
        //####
        PVector cPos    = new PVector(startPos.x +coordPos.x*tileWidth +1.3*tileWidth/2.0, startPos.y +coordPos.y*tileWidth);
        PVector cellDim = new PVector(width/30.0, height/30.0);
        PVector dim     = new PVector(cellDim.x, 3.0*cellDim.y);
        
        //Back grid
        rectMode(CORNER);
        fill(0);
        stroke(255);
        strokeWeight(2);
        rect(cPos.x, cPos.y, dim.x, dim.y);
        line(cPos.x, cPos.y +cellDim.y, cPos.x +dim.x, cPos.y +cellDim.y);
        line(cPos.x, cPos.y +2.0*cellDim.y, cPos.x +dim.x, cPos.y +2.0*cellDim.y);

        textAlign(LEFT, CENTER);
        textSize(cellDim.y/3.2);
        //############################
        //## CHANGE TO COURIER FONT ##
        //############################
        //Ceiling
        String ceilingType = maps.get(nMap).tiles.get( int(coordPos.y) ).get( int(coordPos.x) ).cCeiling.type;
        fill(3, 169, 252);
        text("-Ceiling-", cPos.x, cPos.y +2.0*cellDim.y +1.0*cellDim.y/3.0);
        fill(255);
        text(ceilingType, cPos.x, cPos.y +2.0*cellDim.y +2.0*cellDim.y/3.0);
        //Volume
        String volumeType = maps.get(nMap).tiles.get( int(coordPos.y) ).get( int(coordPos.x) ).cVolume.type;
        fill(28, 252, 3);
        text("-Volume-", cPos.x, cPos.y +1.0*cellDim.y +1.0*cellDim.y/3.0);
        fill(255);
        text(volumeType, cPos.x, cPos.y +1.0*cellDim.y +2.0*cellDim.y/3.0);
        //Floor
        String floorType = maps.get(nMap).tiles.get( int(coordPos.y) ).get( int(coordPos.x) ).cFloor.type;
        fill(252, 111, 3);
        text("-Floor-", cPos.x, cPos.y +0.0*cellDim.y +1.0*cellDim.y/3.0);
        fill(255);
        text(floorType, cPos.x, cPos.y +0.0*cellDim.y +2.0*cellDim.y/3.0);

        popStyle();
    }


    PVector calcHoveredTile(ArrayList<map> maps, int nMap){
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
}