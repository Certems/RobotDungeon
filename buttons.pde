class button{
    String name;
    PVector pos;
    PVector dim;

    int type;

    button(String buttonName, PVector position, PVector dimension, int buttonType){
        name = buttonName;
        pos  = position;
        dim  = dimension;
        type = buttonType;
    }

    void display(){
        pushStyle();

        rectMode(CENTER);
        fill(255);
        stroke(0);
        strokeWeight(2);
        textAlign(CENTER, CENTER);
        textSize(dim.x/12.0);

        rect(pos.x, pos.y, dim.x, dim.y);

        fill(0);
        text(name, pos.x, pos.y);

        popStyle();
    }
    void executeButton(){
        if(type == 0){
            cEnviro.switchToHome();}
        if(type == 1){
            cEnviro.switchToMap();}
        if(type == 2){
            cEnviro.switchToCamera();}
        if(type == 3){
            cEnviro.switchToCommand();}
        if(type == 4){
            cEnviro.switchToConstruct();}
        if(type == 5){
            cEnviro.switchGoBack();}
        if(type == 6){
            cEnviro.switchToNewGame();}
        if(type == 7){
            cEnviro.cLair.compute = true;
            cEnviro.buttons.clear();
        }
        if(type == 8){
            //Show BLOCKERS choices in construct screen
            cEnviro.cLair.crtStation.switchToOptions(0);
        }
        if(type == 9){
            //Show TRAPS choices in construct screen
            cEnviro.cLair.crtStation.switchToOptions(1);
        }
        if(type == 10){
            //Show TRIGGERS choices in construct screen
            cEnviro.cLair.crtStation.switchToOptions(2);
        }
        if(type == 11){
            //Show UTILITIES choices in construct screen
            cEnviro.cLair.crtStation.switchToOptions(3);
        }
        if(type == 12){
            //Generate build blueprint from construct menu -> if has anything in it
            cEnviro.cLair.crtStation.addBlueprintToJobs();
        }
        if(type == 13){
            cEnviro.switchToUpgrade();}
        if(type == 14){
            //Switches between construction modes
            cEnviro.switchToNewConstructMode();
        }
        if(type == 15){
            //Generate activate jobs from markers
            cEnviro.cLair.crtStation.generateActivationJobs();
        }
        if(type == 16){
            cEnviro.switchToInspect();}
    }
    boolean buttonPressed(){
        boolean withinX = (pos.x -dim.x/2 < mouseX) && (mouseX < pos.x +dim.x/2.0);
        boolean withinY = (pos.y -dim.y/2 < mouseY) && (mouseY < pos.y +dim.y/2.0);
        if(withinX && withinY){
            return true;
        }
        else{
            return false;
        }
    }
}