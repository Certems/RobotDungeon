class tile{
    PVector pos;    //Coords in grid, NOT pixel pos

    ArrayList<entity> enemies = new ArrayList<entity>();
    ArrayList<entity> allies  = new ArrayList<entity>();
    
    floor cFloor = new floor();
    volume cVolume = new volume();
    ceiling cCeiling = new ceiling();

    tile(PVector position){
        pos = position;
    }

    //pass
}