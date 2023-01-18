class blueprint{
    ArrayList<PVector> posSet = new ArrayList<PVector>();   //Position (in coords) of the items to be placed
    ArrayList<item> itemSet   = new ArrayList<item>();      //The items specifically that are being placed

    boolean isBigProject = false;

    blueprint(){
        //pass
    }

    void display(PVector startPos, float tileWidth){
        /*
        Displays a 'ghost overlay' for the the items in this blueprint over the 
        map based on the details parsed in
        */
        pushStyle();
        rectMode(CENTER);
        for(int i=0; i<posSet.size(); i++){
            if(itemSet.get(i).sType == 0){
                fill(66, 245, 105, 150);}
            else if(itemSet.get(i).sType == 1){
                fill(230, 245, 66, 150);}
            else if(itemSet.get(i).sType == 2){
                fill(169, 64, 230, 150);}
            else{
                fill(183, 228, 237, 150);}
            //##
            //## MAKE DO MORE SPECIFIC DRAWING FOR SPECIFIC ITEMS
            //##
            rect(startPos.x +posSet.get(i).x*tileWidth, startPos.y +posSet.get(i).y*tileWidth, 0.8*tileWidth, 0.8*tileWidth);
        }
        popStyle();
    }
}