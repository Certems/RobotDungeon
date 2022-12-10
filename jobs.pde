class job{
    /*
    A job is a task given to an entity which guides their behaviour
    e.g they will try to path towards an job marker to perform the job
        then will perform the job when they arrive there
    
    Jobs contain instructions for what must be done for a general job +specific info
    For example, jobs come in the types;
    Build    -> Builds given item at given place
    Activate -> Activates the volume (specific action determined by the volume)
    Move     -> Just asks the entity to move to a given tile
    ...
    */
    boolean jobStarted = false;     //Indicates when startup function should be run
    entity cEntity;

    job(){
        //pass
    }

    void doJob(){
        /*
        Will make the entity perform this job
        Exact details are stored by the given job
        */
    }

    String giveJobTitle(){
        /*
        Returns a (brief) description of the job
        Each job knows its own description
        e.g. "Building arrow trap", "Moving to tile", "Activating lever"
        */
        return "";
    }
}


class jBuild extends job{
    ArrayList<PVector> path = new ArrayList<PVector>();

    int buildInc  = 2;  //Increments at which building is completed -> one tile per X generations
    int bTimer    = 0;  //Counts how many actions have been done building so far 

    int nMap;
    blueprint cBlueprint;

    jBuild(blueprint currentBlueprint){
        cBlueprint = currentBlueprint;
        nMap = int(cBlueprint.posSet.get(0).z);
    }

    @Override
    void doJob(){
        /*
        Job requires the entity to;
        1. Find path to map where things are being built
        2. Path towards 'building desk' in the map
        3. Entity will do work on the desk, slowly placing the objects in the build blueprint
        */
        if(!jobStarted){
            jobStartup();
        }
        jobContinue();
    }
    void jobStartup(){
        /*
        Check if eligable to perform this job, e.g CAN ONLY BUILD CERTAIN THINGS AFTER WAVE
        */
        boolean waveOver = cEnviro.cLair.waveOver;
        if(!waveOver && cBlueprint.isBigProject){ //If a big project and wave is NOT over, send back to the job queue
            cEnviro.cLair.cmdStation.jobQueue.add(this);
            cEntity.jobs.remove(0);
        }
        else{
            cEntity.path.clear();
            bTimer = 0;
            PVector sPoint = new PVector(cEntity.iPos.x, cEntity.iPos.y, cEntity.mPos);
            PVector ePoint = cEnviro.cLair.crtStation.findBuildDeskPos(cEnviro.cLair.maps, int(cBlueprint.posSet.get(0).z));
            cEntity.path = cEntity.calcHyperPathing(cEnviro.cLair.maps, sPoint, ePoint, 1); //**Can be next to a tile for this pathing (range = 1)
            jobStarted = true;
        }
    }
    void jobContinue(){
        //println("Doing Job...");
        cEntity.travelHyperPath(cEnviro.cLair.maps);
        if(cEntity.path.size() == 0){
            bTimer++;
            if( (bTimer % buildInc) == 0 ){
                //Build next thing in set
                //println("Placing item...");
                buildNextItem(cEnviro.cLair.maps);
            }
        }
        if(cBlueprint.posSet.size() == 0){
            //--Finish Job--
            cEnviro.cLair.maps.get(nMap).cleaning = false;   //## WILL BUG OUT WITH MULTIPLE BIG PROJECTS IN ONE ROOM  -> NEED TO ADD A 1 TIME LIMIT ##
            cEntity.jobs.remove(0);
        }
    }
    void buildNextItem(ArrayList<map> maps){
        /*
        Replaces the tile at the given position with the new item specified 
        in the blueprint
        This is done by copying all held aspects of the item to the tile, then removing item from blueprint
        */
        //1
        if(cBlueprint.itemSet.get(0).cFloor != null){
            maps.get( int(cBlueprint.posSet.get(0).z) ).tiles.get( int(cBlueprint.posSet.get(0).y) ).get( int(cBlueprint.posSet.get(0).x) ).cFloor = cBlueprint.itemSet.get(0).cFloor;}
        if(cBlueprint.itemSet.get(0).cVolume != null){
            maps.get( int(cBlueprint.posSet.get(0).z) ).tiles.get( int(cBlueprint.posSet.get(0).y) ).get( int(cBlueprint.posSet.get(0).x) ).cVolume = cBlueprint.itemSet.get(0).cVolume;}
        if(cBlueprint.itemSet.get(0).cCeiling != null){
            maps.get( int(cBlueprint.posSet.get(0).z) ).tiles.get( int(cBlueprint.posSet.get(0).y) ).get( int(cBlueprint.posSet.get(0).x) ).cCeiling = cBlueprint.itemSet.get(0).cCeiling;}
        //2
        cBlueprint.posSet.remove(0);
        cBlueprint.itemSet.remove(0);
    }

