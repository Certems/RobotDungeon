class map{
    PVector dim;

    ArrayList<ArrayList<tile>> tiles = new ArrayList<ArrayList<tile>>();

    PVector startPos;

    float tileWidth = 30.0;

    boolean cleaning = false;   //Is the room closed for cleaning

    map(){
        //pass
    }

    void display(){
        displayBackground();
        displayFloors();
        displayVolumes();
        displayEntities();
        displayCeilings();
    }
    void displayBackground(){
        if(cleaning){
            background(60,30,30);}
        else{
            background(30,30,30);}
    }
    void displayFloors(){
        //Floors
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                tiles.get(j).get(i).cFloor.display( new PVector(startPos.x +i*tileWidth, startPos.y +j*tileWidth), tileWidth );
            }
        }
    }
    void displayVolumes(){
        //Volumes
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                tiles.get(j).get(i).cVolume.display( new PVector(startPos.x +i*tileWidth, startPos.y +j*tileWidth), tileWidth );
            }
        }
    }
    void displayCeilings(){
        //Ceiling
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                tiles.get(j).get(i).cCeiling.display( new PVector(startPos.x +i*tileWidth, startPos.y +j*tileWidth), tileWidth );
            }
        }
    }
    void displayEntities(){
        displayEnemies();
        displayAllies();
    }
    void displayEnemies(){
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                for(int z=0; z<tiles.get(j).get(i).enemies.size(); z++){
                    tiles.get(j).get(i).enemies.get(z).display( new PVector(startPos.x +i*tileWidth, startPos.y +j*tileWidth), tileWidth );
                    //tiles.get(j).get(i).enemies.get(z).displayPath(startPos, tileWidth);
                }
            }
        }
    }
    void displayAllies(){
        for(int j=0; j<tiles.size(); j++){
            for(int i=0; i<tiles.get(j).size(); i++){
                for(int z=0; z<tiles.get(j).get(i).allies.size(); z++){
                    tiles.get(j).get(i).allies.get(z).display( new PVector(startPos.x +i*tileWidth, startPos.y +j*tileWidth), tileWidth );
                    //tiles.get(j).get(i).allies.get(z).displayPath(startPos, tileWidth);
                }
            }
        }
    }


    void findStartPos(){
        startPos = new PVector(width/2.0 -(tiles.get(0).size()/2.0)*tileWidth, height/2.0 -(tiles.size()/2.0)*tileWidth);
    }


    void createMap(int cType){
        if(cType == -1){
            //pass
        }
        else{
            loadStringMap(cType);
        }
    }
    void generateMapEmpty(){
        tiles.clear();
        for(int j=0; j<dim.y; j++){
            tiles.add( new ArrayList<tile>() );
            for(int i=0; i<dim.x; i++){
                tile newTile = new tile( new PVector(i,j) );
                tiles.get(j).add( newTile );
            }
        }
    }
    void loadStringMap(int genType){
        /*
        Preset maps are defined by;
        0. Creating required grid of blank tiles
        1. A series of filters are then applied over the whole grid
            specify how the map has changed from the default situation
        2. Maps loaded inside map class in 'loadMap'

        The filters are applied as so;
        0.0- Floors
        0.1- Volumes
        0.2- Ceilings
        0.3- ...

        [0.0]For flooors;
        0 = none
        1 = slab

        [0.1]For volumes
        0 = none
        1 = wall
        2 = spikeTrap
        3 = fireTrap
        4 = door (Regular)
        5 = door (Portal)
        6 = exit
        7 = entrance
        8 = buildDesk
        9 = brainCase

        [0.2]For ceilings;
        0 = none
        */

        //sMap0 Creation
        if(genType == 0){
            /*
            Room big 1
            */
            PVector sMapDim    = new PVector(20,20);
            dim = new PVector(sMapDim.x, sMapDim.y);
            IntList sMapFloor  = new IntList(
                0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0,
                0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
                0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
                0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            );
            IntList sMapVolume  = new IntList(
                0, 1, 0, 1, 7, 7, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 3, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 3, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0,
                0, 1, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
                0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
                1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
                0, 0, 0, 0, 0, 3, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0,
                0, 0, 0, 0, 1, 1, 2, 1, 1, 1, 3, 1, 1, 0, 0, 0, 0, 0, 1, 0,
                1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0,
                0, 1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0,
                1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0,
                0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 3, 1, 1,
                1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 4,
                0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0,
                0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1,
                0, 1, 1, 1, 1, 1, 5, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
            );
            IntList sMapCeiling  = new IntList(
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            );
            constructMapStringValues(sMapDim, sMapFloor, sMapVolume, sMapCeiling);
        }
        if(genType == 1){
            /*
            Room small 1
            */
            PVector sMapDim    = new PVector(8,12);
            dim = new PVector(sMapDim.x, sMapDim.y);
            IntList sMapFloor  = new IntList(
                0, 0, 0, 0, 0, 0, 1, 0,
                1, 1, 1, 1, 0, 1, 1, 0,
                1, 1, 1, 1, 0, 1, 1, 0,
                0, 0, 1, 1, 0, 1, 1, 0,
                0, 0, 1, 1, 0, 1, 1, 0,
                0, 0, 1, 1, 0, 1, 1, 0,
                0, 0, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 1, 1, 1, 1, 1,
                0, 0, 0, 0, 0, 1, 1, 1,
                1, 1, 1, 1, 0, 0, 0, 0,
                0, 1, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 0, 0, 0, 0, 0
            );
            IntList sMapVolume  = new IntList(
                1, 1, 1, 1, 1, 1, 5, 1,
                4, 0, 0, 0, 1, 0, 0, 1,
                0, 0, 0, 0, 1, 0, 0, 1,
                1, 1, 0, 0, 3, 0, 0, 1,
                0, 1, 2, 2, 1, 0, 0, 1,
                0, 1, 0, 0, 1, 0, 0, 1,
                0, 1, 0, 0, 1, 3, 1, 1,
                0, 1, 0, 0, 0, 0, 0, 0,
                1, 1, 3, 3, 1, 0, 0, 4,
                8, 0, 0, 0, 1, 1, 1, 1,
                1, 0, 0, 0, 1, 0, 0, 0,
                1, 1, 5, 1, 1, 0, 0, 0
            );
            constructMapStringValues(sMapDim, sMapFloor, sMapVolume, null);
        }
        if(genType == 2){
            /*
            Room big 2
            */
            PVector sMapDim    = new PVector(20,20);
            dim = new PVector(sMapDim.x, sMapDim.y);
            IntList sMapFloor  = new IntList(
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
                1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0,
                0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0,
                0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0,
                0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
                0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
                0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            );
            IntList sMapVolume  = new IntList(
                1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 3, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0,
                0, 1, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
                0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
                1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
                0, 0, 0, 0, 0, 3, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0,
                0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 3, 1, 1, 0, 0, 0, 0, 0, 1, 0,
                1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0,
                0, 1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0,
                1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 3, 1, 1,
                1, 1, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 6,
                0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 6,
                0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1,
                0, 1, 1, 1, 1, 1, 5, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
            );
            constructMapStringValues(sMapDim, sMapFloor, sMapVolume, null);
        }
        if(genType == 3){
            /*
            ...
            */
            PVector sMapDim    = new PVector(20,20);
            dim = new PVector(sMapDim.x, sMapDim.y);
            IntList sMapFloor  = new IntList(
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            );
            IntList sMapVolume  = new IntList(
                0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            );
            constructMapStringValues(sMapDim, sMapFloor, sMapVolume, null);
        }
        if(genType == 4){
            /*
            Reserve Area
            */
            PVector sMapDim    = new PVector(8,8);
            dim = new PVector(sMapDim.x, sMapDim.y);
            IntList sMapFloor  = new IntList(
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 1, 1, 1, 1, 1, 1, 0,
                1, 1, 1, 1, 1, 1, 1, 1,
                0, 1, 1, 1, 1, 1, 1, 0,
                0, 1, 1, 1, 1, 1, 1, 0,
                0, 1, 1, 1, 1, 1, 1, 0,
                0, 1, 1, 1, 1, 1, 1, 0,
                0, 1, 0, 0, 0, 0, 1, 0
            );
            IntList sMapVolume  = new IntList(
                1, 1, 1, 1, 1, 1, 1, 1,
                1, 0, 0, 0, 9, 0, 0, 1,
                5, 0, 0, 0, 0, 0, 0, 5,
                1, 0, 0, 0, 0, 0, 0, 1,
                1, 0, 0, 0, 0, 0, 0, 1,
                1, 0, 0, 0, 0, 0, 0, 1,
                1, 0, 0, 8, 0, 0, 0, 1,
                1, 5, 1, 1, 1, 1, 5, 1
            );
            constructMapStringValues(sMapDim, sMapFloor, sMapVolume, null);
        }
        
    }
    void constructMapStringValues(PVector sMapDim, IntList sMapFloor, IntList sMapVolume, IntList sMapCeiling){
        /*
        Takes given Intlists and other parameters and creates the tiles required
        to fully build the map
        */
        //New set
        tiles.clear();
        for(int j=0; j<sMapDim.y; j++){
            tiles.add( new ArrayList<tile>() );
            for(int i=0; i<sMapDim.x; i++){
                tile newTile = new tile( new PVector(i,j) );
                tiles.get(j).add(newTile);
            }
        }
        //Floor
        if(sMapFloor != null){
            for(int j=0; j<sMapDim.y; j++){
                for(int i=0; i<sMapDim.x; i++){
                    int indexVal = sMapFloor.get(i +j*int(sMapDim.x));
                    if(indexVal == 1){
                        tiles.get(j).get(i).cFloor = new slab();}
                }
            }
        }
        //Volume
        if(sMapVolume != null){
            for(int j=0; j<sMapDim.y; j++){
                for(int i=0; i<sMapDim.x; i++){
                    int indexVal = sMapVolume.get(i +j*int(sMapDim.x));
                    if(indexVal == 1){
                        tiles.get(j).get(i).cVolume = new wall();}
                    if(indexVal == 2){
                        tiles.get(j).get(i).cVolume = new spikeTrap();}
                    if(indexVal == 3){
                        tiles.get(j).get(i).cVolume = new fireTrap();}
                    if(indexVal == 4){
                        tiles.get(j).get(i).cVolume = new door(false);}
                    if(indexVal == 5){
                        tiles.get(j).get(i).cVolume = new door(true);}
                    if(indexVal == 6){
                        tiles.get(j).get(i).cVolume = new exit();}
                    if(indexVal == 7){
                        tiles.get(j).get(i).cVolume = new entrance();}
                    if(indexVal == 8){
                        tiles.get(j).get(i).cVolume = new buildDesk();}
                    if(indexVal == 9){
                        tiles.get(j).get(i).cVolume = new brainCase();}
                }
            }
        }
        //Ceiling
        if(sMapCeiling != null){
            for(int j=0; j<sMapDim.y; j++){
                for(int i=0; i<sMapDim.x; i++){
                    int indexVal = sMapCeiling.get(i +j*int(sMapDim.x));
                    if(indexVal == 1){
                        //pass
                    }
                }
            }
        }
    }

}