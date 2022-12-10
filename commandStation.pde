class commandStation{
    /*
    The command station holds simplified information on the state of your workforce
    It handles the display and input for commands

    -Accessed by entering command state
    -- Shows # of units in each map (/room) and in reserve (if free == being in reserve)
    -- Shows order and # of queued requests to be done by workforce
        - Clicking on one of these bars highlights units in that bar and their position can be viewed 
          by hovering over their icon
        - Here if units are clicked they are relieved from their piece of work, and that work is added
          back to the queue
        - Clicking on items in the queue move them to the top place in the queue (prioritise them)
    */
    ArrayList<unitZone> unitZones = new ArrayList<unitZone>();                          //List of unit zones

    ArrayList<job> jobQueue    = new ArrayList<job>();                                 //Stores list of jobs to be done by units

    boolean overview = true;    //Show all general info
    int iSubview     = -1;      //Show a sub menu (e.g focus on a room[0,i] or reserve[-1])
    int zoomMap      = 0;       //Map # that is zoomed in on in subview
    int zoomUnit     = -1;      //Which unit to highlight (-1 = no unit)

    float unitWidth = height/20.0;  //Rough size of a unit in a map

    commandStation(){
        createActivateJob(new PVector(4,5,4));
        createMoveJob(new PVector(4,4,4));
    }

    void display(){
        if(overview){
            displayMainview();}
        else{
            displaySubview();}
    }
    void displayMainview(){
        /*
        1st menu when opening command menu
        Shows overview of most things
        */
        displayUnitZones();
        displayJobQueue();
    }
    void displaySubview(){
        /*
        Appears after clicking on a specific map (## AND POSSIBLY THE RESERVE ##)
        Shows more detailed look at the specific units in that specific map
        */
        cEnviro.cLair.displayMap(zoomMap);    //## NOT FINISHED, NEEDS TO STOP OTHER DISPLAY SO THERE IS NO DOUBLE DISPLAYING ##
        highlightMapUnit(cEnviro.cLair.maps.get(zoomMap));
        displayUnitZones();
    }
    void displayUnitZones(){
        for(int i=0; i<unitZones.size(); i++){
            unitZones.get(i).display();
        }
    }
    void displayJobQueue(){
        pushStyle();

        //Draw box
        PVector boxDim  = new PVector(1.2*width/20.0, 6.5*height/10.0);
        PVector cBoxPos = new PVector(width -1.8*boxDim.x, height/2.0 -(boxDim.y -height/4.0));
        rectMode(CORNER);
        fill(184, 44, 160, 150);
        stroke(50,50,50);
        strokeWeight(2);
        rect(cBoxPos.x, cBoxPos.y, boxDim.x, boxDim.y);

        //List jobs
        float subBoxWidth = boxDim.y/20.0;
        rectMode(CENTER);
        textAlign(CENTER, CENTER);
        textSize(13);
        noStroke();
        for(int i=0; i<jobQueue.size(); i++){
            fill(160,160,160, 100);
            rect(cBoxPos.x +boxDim.x/2.0, cBoxPos.y +i*1.1*subBoxWidth +1.1*subBoxWidth/2.0, boxDim.x*0.8, subBoxWidth);
            fill(255);
            text(jobQueue.get(i).giveJobTitle(), cBoxPos.x +boxDim.x/2.0, cBoxPos.y +i*1.1*subBoxWidth +1.1*subBoxWidth/2.0);
        }

        popStyle();
    }
    void highlightMapUnit(map cMap){
        /*
        Highlights the unit on the map, when hovered in the subview
        Note; 0 used instead of zoomMap because already moved to situation where in subview, so only one (the required) unitZone present
        */
        //If a unit is highlighted...
        if(unitZones.get(0).hInd != -1){
            PVector uMapIndPos = unitZones.get(0).eSet.get(unitZones.get(0).hInd).iPos;
            PVector uMapPxlPos = new PVector(cMap.startPos.x +cMap.tileWidth*uMapIndPos.x, cMap.startPos.y +cMap.tileWidth*uMapIndPos.y);
            pushStyle();
            noFill();
            stroke(0,0,255);
            strokeWeight(5);
            ellipse(uMapPxlPos.x, uMapPxlPos.y, 1.1*cMap.tileWidth, 1.1*cMap.tileWidth);
            popStyle();
        }
    }


    void calc(){
        updateZones();
    }
    void updateZones(){
        for(int i=0; i<unitZones.size(); i++){
            unitZones.get(i).update();
        }
    }


    void createBuildJob(blueprint cBlueprint){
        /*
        Creates a new BUILD job and places it in the job queue
        */
        jBuild newJob = new jBuild(cBlueprint);
        jobQueue.add(newJob);
    }
    void createActivateJob(PVector activatePoint){
        /*
        Creates a new ACTIVATE job and places it in the job queue
        */
        jActivate newJob = new jActivate(activatePoint, 2);
        jobQueue.add(newJob);
    }
    void createMoveJob(PVector endPoint){
        /*
        Creates a new MOVE job and places it in the job queue
        */
        jMove newJob = new jMove(endPoint);
        jobQueue.add(newJob);
    }


    void populateUnitZones(ArrayList<map> maps){
        /*
        Creates the needed unit zones for the given sitution
        1. If Overview; Create zone for each map + reserves
        2. If SubView;  Create zone for just given map
        */
        unitZones.clear();
        if(overview){
            //1
            float bHeight = (height*0.75) /(maps.size());
            float bWidth  = width/2.0;
            for(int i=0; i<maps.size(); i++){
                unitZone newZone = new unitZone(findMapAllies(maps.get(i)), new PVector(width/2.0 -bWidth/2.0, height/8.0 +i*1.05*bHeight), new PVector(bWidth, bHeight), new PVector(156, 199, 214));
                unitZones.add(newZone);
            }
        }
        else{
            //2
            unitZone newZone = new unitZone(findMapAllies(maps.get(zoomMap)), new PVector(width/4.0, 8.0*height/10.0), new PVector(width/2.0, 1.0*height/10.0), new PVector(156, 199, 214));
            unitZones.add(newZone);
        }
    }
    ArrayList<entity> findMapAllies(map cMap){
        ArrayList<entity> allySet = new ArrayList<entity>();
        for(int j=0; j<cMap.tiles.size(); j++){
            for(int i=0; i<cMap.tiles.get(j).size(); i++){
                for(int z=0; z<cMap.tiles.get(j).get(i).allies.size(); z++){
                    allySet.add( cMap.tiles.get(j).get(i).allies.get(z) );
                }
            }
        }
        return allySet;
    }


    void determineClickAction(ArrayList<map> cMaps){
        if(overview){
            //If in overview...
            checkMainMapClick(cMaps);
            checkPrioritiseJob();
        }
        else{
            //If in subview...
            if(unitZones.get(0).hInd != -1){
                //If something is hovered...
                dismissUnit( unitZones.get(0).eSet.get( unitZones.get(0).hInd ) );
            }
        }
    }


    void checkMainMapClick(ArrayList<map> cMaps){
        /*
        ON CLICK ACTION
        Checks for the clicking within a main map zone
        e.g when overview = true
        */
        for(int i=0; i<unitZones.size(); i++){
            if(unitZones.get(i).zoneClicked() && (i<cMaps.size())){
                switchToSpecificMapview(i);
                break;
            }
        }
    }
    void switchToSpecificMapview(int hoveredMap){
        /*
        Changes to overview = false and adjusts other values accordingly
        */
        overview = false;
        zoomMap  = hoveredMap;
        populateUnitZones(cEnviro.cLair.maps);
    }
    void switchToOverview(){
        /*
        Changes to overview = false and adjusts other values accordingly
        */
        overview = true;
        populateUnitZones(cEnviro.cLair.maps);
    }
    void dismissUnit(entity cEntity){
        /*
        Removes latest job from given unit
        If they have more jobs, the next job will be performed by the unit
        If it has no more jobs, it will return to the designated 'reserve' room
        */
        println("--Dismissing unit--");
        if(cEntity.jobs.size() > 0){
            jobQueue.add(cEntity.jobs.get(0));
            cEntity.jobs.remove(0);
            cEntity.path.clear();
        }
    }
    void checkPrioritiseJob(){
        /*
        Checks all jobs to see which is clicked, then prioritises it
        */
        int prioInd = -1;
        for(int i=0; i< jobQueue.size(); i++){
            //** These values will need to change if box dim changes
            //## OR JUST SWITCH OVER TO UNIT ESC SYSTEM WITH CLASS HOLDING POS OF EACH JOB SHOWN ##
            PVector boxDim  = new PVector(1.2*width/20.0, 6.5*height/10.0);
            PVector cBoxPos = new PVector(width -1.8*boxDim.x, height/2.0 -(boxDim.y -height/4.0));
            float subBoxWidth = boxDim.y/20.0;

            boolean withinX = (cBoxPos.x +boxDim.x/2.0 -boxDim.x*0.8/2.0                            < mouseX) && (mouseX < cBoxPos.x +boxDim.x/2.0 +boxDim.x*0.8/2.0);
            boolean withinY = (cBoxPos.y +i*1.1*subBoxWidth +1.1*subBoxWidth/2.0 -subBoxWidth/2.0 < mouseY) && (mouseY < cBoxPos.y +i*1.1*subBoxWidth +1.1*subBoxWidth/2.0 +subBoxWidth/2.0);
            ellipse(cBoxPos.x +boxDim.x/2.0, cBoxPos.y +i*1.1*subBoxWidth +1.1*subBoxWidth/2.0, 10, 10);
            if(withinX && withinY){
                prioInd = i;
                break;
            }
        }
        if( ( 0 <= prioInd) && (prioInd < jobQueue.size()) ){
            prioritiseJob(prioInd);
        }
    }
    void prioritiseJob(int pInd){
        /*
        Sends given job to the top of queue
        */
        println("--Prioritising Job--");
        job movingJob = jobQueue.get(pInd);
        jobQueue.remove(pInd);
        jobQueue.add(0, movingJob);
    }
    void giveUnitJob(entity currentEntity, job cJob){
        /*
        Takes given unit and assigns it a general job
        In most cases this job will be from the top of the job queue
        */
        cJob.cEntity = currentEntity;
        currentEntity.jobs.add(cJob);
    }
    void giveUnitNextJob(entity cEntity){
        /*
        Gives the unit the newest job in the queue, and removes that job from the queue
        */
        if(jobQueue.size() > 0){
            giveUnitJob(cEntity, jobQueue.get(0));
            jobQueue.remove(0);
        }
    }
    void giveFreeUnitNextJob(){
        /*
        Selects a free unit and givesItNextJob
        */
        for(int i=0; i<unitZones.size(); i++){
            ArrayList<entity> eFree = unitZones.get(i).giveFreeSet();
            if(eFree.size() > 0){
                giveUnitNextJob(eFree.get(0));
                break;
            }
        }
    }

}