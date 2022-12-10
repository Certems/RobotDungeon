class lair{
    ArrayList<map> maps = new ArrayList<map>();
    int cMap = 0;

    int mReserve = 4;   //Indicates which map is marked as the 'reserve' map, which is a resting point for allies

    monitorStation mStation     = new monitorStation();
    commandStation cmdStation   = new commandStation();
    constructStation crtStation = new constructStation();
    upgradeStation upgStation   = new upgradeStation();
    inspectStation inpStation   = new inspectStation();

    storyManager cStory = new storyManager();

    int coins = 94;

    int nWave = 0;      //Wave number currently on
    int waveCount = 0;  //Number of enemies in this wave (TOTAL)
    int nSpawn   = 0;   //Number of enemies left to spawn (LEFT)
    int nKilled  = 0;   //Number of enemies killed
    int nExitted = 0;   //Number of enemies who have exitted the map
    boolean waveOver = false;   //Has the current wave ended

    int eSpawnRate  = 0;//Determines the rate at which enemies try to enter the entrances (frames per spawn) -> this value can be changed during the course of the game
    int eSpawnTimer = 0;

    boolean compute = false;
    int computeNumber = 15; //How many generations of computation will occur
    int computeRate   = 10; //How many frames of engine time per generation frame calculation
    int computeCounter= 0;      //Keeps track of when to stop
    int computeTicker = 0;      //

    lair(){
        //pass
    }

    void displayMap(int mapN){
        maps.get(mapN).display();
        displayWaveDetails();
        displayRunningStats();
    }
    void displayCamera(){
        pushStyle();
        background(200,100,100);
        mStation.display();
        popStyle();
    }
    void displayCommand(){
        cmdStation.display();
    }
    void displayConstruct(){
        crtStation.display();
    }
    void displayUpgrade(){
        upgStation.display();
    }
    void displayInspect(){
        inpStation.display(maps, cMap);
    }


    void displayWaveDetails(){
        /*
        Displays details about the wave overlaying the map

        For the enemeis left, the display will show;
        |       Total Outside        |  -> 0 with time
        | Alive on map | Dead on map |  = Sums to waveCount always
        */
        pushStyle();

        //Enemies left
        PVector wNumPos = new PVector(width/2.0, 1.0*height/20.0);
        PVector wNumDim = new PVector(width/15.0, 1.0*height/25.0);
        float tSize = 15;
        rectMode(CENTER);
        textAlign(CENTER, CENTER);
        textSize(tSize);
        if(waveOver){
            fill(132, 129, 51, 150);}
        else{
            fill(60,60,60,150);}
        noStroke();
        rect(wNumPos.x, wNumPos.y, wNumDim.x, 2.0*wNumDim.y);
        //Enemies OUTSIDE
        fill(181, 232, 151);
        text(nSpawn, wNumPos.x, wNumPos.y -wNumDim.y/3.0);
        //Enemies ALIVE
        fill(151, 205, 232);
        text( (waveCount-nSpawn)-nKilled , wNumPos.x -wNumDim.x/3.0, wNumPos.y +wNumDim.y/3.0);
        //Enemies DEAD
        fill(232, 151, 170);
        text(nKilled, wNumPos.x +wNumDim.x/3.0, wNumPos.y +wNumDim.y/3.0);

        //Wave number
        PVector nWavePos = new PVector(wNumPos.x -wNumDim.x, wNumPos.y);
        fill(220,220,220);
        text("Wave "+nWave, nWavePos.x, nWavePos.y);

        popStyle();
    }
    void displayRunningStats(){
        /*
        Displays other important info carried over rounds
        e.g coins
        */
        pushStyle();

        //Coins
        PVector coinPos = new PVector(7.0*width/10.0, height/20.0);
        float coinSize = 18.0;
        textSize(coinSize);
        textAlign(CENTER, CENTER);
        noStroke();
        fill(227, 235, 120);
        ellipse(coinPos.x, coinPos.y, coinSize*1.5, coinSize*1.5);
        fill(0);
        text(coins, coinPos.x, coinPos.y);

        //...
        //pass

        popStyle();
    }


    void calc(int iMap){
        /*
        Calculates one generation of the given map;
        -Entity action (enemy + ally)
            -Movement
            -Chatter
            -Follow jobs
            -Etc
        -Trap action +Associated dynamic objects of trap
        -Trap events (e.g brakeages)
        -Remove dead entities
        */
        calcEnemyAction(iMap);
        calcAllyAction(iMap);
        calcTrapAction(iMap);
        removeDeadEntities(iMap);
    }
    void calcTrapAction(int iMap){
        for(int j=0; j<maps.get(iMap).tiles.size(); j++){
            for(int i=0; i<maps.get(iMap).tiles.get(j).size(); i++){
                maps.get(iMap).tiles.get(j).get(i).cVolume.determineAction( maps.get(iMap).tiles.get(j).get(i) );
            }
        }
    }
    void removeDeadEntities(int iMap){
        for(int j=0; j<maps.get(iMap).tiles.size(); j++){
            for(int i=0; i<maps.get(iMap).tiles.get(j).size(); i++){
                for(int z=maps.get(iMap).tiles.get(j).get(i).enemies.size()-1; z>=0; z--){
                    boolean isDead = maps.get(iMap).tiles.get(j).get(i).enemies.get(z).health <= 0;
                    if(isDead){
                        maps.get(iMap).tiles.get(j).get(i).enemies.remove(z);
                        nKilled++;
                        coins++;
                    }
                }
            }
        }
    }
    void calcEnemySpawn(){
        /*
        Decides when to spawn enemies
        */
        eSpawnTimer++;
        if(eSpawnTimer > eSpawnRate){   //## ADD SOME RANDOMNESS SO THEY SPAWN ~EVERY ESPAWNRATE, NOT EXACTLY ##
            eSpawnTimer = 0;
            //println("Spawned Enemy...");
            nSpawn--;
            spawnEnemyAtRandom();
        }
    }


    void calcWaveState(){
        /*
        Calculates what to do based on the wave state (in wave or not)
        Occurs when COMPUTING ONLY
        */
        if(waveOver){
            calcGrace();}
        else{
            calcWave();}
    }
    void calcGrace(){
        /*
        Calculates what should happen in the 'grace' time between waves
        */
        //pass
    }
    void calcWave(){
        /*
        Determines how to progress the game during a wave SPECIFICALLY
        .Spawn enemies
        .Adjust wave counter
        .Manage any other 'mid-flow' changes
        */
        setSpawnRate();
        calcEnemySpawn();
        if(nSpawn <= 0){
            //Wave finished
            waveOver = true;
        }
    }
    void startNewWave(int eCount){
        /*
        Initialises a new wave
        eCount = # enemies to be spawned
        */
        nWave++;
        waveCount = eCount;
        nSpawn    = waveCount;
        nKilled   = 0;
        waveOver  = false;
    }
    void setSpawnRate(){
        /*
        Sets eSpawnRate based on certain conditions
        */
        eSpawnRate = 5;
    }
    void spawnEnemyAtRandom(){
        /*
        Randomly chooses an entrance to spawn an enemy at
        */
        ArrayList<PVector> eVec = mStation.findEntranceVecs();
        float sProb = 1.0 /eVec.size();
        float rVal = random(0.0, 1.0);
        int spawnEntrance = floor(rVal/sProb);
        createEnemy(int(eVec.get(spawnEntrance).x), mStation.mapSets.get(int(eVec.get(spawnEntrance).x)).entrances.get(int(eVec.get(spawnEntrance).y)));
    }
    void createEnemy(int iMap, PVector iPos){
        orc newEnemy = new orc(iPos, iMap);

        jMove newJob = new jMove( findExitVecs().get(0) );
        newJob.cEntity = newEnemy;
        newEnemy.jobs.add(newJob);

        maps.get(iMap).tiles.get(int(iPos.y)).get(int(iPos.x)).enemies.add(newEnemy);
    }
    void calcEnemyAction(int iMap){
        /*
        Calculates action for each enemy entity
        */
        for(int j=0; j<maps.get(iMap).tiles.size(); j++){
            for(int i=0; i<maps.get(iMap).tiles.get(j).size(); i++){
                //Go through all tiles
                for(int p=0; p<maps.get(iMap).tiles.get(j).get(i).enemies.size(); p++){
                    maps.get(iMap).tiles.get(j).get(i).enemies.get(p).calcAction();
                }
            }
        }
    }
    void calcAllyAction(int iMap){
        /*
        Calculates action for each ally entity
        */
        for(int j=0; j<maps.get(iMap).tiles.size(); j++){
            for(int i=0; i<maps.get(iMap).tiles.get(j).size(); i++){
                //Go through all tiles
                for(int p=0; p<maps.get(iMap).tiles.get(j).get(i).allies.size(); p++){
                    maps.get(iMap).tiles.get(j).get(i).allies.get(p).calcAction();
                }
            }
        }
    }


    ArrayList<PVector> findExitVecs(){
        /*
        Returns all exits in lair as;
        (x,y,z) = (tileX, tileY, map#)
        maps = all maps in lair
        */
        ArrayList<PVector> exitVecs = new ArrayList<PVector>();
        for(int k=0; k<maps.size(); k++){
            for(int j=0; j<maps.get(k).tiles.size(); j++){
                for(int i=0; i<maps.get(k).tiles.get(j).size(); i++){
                    if(maps.get(k).tiles.get(j).get(i).cVolume.type == "exit"){
                        exitVecs.add(new PVector(i,j,k));
                    }
                }
            }
        }
        return exitVecs;
    }
    PVector findBuildDesk(int nMap){
        /*
        Finds a build desk in the given map
        ####
        ## NOTE; CURRENTLY JUST LOOKS FOR A SINGLE ONE IT SEES, DOESNT CARE ABOUT CLOSER OR WHATNOT
        ####
        */
        PVector deskPos = new PVector(-1,-1,nMap);
        for(int j=0; j<maps.get(nMap).tiles.size(); j++){
            for(int i=0; i<maps.get(nMap).tiles.get(j).size(); i++){
                if(maps.get(nMap).tiles.get(j).get(i).cVolume.type == "buildDesk"){
                    deskPos = new PVector(i,j,nMap);
                    break;
                }
            }
        }
        return deskPos;
    }
    

    void calcMapsGeneration(){
        /*
        Calculates what should happen overall when calculating
        */
        //Global
        calcWaveState();
        for(int i=0; i<maps.size(); i++){
            //Calc works for what should happen to just that map per generation
            calc(i);
        }
    }
    void computeGenerations(){
        //Wile computing...
        if(compute){
            //**Tick a generation
            if(computeCounter % computeRate == 0){
                computeTicker++;
                calcMapsGeneration();
            }
            //Finalise computation
            if(computeTicker >= computeNumber){
                compute = false;
                computeCounter = 0;
                computeTicker  = 0;
                cEnviro.loadButtons_mapScreen();
            }
            computeCounter++;
        }
        //While not computing...
        else{
            //pass
        }
    }


    void createMapPreset(int preset){
        initMaps(preset);
        initMonitorStation(preset);
    }
    void initMaps(int type){
        /*
        Loads the required maps, finds the startPos (to determine how it is initially displayed) and then adds the 
        maps to the map list
        */
        maps.clear();
        if(type == 0){
            map newMap1 = new map();
            newMap1.loadStringMap(0);
            map newMap2 = new map();
            newMap2.loadStringMap(1);
            map newMap3 = new map();
            newMap3.loadStringMap(1);
            map newMap4 = new map();
            newMap4.loadStringMap(2);
            map newMap5 = new map();
            newMap5.loadStringMap(4);

            newMap1.findStartPos();newMap2.findStartPos();newMap3.findStartPos();newMap4.findStartPos();newMap5.findStartPos();
            maps.add(newMap1);maps.add(newMap2);maps.add(newMap3);maps.add(newMap4);maps.add(newMap5);
        }
        if(type == 1){
            map newMap1 = new map();
            newMap1.loadStringMap(0);
            map newMap2 = new map();
            newMap2.loadStringMap(2);
            map newMap3 = new map();
            newMap3.loadStringMap(4);

            newMap1.findStartPos();newMap2.findStartPos();newMap3.findStartPos();
            maps.add(newMap1);maps.add(newMap2);maps.add(newMap3);
        }
    }
    void initMonitorStation(int type){
        /*
        Sets up monitor station details, such as linking map doors and forming the map table
        */
        mStation = new monitorStation();
        addMapsToStation();
        mStation.createDoorTable();
        if(type == 0){
            //Manually adding links
            mStation.linkDoors(new PVector(0,0), new PVector(1,1) );    //Doors
            mStation.linkDoors(new PVector(1,2), new PVector(2,1) );    //
            mStation.linkDoors(new PVector(2,2), new PVector(3,0) );    //
            mStation.linkDoors(new PVector(0,1), new PVector(4,0) );    //Portals
            mStation.linkDoors(new PVector(2,3), new PVector(4,1) );    //
            mStation.linkDoors(new PVector(1,3), new PVector(4,2) );    //
            mStation.linkDoors(new PVector(3,1), new PVector(4,3) );    //
            //Manually adding links
        }
        if(type == 1){
            //Manually adding links
            mStation.linkDoors(new PVector(0,0), new PVector(1,0) );    //Doors
            mStation.linkDoors(new PVector(2,0), new PVector(0,1) );    //Portals
            mStation.linkDoors(new PVector(2,1), new PVector(1,1) );    //
            //Manually adding links
        }
    }
    void addMapsToStation(){
        mStation.mapSets.clear();
        for(int i=0; i<maps.size(); i++){
            float border = height/20.0;
            mapForm newMapForm = new mapForm(new PVector(random(border, width-border), random(border, height-border)), maps.get(i), i);
            mStation.mapSets.add(newMapForm);
        }
    }

}