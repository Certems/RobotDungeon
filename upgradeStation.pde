class upgradeStation{
    /*
    Holds information about new upgrades, and gives an interface to select new upgrades whenever
    required
    Also manages the display for when you want to select (to actually use) abilities
    Upgrades are effects stored in lairs that allow additional actions to to be performed by the player

    Ability list;
    "CpuBoost"    -> Increases CPU possible maximum
    "BloodRitual" -> Kills all enemies AND allies in a given room, overheats CPU
    "PowerSurge"  -> Refreshes all trap cooldowns, heats CPU moderately
    */
    ArrayList<String> abilityChoice   = new ArrayList<String>();    //Abilities offered in choices
    ArrayList<String> abilityAcquired = new ArrayList<String>();    //Abilities owned

    boolean makingChoice = false;   //Allows the user to see options without being able to select, or if able to select

    upgradeStation(){
        randomiseChoices();
        abilityAcquired.add("CpuBoost");abilityAcquired.add("BloodRitual");abilityAcquired.add("PowerSurge");
    }

    void display(){
        if(makingChoice){
            displayChoice();}
        else{
            displaySelect();}
    }
    void displaySelect(){
        /*
        Displays the selection screen to actually USE abilities
        Displays in a circle around a given point, of radius r
        */
        pushStyle();
        rectMode(CENTER);
        //Filter
        fill(30,30,30, 200);
        noStroke();
        rect(width/2.0, height/2.0, width*1.1, height*1.1);

        //Main thing
        PVector cPos = new PVector(width/2.0, height/2.0);   //Centre pos
        float rad = height/3.0;   //Radius
        PVector iconDim = new PVector(rad/3.0, rad/3.0);
        if(abilityAcquired.size() == 1){   //If only 1 thing, display at centre
            displayAbilityIcon(abilityAcquired.get(0), cPos, iconDim);
        }
        else{   //If multiple things, display in circle
            float aOffset = ( (frameCount/60.0)/60.0 )%2.0*PI;  //Angle offset -> ( ()*** )%...  *** = Time period
            float theta = (2.0*PI) / (abilityAcquired.size());
            for(int i=0; i<abilityAcquired.size(); i++){
                PVector circlePos = new PVector(cPos.x +rad*cos(i*theta +aOffset), cPos.y +rad*sin(i*theta +aOffset));
                displayAbilityIcon(abilityAcquired.get(i), circlePos, iconDim);
            }
        }
        popStyle();
    }
    void displayChoice(){
        /*
        Displays the screen to let you CHOOSE a new ability

        ChoicePos = CENTER position for all ability list
        */
        pushStyle();
        rectMode(CENTER);
        //Filter
        fill(30,30,30, 200);
        noStroke();
        rect(width/2.0, height/2.0, width*1.1, height*1.1);


        fill(60,60,60, 100);
        stroke(0);
        strokeWeight(4);
        PVector cPos = new PVector(width/2.0, height/2.0);
        float choiceSize = (width/2.0)/abilityChoice.size();
        PVector iconDim = new PVector(choiceSize, choiceSize);

        for(int i=0; i<abilityChoice.size(); i++){
            PVector linePos = new PVector(cPos.x -(abilityChoice.size() -1)*iconDim.x +2.0*i*iconDim.x, cPos.y);
            PVector lineAdjustedPos = new PVector(linePos.x, linePos.y +abs(cPos.x-linePos.x)/width/100.0);    //**Adds slight curve to line
            displayAbilityIcon(abilityChoice.get(i), lineAdjustedPos, iconDim);
        }
        popStyle();
    }
    void activateAbility(String ability){
        if(ability == "CpuBoost"){
            //pass
        }
        if(ability == "BloodRitual"){
            //pass
        }
        if(ability == "PowerSurge"){
            //pass
        }
        //...
    }
    void displayAbilityIcon(String ability, PVector pos, PVector dim){
        //##
        //## COULD MAKE IT ITS OWN CLASS, BUT NOT REALLY COMPLICATED ENOUGH TO WARANT THAT
        //##
        pushStyle();
        if(ability == "CpuBoost"){
            fill(164, 66, 245);
            stroke(0);
            strokeWeight(2);
            ellipse(pos.x, pos.y, dim.x, dim.y);
        }
        if(ability == "BloodRitual"){
            fill(245, 66, 164);
            stroke(0);
            strokeWeight(2);
            ellipse(pos.x, pos.y, dim.x, dim.y);
        }
        if(ability == "PowerSurge"){
            fill(111, 66, 245);
            stroke(0);
            strokeWeight(2);
            ellipse(pos.x, pos.y, dim.x, dim.y);
        }
        //...
        popStyle();
    }
    void randomiseChoices(){
        abilityChoice.clear();
        abilityChoice.add("CpuBoost");
        abilityChoice.add("BloodRitual");
        abilityChoice.add("PowerSurge");
    }
}