    @Override
    String giveJobTitle(){
        String fullTitle = "";
        String mainName  = "Building ";
        String subName   = "";

        if(true){                   //## ANOTHER GIVEN CONDITION THAT DETERMINES THING BEING BUILT, REMEMBERED BY JOB ##
            subName = "...";
        }

        fullTitle = mainName +subName;
        return fullTitle;
    }
}


class jActivate extends job{
    PVector aPos;

    int tActivate = 2;  //How many actions it takes to activate for this job
    int aTimer    = 0;  //Counts how many actions have been done activating so far  

    jActivate(PVector activatePos, int activationTime){
        aPos = activatePos;
        tActivate = activationTime;
    }

    @Override
    void doJob(){
        /*
        1. Path to point
        2. When at point, start timer
        3. When timer done, activate thing by changing volume property
        */
        //1
        if(!jobStarted){
            jobStartup();
        }
        //2
        jobContinue();
    }
    void jobStartup(){
        cEntity.path.clear();
        aTimer = 0;
        PVector sPoint = new PVector(cEntity.iPos.x, cEntity.iPos.y, cEntity.mPos);
        cEntity.path = cEntity.calcHyperPathing(cEnviro.cLair.maps, sPoint, aPos, 1); //**Can be next to a tile for this pathing (range = 1)
        jobStarted = true;
    }
    void jobContinue(){
        //println("Doing Job...");
        cEntity.travelHyperPath(cEnviro.cLair.maps);        //## Need to adjust for being next to point, NOT on point
        if(cEntity.path.size() == 0){                               //##
            aTimer++;
            if(aTimer > tActivate){
                //Activate the thing
                volume activator = cEnviro.cLair.maps.get(cEntity.mPos).tiles.get( int(aPos.y) ).get( int(aPos.x) ).cVolume;
                activator.vActive = !activator.vActive;
                //--Finish Job--
                cEntity.jobs.remove(0);
            }
        }
    }

    @Override
    String giveJobTitle(){
        String fullTitle = "";
        String mainName  = "Activating ";
        String subName   = "";

        if(true){                   //## ANOTHER GIVEN CONDITION THAT DETERMINES THING BEING ACTIVATED ##
            subName = "...";
        }

        fullTitle = mainName +subName;
        return fullTitle;
    }
}
class jMove extends job{
    PVector ePoint;

    jMove(PVector endPoint){
        ePoint = endPoint;
    }

    @Override
    void doJob(){
        /*
        (1)Create path, (2)then move along it once each time job is performed
        */
        //1
        if(!jobStarted){
            jobStartup();
        }
        //2
        jobContinue();
    }
    void jobStartup(){
        cEntity.path.clear();
        PVector sPoint = new PVector(cEntity.iPos.x, cEntity.iPos.y, cEntity.mPos);
        cEntity.path = cEntity.calcHyperPathing(cEnviro.cLair.maps, sPoint, ePoint, 0);   //**Must be on tile for this pathing (range = 0)
        jobStarted = true;
    }
    void jobContinue(){
        //println("Doing Job...");
        cEntity.travelHyperPath(cEnviro.cLair.maps);
        if(cEntity.path.size() == 0){
            //--Finish Job--
            cEntity.jobs.remove(0);
        }
    }

    @Override
    String giveJobTitle(){
        String fullTitle = "";
        String mainName  = "Moving to ";
        String subName   = "";

        if(true){                   //## FOR NOW JUST ALWAYS SAYS MOVING TO A MISC. TILE ##
            subName = "Tile";
        }

        fullTitle = mainName +subName;
        return fullTitle;
    }
}