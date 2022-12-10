class enemy extends entity{
    //pass

    enemy(PVector iPos, int mPos){
        super(iPos, mPos);
    }

    void display(PVector pos, float dim){
        //pass
    }


    @Override
    void doIdleAction(){
        /*
        When an enemy is idle it will;
        . Wander around the map it is currently in
        */
        wanderCurrentMap(cEnviro.cLair.maps);
    }
    @Override
    Integer findEntityInd(ArrayList<map> maps){
        /*
        Finds what number this entity is in the list on entities on its tile
        */
        int eInd = -1;
        for(int i=0; i<maps.get(mPos).tiles.get( int(iPos.y) ).get( int(iPos.x) ).enemies.size(); i++){
            if(ID == maps.get(mPos).tiles.get( int(iPos.y) ).get( int(iPos.x) ).enemies.get(i).ID){
                eInd = i;
                break;
            }
        }
        return eInd;
    }
    @Override
    void travelHyperPath(ArrayList<map> maps){
        /*
        Moves the entity through its hyper path
        1. Add to new tile
        2. Remove from old tile
        3. Change to new values
        */
        if(path.size() > 0){
            int eInd = findEntityInd(maps);
            maps.get( int(path.get(0).z) ).tiles.get( int(path.get(0).y) ).get( int(path.get(0).x) ).enemies.add(this);     //1
            maps.get( mPos               ).tiles.get( int(iPos.y)        ).get( int(iPos.x)        ).enemies.remove(eInd);  //2
            iPos = new PVector(path.get(0).x, path.get(0).y);                                                               //3
            mPos = int(path.get(0).z);                                                                                      //
            path.remove(0);
        }
    }
}


class orc extends enemy{
    //pass

    orc(PVector iPos, int mPos){
        super(iPos, mPos);
        health = floor(random(10,15));
        motionSpd = 2;
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.6;
        fill(255,100,100);
        if(health <= 0){
            fill(100,100,100);}

        ellipse(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
}