class floor{
    String type;

    floor(){
        type = "none";
    }

    void display(PVector pos, float dim){
        //pass
    }
}


class slab extends floor{
    //pass

    slab(){
        type = "slab";
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        rectMode(CENTER);

        fill(255);
        noStroke();

        rect(pos.x, pos.y, 0.9*dim, 0.9*dim);

        popStyle();
    }
}