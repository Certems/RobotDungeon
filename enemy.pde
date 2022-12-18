class enemy extends entity{
    String name;

    enemy(PVector iPos, int mPos){
        super(iPos, mPos);
        name = "null";
    }

    @Override
    void doIdleAction(){
        /*
        When an enemy is idle it will;
        . Wander around the map it is currently in
        */
        boolean hasLeft = checkAtExit(cEnviro.cLair.maps);
        if(!hasLeft){
            wanderCurrentMap(cEnviro.cLair.maps);}
        
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
    boolean checkAtExit(ArrayList<map> maps){
        /*
        Checks to see if it is at the xit, and if so leaves
        returns whether it exitted or not
        */
        if(maps.get(mPos).tiles.get(int(iPos.y)).get(int(iPos.x)).cVolume.type == "exit"){
            println("Exitting...");
            //If currently on exit, then leave
            int eInd = findEntityInd(maps);
            maps.get( mPos ).tiles.get( int(iPos.y) ).get( int(iPos.x) ).enemies.remove(eInd);
            cEnviro.cLair.nExitted++;
            cEnviro.cLair.waveCount--;
            cEnviro.cLair.checkGameOver();
            return true;
        }
        else{
            return false;
        }
    }
}


class orc extends enemy{
    //pass

    orc(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_orc_static();
        name = "enemyOrc";
        health = floor(random(10,15));
        motionSpd = 2;
    }

    /*
    @Override
    void display(PVector pos, float dim){
        pushStyle();

        float multi = 0.6;
        fill(106, 138, 110);
        if(health <= 0){
            fill(100,100,100);}

        ellipse(pos.x, pos.y, multi*dim, multi*dim);

        popStyle();
    }
    */
}
class goblin extends enemy{
    //pass

    goblin(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_goblin_static();
        name = "enemyGoblin";
        health = floor(random(5,6));
        motionSpd = 1;
    }

}


class shieldBearer extends enemy{
    //pass

    shieldBearer(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_shieldBearer_static();
        name = "enemyShieldBearer";
        health = floor(random(18,22));
        motionSpd = 3;
    }

}
class berserker extends enemy{
    //pass

    berserker(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_berserker_static();
        name = "enemyBerserker";
        health = floor(random(15,20));
        motionSpd = 2;
    }

}


class brute extends enemy{
    //pass

    brute(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_brute_static();
        name = "enemyBrute";
        health = floor(random(24,28));
        motionSpd = 2;
    }

}
class sprinter extends enemy{
    //pass

    sprinter(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_sprinter_static();
        name = "enemySprinter";
        health = floor(random(10,15));
        motionSpd = 1;
    }

}


class warlord extends enemy{
    //pass

    warlord(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_warlord_static();
        name = "enemyWarlord";
        health = floor(random(40,50));
        motionSpd = 3;
    }

}
class beast extends enemy{
    //pass

    beast(PVector iPos, int mPos){
        super(iPos, mPos);
        cAnimator.init_enemy_beast_static();
        name = "enemyBeast";
        health = floor(random(30,45));
        motionSpd = 2;
    }

}