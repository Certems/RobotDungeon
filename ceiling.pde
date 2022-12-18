class ceiling{
    animator cAnimator = new animator();

    String type;

    ceiling(){
        type = "none";
    }

    void display(PVector pos, float dim){
        cAnimator.display(pos, new PVector(dim, dim));
    }
}