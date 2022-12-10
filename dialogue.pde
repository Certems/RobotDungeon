class dialogue{
    /*
    Holds information about dialogue to occur
    This holds the text and speaker, and will manage the sound and 
    display of the given diaglogue
    It can load premade scenarios or take new information and formulate
    it into a dialogue to be displayed at will

    ########################################################################################
    ## MAKE A NEW DIALOGUE REQUEST LOOK LIKE A TELEPHONE-ESC CALL TO BE ANSWERED MID GAME ##
    ########################################################################################

    ##############################################################################
    ## ADD celeste-esc "MI-MII-MI-MIMI" noises when continuing the conversation ##  /CubeWorld MIMIs
    ##############################################################################

    ############################################################
    ## COULD MAKE A TEXT TRANSLATOR TO DISPLAY IN CUSTOM FONT ##
    ############################################################

    text display;
    [                    Holds multiple speeches                            ]   Speeches
    [       Each speech is a separated text box     ][     . . . .          ]   Speeches.get(i)
    [Speech lines separated in each index][  ][  ][ ][  ][  ][  ][  ][  ][  ]   Speeches.get(i).get(j)

    For images, each speech is given an associated image at the ith index (e.g 1 speech has 1 image NOT per speech box)
    */
    ArrayList<ArrayList<String>> speeches = new ArrayList<ArrayList<String>>();
    ArrayList<PImage> associatedImgs      = new ArrayList<PImage>();
    ArrayList<PVector> associatedPos      = new ArrayList<PVector>();
    ArrayList<PVector> associatedDim      = new ArrayList<PVector>();

    int speechNumber = 0;   //Keeps track of which speech +image to show

    float sText = 20.0; //Text size

    float border = width/20.0;
    PVector textBoxStart = new PVector(border, height -7.0*sText*1.1 -border);      //Enough for 7 lines worth
    PVector textBoxDim   = new PVector(width -2.0*border, 7.0*sText*1.1);           //

    boolean speechOver = false;

    dialogue(){
        setupScenario0();
    }

    void display(){
        displayBackfade();
        if(speeches.size() > 0){
            displayImages();
            displayTextBox();
            displayText();
        }
    }
    void displayBackfade(){
        /*
        Displays a fading background
        */
        pushStyle();

        rectMode(CENTER);

        fill(0,0,0, 180);
        noStroke();
        //strokeWeight();

        rect(width/2.0, height/2.0, width, height);

        popStyle();
    }
    void displayImages(){
        /*
        Displays given images, i.e. usually a head
        */
        pushStyle();

        rectMode(CENTER);
        imageMode(CENTER);
        /*
        ################################################
        ## TEMPORARILY DISABLES BEFORE TEXTURES ADDED ##
        ################################################
        image(associatedImgs.get(speechNumber), 
            associatedPos.get(speechNumber).x, associatedPos.get(speechNumber).y +imageWobbleAnim(), 
            associatedDim.get(speechNumber).x, associatedDim.get(speechNumber).y);
        */
        //## SUBSTITUTE HERE ##
        fill(255,0,0);
        rect(associatedPos.get(speechNumber).x, associatedPos.get(speechNumber).y +imageWobbleAnim(), associatedDim.get(speechNumber).x, associatedDim.get(speechNumber).y);
        //## SUBSTITUTE HERE ##
        
        popStyle();
    }
    void displayTextBox(){
        /*
        Box to highlight the text
        */
        pushStyle();

        rectMode(CORNER);

        fill(0,0,0, 200);
        stroke(150,150,150, 200);
        strokeWeight(2);

        rect(textBoxStart.x, textBoxStart.y -sText/2.0, textBoxDim.x, textBoxDim.y);

        popStyle();
    }
    void displayText(){
        /*
        Displays the given text in the required structure
        */
        pushStyle();

        imageMode(CENTER);
        rectMode(CENTER);

        textSize(sText);
        textAlign(LEFT, CENTER);
        fill(255);
        //stroke();
        //strokeWeight();

        for(int i=0; i<speeches.get(speechNumber).size(); i++){
            text(speeches.get(speechNumber).get(i), textBoxStart.x, textBoxStart.y +i*sText);
        }
        
        popStyle();
    }

    float imageWobbleAnim(){
        float amp = height/30.0;
        int spd   = 3*60;
        return amp*cos( 2.0*PI*(frameCount%spd) / (float)spd );
    }

    void continueSpeeches(){
        if(speechNumber < speeches.size()-1){
            speechNumber++;
        }
        else{
            speechOver = true;
            speechNumber = 0;
            cEnviro.dialogueMenu = false;
        }
    }

    void setupScenario0(){
        //Add text
        speeches.clear();
        speeches.add(new ArrayList<String>());
        speeches.add(new ArrayList<String>());
        speeches.add(new ArrayList<String>());
        String line0_0 = "Yo yo big man whats guaning";
        String line0_1 = "Eh G you not lookion too big my mahn";
        String line0_2 = "Yo dude how you donig?";
        String line0_3 = "YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO";
        String line1_0 = "yeah lets go";
        String line2_0 = "bruh momentunjm";
        String line2_1 = "big bruh true true";
        speeches.get(0).add(line0_0);speeches.get(0).add(line0_1);speeches.get(0).add(line0_2);speeches.get(0).add(line0_3);
        speeches.get(1).add(line1_0);
        speeches.get(2).add(line2_0);speeches.get(2).add(line2_1);
        //Add images
        associatedImgs.clear();
        associatedPos.clear();
        associatedDim.clear();

        //associatedImgs.add();
        //associatedImgs.add();
        //associatedImgs.add();

        associatedPos.add( new PVector(7.0*width/10.0, height/2.0) );
        associatedPos.add( new PVector(7.0*width/10.0, height/2.0) );
        associatedPos.add( new PVector(7.0*width/10.0, height/2.0) );

        associatedDim.add( new PVector(2.0*width/10.0, 3.0*width/10.0) );
        associatedDim.add( new PVector(2.0*width/10.0, 3.0*width/10.0) );
        associatedDim.add( new PVector(2.0*width/10.0, 3.0*width/10.0) );
        //...
    }
    void setupScenario1(){
        //pass
    }
}