class unitZone{
    /*
    Holds sets of units parsed in
    Displays them in a scaling bounding box
    Keeps track how each should be displayed within this object
    */
    
    ArrayList<entity> eSet = new ArrayList<entity>();
    PVector cPos;           //Corner box is drawn from (top-left)
    PVector dim;            //Size of box
    boolean vDisp;

    int hInd = -1;

    PVector col;

    unitZone(ArrayList<entity> entitySet, PVector cornerPosition, PVector dimensions, PVector boxColour){
        eSet = entitySet;
        cPos = cornerPosition;
        dim  = dimensions;
        col  = boxColour;
    }

    void display(){
        /*
        Displays the given units in the specified box
        */
        pushStyle();

        //Box
        rectMode(CORNER);
        fill(col.x, col.y, col.z, 60);
        noStroke();
        rect(cPos.x, cPos.y, dim.x, dim.y);

        //Units, Working then free
        ArrayList<entity> eWorking = giveWorkingSet();
        ArrayList<entity> eFree    = giveFreeSet();
        float unitSize = calcUnitSize(eWorking, eFree);
        fill(66, 245, 224, 180);
        for(int i=0; i<eWorking.size(); i++){
            ellipse(cPos.x +unitSize/2.0 +i*unitSize, cPos.y +dim.y/2.0, unitSize, unitSize);
        }
        fill(245, 66, 117, 180);
        for(int i=0; i<eFree.size(); i++){
            ellipse(cPos.x +dim.x -unitSize/2.0 -i*unitSize, cPos.y +dim.y/2.0, unitSize, unitSize);
        }

        popStyle();
    }


    void update(){
        if(frameCount % 10 == 0){
            hInd = calcHoveredUnit();
        }
    }


    ArrayList<entity> giveWorkingSet(){
        /*
        Returns all entities in eSet that have jobs
        */
        ArrayList<entity> eWorking = new ArrayList<entity>();
        for(int i=0; i<eSet.size(); i++){
            if(eSet.get(i).jobs.size() > 0){
                eWorking.add(eSet.get(i));
            }
        }
        return eWorking;
    }
    ArrayList<entity> giveFreeSet(){
        /*
        Returns all entities in eSet that have no jobs
        */
        ArrayList<entity> eFree = new ArrayList<entity>();
        for(int i=0; i<eSet.size(); i++){
            if(eSet.get(i).jobs.size() == 0){
                eFree.add(eSet.get(i));
            }
        }
        return eFree;
    }
    ArrayList<ArrayList<Integer>> giveIndexingSet(){
        /*
        Returns the set of indices for the INDEX in ESET of the given unit in working (0th comp) or free (1st comp)
        e.g
        = [ [1,4,5], [0,2,3,6] ]
        0th = eWorking
            (0,0) = means 0th unit in eWorking is the 1st in the eSet (in this case)
        1st = eFree
            (1,0) = means 0th unit in eFree is the 0th in the eSet (in this case)
        ... Can be expanded for further divisons
        */
        ArrayList<ArrayList<Integer>> eIndexing = new ArrayList<ArrayList<Integer>>();
        eIndexing.add( new ArrayList<Integer>() );
        eIndexing.add( new ArrayList<Integer>() );
        for(int i=0; i<eSet.size(); i++){
            if(eSet.get(i).jobs.size() > 0){
                eIndexing.get(0).add(i);
            }
            if(eSet.get(i).jobs.size() == 0){
                eIndexing.get(1).add(i);
            }
        }
        return eIndexing;
    }


    boolean zoneClicked(){
        /*
        Returns whether or not the mouse is within this zone's area
        Called when checking for click collision
        */
        boolean withinX = (cPos.x < mouseX) && (mouseX < cPos.x +dim.x);
        boolean withinY = (cPos.y < mouseY) && (mouseY < cPos.y +dim.y);
        if(withinX && withinY){
            return true;
        }
        else{
            return false;
        }
    }
    float calcUnitSize(ArrayList<entity> eWorking, ArrayList<entity> eFree){
        /*
        Finds the size needed for the units to fit in the box approporiately
        */
        float unitSize = 0.0;
        float stdUnitSize = 0.8*dim.y;                                  //Normal size
        unitSize          = stdUnitSize;
        if(1.1*unitSize*1.2*(eWorking.size() +eFree.size()) > dim.x){   //Scaled back size
            unitSize = dim.x /(1.1*(eWorking.size() +eFree.size()));}
        return unitSize;
    }
    int calcHoveredUnit(){
        /*
        Returns the index of the unit being hovered in this set when the function is called
        Returns -1 if none are hovered
        */
        int iHovered = -1;
        boolean withinGeneralX = (cPos.x < mouseX) && (mouseX < cPos.x +dim.x); //Preliminary test to skip wasted calculation most of the time
        boolean withinGeneralY = (cPos.y < mouseY) && (mouseY < cPos.y +dim.y); //
        if(withinGeneralX && withinGeneralY){
            boolean hFound = false;
            ArrayList<entity> eWorking = giveWorkingSet();
            ArrayList<entity> eFree    = giveFreeSet();
            ArrayList<ArrayList<Integer>> eIndexing = giveIndexingSet();
            float unitSize = calcUnitSize(eWorking, eFree);
            for(int i=0; i<eWorking.size(); i++){
                boolean withinX = (cPos.x +unitSize/2.0 +i*unitSize -unitSize/2.0 < mouseX) && (mouseX < cPos.x +unitSize/2.0 +i*unitSize +unitSize/2.0);
                boolean withinY = (cPos.y +dim.y/2.0 -unitSize/2.0                < mouseY) && (mouseY < cPos.y +dim.y/2.0 +unitSize/2.0);
                if(withinX && withinY){
                    iHovered = eIndexing.get(0).get(i);
                    hFound = true;
                    break;
                }
            }
            if(!hFound){
                for(int i=0; i<eFree.size(); i++){
                    boolean withinX = (cPos.x +dim.x -unitSize/2.0 -i*unitSize -unitSize/2.0 < mouseX) && (mouseX < cPos.x +dim.x -unitSize/2.0 -i*unitSize +unitSize/2.0);
                    boolean withinY = (cPos.y +dim.y/2.0 -unitSize/2.0                       < mouseY) && (mouseY < cPos.y +dim.y/2.0 +unitSize/2.0);
                    if(withinX && withinY){
                        iHovered = eIndexing.get(1).get(i);
                        break;
                    }
                }
            }
        }
        return iHovered;
    }
}