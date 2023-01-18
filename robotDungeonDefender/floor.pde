class floor{
    animator cAnimator = new animator();

    String type;

    floor(){
        type = "none";
    }

    void display(PVector pos, float dim){
        cAnimator.display(pos, new PVector(dim,dim));
    }
}


class slab extends floor{
    //pass

    slab(){
        type = "slab";
        cAnimator.init_tile_floor_slab();
    }

}