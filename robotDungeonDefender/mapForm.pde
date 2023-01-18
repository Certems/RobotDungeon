class mapForm{
    /*
    This represents the essence of a map
    It shows key information for the player and the monitorStation (e.g doors, exits, entrances, etc)

    The doors, exits and entrances arrays hold the coords of the given objects RELATIVE to the TOP-LEFT CORNER of the map
    */
    map lMap;
    int nMap;       //Map number
    PVector cPos;   //Corner position of the map
    ArrayList<PVector> doors     = new ArrayList<PVector>();    //Coords of given, in terms of TILES NOT PIXELS
    ArrayList<PVector> exits     = new ArrayList<PVector>();    //
    ArrayList<PVector> entrances = new ArrayList<PVector>();    //
    ArrayList<PVector> doorsConnected = new ArrayList<PVector>();   //Keeps track of which doors are joined to which

    boolean cFull    = false;   //Fully connected
    boolean cPartial = false;   //Partial connected
    boolean cNone    = false;   //Not connected

    mapForm(PVector cornerPos, map linkedMap, int mapNumber){
        cPos = cornerPos;
        lMap = linkedMap;
        nMap = mapNumber;
        findImportantInfo();
    }

    void display(PVector startPos, float tRatio){
        displayMap(startPos, tRatio);
        displayCleanStatus(startPos, tRatio);
    }
    void displayMap(PVector startPos, float tRatio){
        pushStyle();

        rectMode(CORNER);
        fill(0);    //Just in case ;)
        if(cFull){
            fill(119, 252, 3);}
        if(cPartial){
            fill(252, 206, 3);}
        if(cNone){
            fill(186, 21, 15);}
        stroke(255);
        strokeWeight(2);

        //Main body
        rect(startPos.x +cPos.x, startPos.y +cPos.y, tRatio*lMap.dim.x, tRatio*lMap.dim.y);

        noStroke();
        //Doors
        fill(0,0,255);
        for(int i=0; i<doors.size(); i++){
            ellipse(startPos.x +cPos.x +tRatio*doors.get(i).x, startPos.y +cPos.y +tRatio*doors.get(i).y, tRatio*0.8, tRatio*0.8);}
        //Exits
        fill(0,255,0);
        for(int i=0; i<exits.size(); i++){
            ellipse(startPos.x +cPos.x +tRatio*exits.get(i).x, startPos.y +cPos.y +tRatio*exits.get(i).y, tRatio*0.8, tRatio*0.8);}
        //Entrances
        fill(255,0,0);
        for(int i=0; i<entrances.size(); i++){
            ellipse(startPos.x +cPos.x +tRatio*entrances.get(i).x, startPos.y +cPos.y +tRatio*entrances.get(i).y, tRatio*0.8, tRatio*0.8);}

        popStyle();
    }
    void displayCleanStatus(PVector startPos, float tRatio){
        /*
        Displays sign over map if closed for cleaning
        */
        if(lMap.cleaning){
            pushStyle();
            fill(200,0,0,180);
            stroke(0);
            strokeWeight(4);
            //####
            //## REPLACE WITH TEXTURE
            //####
            ellipse(startPos.x +cPos.x +(tRatio*lMap.tiles.get(0).size())/2.0, startPos.y +cPos.y +(tRatio*lMap.tiles.size())/2.0, 1.2*tRatio*lMap.tiles.size(), 1.2*tRatio*lMap.tiles.size());
            popStyle();
        }
    }
    void findImportantInfo(){
        /*
        Finds the positions of the doors, exits and entrances
        */
        for(int j=0; j<lMap.tiles.size(); j++){
            for(int i=0; i<lMap.tiles.get(j).size(); i++){
                String type = lMap.tiles.get(j).get(i).cVolume.type;
                if(type == "door"){
                    doors.add(new PVector(i,j, nMap));}
                if(type == "exit"){
                    exits.add(new PVector(i,j, nMap));}
                if(type == "entrance"){
                    entrances.add(new PVector(i,j, nMap));}
            }
        }
    }
    boolean mapClicked(PVector startPos, float tRatio){
        boolean withinX = (startPos.x +cPos.x < mouseX) && (mouseX < startPos.x +cPos.x +lMap.dim.x*tRatio);
        boolean withinY = (startPos.y +cPos.y < mouseY) && (mouseY < startPos.y +cPos.y +lMap.dim.y*tRatio);
        if(withinX && withinY){
            return true;
        }
        else{
            return false;
        }
    }
}