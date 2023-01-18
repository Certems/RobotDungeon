class ally extends entity{
    //pass

    ally(PVector iPos, int mPos){
        super(iPos, mPos);
    }

    @Override
    void display(PVector pos, float dim){
        //pass
    }
    
    
    @Override
    void doIdleAction(){
        /*
        When an ally is idle it will;
        . Try path back to map marked as 'reserve' map
        . Wander around reserve map
        */
        boolean inReserve = (mPos == cEnviro.cLair.mReserve);
        boolean isPathing = (path.size() > 0);
        if(!inReserve && !isPathing){       //If not in reserve AND not walking to it, start walking to it
            path.clear();
            PVector targetPos = new PVector( floor(cEnviro.cLair.maps.get(cEnviro.cLair.mReserve).tiles.get(0).size()/2.0), floor(cEnviro.cLair.maps.get(cEnviro.cLair.mReserve).tiles.size()/2.0), cEnviro.cLair.mReserve );
            path = calcHyperPathing(cEnviro.cLair.maps, new PVector(iPos.x, iPos.y, mPos), targetPos, 1);
        }
        else if(!inReserve && isPathing){   //If not in reserve BUT walking there, continue walking to it
            travelHyperPath(cEnviro.cLair.maps);
        }
        else{                               //If is in reserve, wander around it
            wanderCurrentMap(cEnviro.cLair.maps);
        }
    }
    @Override
    Integer findEntityInd(ArrayList<map> maps){
        /*
        Finds what number this entity is in the list on entities on its tile
        */
        int eInd = -1;
        for(int i=0; i<maps.get(mPos).tiles.get( int(iPos.y) ).get( int(iPos.x) ).allies.size(); i++){
            if(ID == maps.get(mPos).tiles.get( int(iPos.y) ).get( int(iPos.x) ).allies.get(i).ID){
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
            maps.get( int(path.get(0).z) ).tiles.get( int(path.get(0).y) ).get( int(path.get(0).x) ).allies.add(this);      //1
            maps.get( mPos               ).tiles.get( int(iPos.y)        ).get( int(iPos.x)        ).allies.remove(eInd);   //2
            iPos = new PVector(path.get(0).x, path.get(0).y);                                                               //3
            mPos = int(path.get(0).z);                                                                                      //
            path.remove(0);
        }
    }
}


class droid extends ally{
    //pass

    droid(PVector iPos, int mPos){
        super(iPos, mPos);
        health = floor(random(10,15));
        motionSpd = 2;
    }

    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.6;
        fill(100,100,255);

        ellipse(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
}