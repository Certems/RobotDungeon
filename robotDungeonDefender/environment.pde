class environment{
    lair cLair;
    dialogue cDialogue = new dialogue();

    ArrayList<button> buttons = new ArrayList<button>();

    //Major screens
    boolean lairScreen = false;
    boolean homeScreen = true;

    //Minor screens (menus) -> within lair
    boolean dialogueMenu = false;

    //For lair screen...
    boolean mapScreen     = true;
    boolean cameraScreen  = false;
    boolean commandMenu   = false;
    boolean constructMenu = false;
    boolean upgradeMenu   = false;
    boolean inspectMenu   = false;

    environment(){
        createLair(0);

        switchToHome();
    }

    void display(){
        if(lairScreen){
            if(mapScreen){
                cLair.displayMap(cLair.cMap);
            }
            if(cameraScreen){
                cLair.displayCamera();
            }

            if(commandMenu){
                cLair.displayCommand();
            }
            if(constructMenu){
                cLair.displayConstruct();
            }
            if(upgradeMenu){
                cLair.displayUpgrade();
            }
            if(inspectMenu){
                cLair.displayInspect();
            }

        }
        if(homeScreen){
            displayHomeScreen();
        }

        displayAllButtons();

        if(dialogueMenu){
            cDialogue.display();
        }

        overlay();
        
    }
    void calc(){
        cLair.cStory.runChecks();   //Always run checks
        if(lairScreen){
            if(mapScreen){
                cLair.computeGenerations();
            }
            if(cameraScreen){
                cLair.mStation.moveComponent();
            }

            if(commandMenu){
                cLair.cmdStation.calc();
            }
            if(constructMenu){
                //pass
            }
            if(upgradeMenu){
                //pass
            }
            if(inspectMenu){
                //pass
            }
        }
        if(homeScreen){
            //pass
        }
    }


    void overlay(){
        pushStyle();

        fill(255);
        textAlign(CENTER,CENTER);
        textSize(18);
        text(frameRate, 30, 30);

        popStyle();
    }
    void displayAllButtons(){
        for(int i=0; i<buttons.size(); i++){
            buttons.get(i).display();
        }
    }
    void displayHomeScreen(){
        pushStyle();
        noStroke();

        background(150,100,255);

        fill(80,80,80);
        ellipse(width/2.0, 3.0*height/10.0, height/5.0, height/5.0);
        
        float eDim    = sin(        (frameCount%120) /120.0)*1.5*height/5.0;
        float opacity = sin( 2.0*PI*(frameCount%120) /120.0)*255;
        fill(100,100,100, opacity);
        ellipse(width/2.0, 3.0*height/10.0, eDim, eDim);

        popStyle();
    }


    void checkForButtonPress(){
        for(int i=0; i<buttons.size(); i++){
            if(buttons.get(i).buttonPressed()){
                buttons.get(i).executeButton();
                break;
            }
        }
    }

    void init_newGame(){
        createLair(0);
        cLair.coins = 15;
    }


    void switchToHome(){
        loadButtons_homeScreen();
        homeScreen = true;
    }
    void switchToMap(){
        switchGoBack();
    }
    void switchToNewGame(){
        init_newGame();
        cLair.cStory.runDialogue_newLairIntro();
        switchGoBack();
    }
    void switchToCamera(){
        loadButtons_cameraScreen();
        mapScreen    = false;
        cameraScreen = true;
    }
    void switchToCommand(){
        loadButtons_commandMenu();
        cLair.cmdStation.overview = true;           //## BIT OF A BODGE, SHOULD HAVE A BUTTON IN SUBVIEW THAT LETS YOU GO BACK TO OVERVIEW ##
        cLair.cmdStation.switchToOverview();
        commandMenu = true;
    }
    void switchToConstruct(){
        loadButtons_constructMenu();
        cLair.crtStation.resetStation();
        constructMenu = true;
    }
    void switchToUpgrade(){
        loadButtons_upgradeMenu();
        upgradeMenu = true;
    }
    void switchToInspect(){
        loadButtons_inspectMenu();
        inspectMenu = true;
    }
    void switchGoBack(){
        loadButtons_mapScreen();
        homeScreen    = false;
        lairScreen    = true;
        mapScreen     = true;
        cameraScreen  = false;
        commandMenu   = false;
        constructMenu = false;
        upgradeMenu   = false;
        inspectMenu   = false;
    }
    void switchToNewConstructMode(){
        cEnviro.cLair.crtStation.incrementBuildMode();
        loadButtons_constructMenu();
    }
    void loadButtons_homeScreen(){
        buttons.clear();
        button newButton1 = new button("New Game", new PVector(5.0*width/10.0, 5.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 6);
        button newButton2 = new button("Continue", new PVector(5.0*width/10.0, 7.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 1);
        buttons.add(newButton1);buttons.add(newButton2);
    }
    void loadButtons_mapScreen(){
        buttons.clear();
        button newButton1 = new button("Menu"     , new PVector(9.0*width/10.0, 1.0*height/10.0), new PVector(1.0*width/10.0, 0.4*height/10.0), 0);
        button newButton2 = new button("Compute"  , new PVector(1.0*width/10.0, 2.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 7);
        button newButton3 = new button("Cameras"  , new PVector(1.0*width/10.0, 8.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 2);
        button newButton4 = new button("Command"  , new PVector(9.0*width/10.0, 3.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 3);
        button newButton5 = new button("Construct", new PVector(9.0*width/10.0, 5.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 4);
        button newButton6 = new button("Upgrade"  , new PVector(9.0*width/10.0, 7.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 13);
        button newButton7 = new button("Inspect"  , new PVector(9.0*width/10.0, 9.0*height/10.0), new PVector(1.0*width/10.0, 1.0*height/10.0), 16);
        buttons.add(newButton1);buttons.add(newButton2);buttons.add(newButton3);buttons.add(newButton4);buttons.add(newButton5);buttons.add(newButton6);buttons.add(newButton7);
    }
    void loadButtons_cameraScreen(){
        buttons.clear();
        button newButton1 = new button("Back", new PVector(1.0*width/10.0, 8.0*height/10.0), new PVector(1.0*width/10.0, 0.75*height/10.0), 5);
        buttons.add(newButton1);
    }
    void loadButtons_commandMenu(){
        buttons.clear();
        button newButton1 = new button("Back", new PVector(1.0*width/10.0, 8.0*height/10.0), new PVector(1.0*width/10.0, 0.75*height/10.0), 5);
        buttons.add(newButton1);
    }
    void loadButtons_constructMenu(){
        int nMode = cEnviro.cLair.crtStation.nMode;
        if(nMode == 0){
            loadButtons_constructMenu_build();}
        if(nMode == 1){
            loadButtons_constructMenu_activate();}
    }
    void loadButtons_constructMenu_build(){
        buttons.clear();
        button newButton1 = new button("Back"        , new PVector(1.0*width/10.0, 8.0*height/10.0), new PVector(1.0*width/10.0, 0.75*height/10.0), 5);
        button newButton2 = new button("Blockers"    , new PVector(2.0*width/10.0, 1.5*height/10.0), new PVector(1.5*width/10.0, 0.75*height/10.0), 8);
        button newButton3 = new button("Traps"       , new PVector(4.0*width/10.0, 1.5*height/10.0), new PVector(1.5*width/10.0, 0.75*height/10.0), 9);
        button newButton4 = new button("Triggers"    , new PVector(6.0*width/10.0, 1.5*height/10.0), new PVector(1.5*width/10.0, 0.75*height/10.0), 10);
        button newButton5 = new button("Utilities"   , new PVector(8.0*width/10.0, 1.5*height/10.0), new PVector(1.5*width/10.0, 0.75*height/10.0), 11);
        button newButton6 = new button("GenBlueprint", new PVector(9.0*width/10.0, 7.0*height/10.0), new PVector(1.5*width/10.0, 0.55*height/10.0), 12);
        button newButton7 = new button("Switch Mode" , new PVector(9.0*width/10.0, 8.0*height/10.0), new PVector(1.5*width/10.0, 0.55*height/10.0), 14);
        buttons.add(newButton1);buttons.add(newButton2);buttons.add(newButton3);buttons.add(newButton4);buttons.add(newButton5);buttons.add(newButton6);buttons.add(newButton7);
    }
    void loadButtons_constructMenu_activate(){
        buttons.clear();
        button newButton1 = new button("Back"        , new PVector(1.0*width/10.0, 8.0*height/10.0), new PVector(1.0*width/10.0, 0.75*height/10.0), 5);
        button newButton2 = new button("GenJobs"     , new PVector(9.0*width/10.0, 7.0*height/10.0), new PVector(1.5*width/10.0, 0.55*height/10.0), 15);
        button newButton3 = new button("Switch Mode" , new PVector(9.0*width/10.0, 8.0*height/10.0), new PVector(1.5*width/10.0, 0.55*height/10.0), 14);
        buttons.add(newButton1);buttons.add(newButton2);buttons.add(newButton3);
    }
    void loadButtons_upgradeMenu(){
        buttons.clear();
        button newButton1 = new button("Back", new PVector(1.0*width/10.0, 8.0*height/10.0), new PVector(1.0*width/10.0, 0.75*height/10.0), 5);
        buttons.add(newButton1);
    }
    void loadButtons_inspectMenu(){
        buttons.clear();
        button newButton1 = new button("Back", new PVector(1.0*width/10.0, 8.0*height/10.0), new PVector(1.0*width/10.0, 0.75*height/10.0), 5);
        buttons.add(newButton1);
    }


    void createLair(int type){
        /*
        Makes a specific lair based on the type given;
        -1 = random
        n  = preset n, for n>=0
        */
        cLair = new lair();
        if(type == -1){
            //pass
        }
        else{
            cLair.createMapPreset(type);
        }
        //####################################################################################################
        //## SHOULD REDO THIS WHENEVER PATH-BLOCKING BUILDING OCCURS (MAJOR BUILDING) --OR-- DOORS RELINKED ##
        //####################################################################################################
        cLair.mStation.createDConTable(cLair.maps);
        //####################################################################################################
        //## SHOULD REDO THIS WHENEVER PATH-BLOCKING BUILDING OCCURS (MAJOR BUILDING) --OR-- DOORS RELINKED ##
        //####################################################################################################                                        
    }


    void keyPressedManager(){
        if(lairScreen){
            if(key == '1'){
                dialogueMenu = !dialogueMenu;
            }
            if(key == '2'){
                cDialogue.continueSpeeches();
            }
            if(key == '3'){
                PVector spwnPos = new PVector(floor(random(1,7)), floor(random(1,7)));
                droid newAlly1 = new droid(spwnPos, 4);

                jActivate newJob = new jActivate(new PVector(3,7,0), 2);
                newJob.cEntity = newAlly1;
                newAlly1.jobs.add( newJob );

                cLair.maps.get(4).tiles.get(int(spwnPos.y)).get(int(spwnPos.x)).allies.add(newAlly1);
            }
            if(key == '4'){
                //Assign unit a job
                cLair.cmdStation.giveFreeUnitNextJob();
            }
            if(key == '5'){
                //Start new wave
                cLair.generateNewWave();
            }
            if(key == '6'){
                //SWITHC UPGRADE CHOICE MAKING
                cLair.upgStation.makingChoice = !cLair.upgStation.makingChoice;
            }
        }
    }
    void keyReleasedManager(){
        if(lairScreen){
            //pass
        }
    }
    void mousePressedManager(){
        checkForButtonPress();
        if(lairScreen){
            if(cameraScreen){
                cLair.mStation.determineClickAction();
            }
            if(commandMenu){
                cLair.cmdStation.determineClickAction(cLair.maps);
            }
            if(constructMenu){
                cLair.crtStation.determineClickAction();
            }
        }
    }
    void mouseReleasedManager(){
        if(lairScreen){
            if(cameraScreen){
                cLair.mStation.determineReleaseAction();
            }
        }
    }
}