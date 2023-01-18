class item{
    String name;
    PImage icon;    //PImage itemIcon   #### ADD IN AS ARGUEMENT FOR CLASS WHEN TEXTURES ARE READY ####
    int sType;      //Refer to 'constructStation' for more info on setChoices
    int price;

    floor cFloor;       //Used to fully specify the tile in which the item will be placed
    volume cVolume;     //
    ceiling cCeiling;   //

    item(){
        name  = "null";
        sType = -1;
        price = -1;
        //icon = ;
    }

    void display(PVector pos, PVector dim){
        pushStyle();

        rectMode(CENTER);
        imageMode(CENTER);

        fill(0);
        stroke(255);
        strokeWeight(2);
        rect(pos.x, pos.y, dim.x, dim.y);

        fill(255,50,50);
        noStroke();
        //image(icon, pos.x, pos.y, dim.x, dim.y);
        rect(pos.x, pos.y, dim.x*0.8, dim.y*0.8);

        popStyle();
    }
}


class itemWall extends item{
    //pass

    itemWall(){
        name  = "Wall";
        sType = 0;
        price = 20;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = new wall();
        ceiling cCeiling = null;
    }

    //pass
}
class itemBarricade extends item{
    //pass

    itemBarricade(){
        name  = "Barricade";
        sType = 0;
        price = 15;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = null;
        ceiling cCeiling = null;
    }

    //pass
}


class itemSpikeTrap extends item{
    //pass

    itemSpikeTrap(){
        name  = "SpikeTrap";
        sType = 1;
        price = 10;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = new spikeTrap();
        ceiling cCeiling = null;
    }

    //pass
}
class itemArrowTrap extends item{
    //pass

    itemArrowTrap(){
        name  = "ArrowTrap";
        sType = 1;
        price = 15;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = null;
        ceiling cCeiling = null;
    }

    //pass
}
class itemFireTrap extends item{
    //pass

    itemFireTrap(){
        name  = "FireTrap";
        sType = 1;
        price = 15;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = new fireTrap();
        ceiling cCeiling = null;
    }

    //pass
}


class itemLever extends item{
    //pass

    itemLever(){
        name  = "Lever";
        sType = 2;
        price = 5;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = null;
        ceiling cCeiling = null;
    }

    //pass
}
class itemSensor extends item{
    //pass

    itemSensor(){
        name  = "Sensor";
        sType = 2;
        price = 7;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = null;
        ceiling cCeiling = null;
    }

    //pass
}


class itemWire extends item{
    //pass

    itemWire(){
        name  = "Wire";
        sType = 3;
        price = 1;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = null;
        ceiling cCeiling = null;
    }

    //pass
}
class itemPipe extends item{
    //pass

    itemPipe(){
        name  = "Pipe";
        sType = 1;
        price = 2;
        //icon = ;

        floor cFloor     = null;
        volume cVolume   = null;
        ceiling cCeiling = null;
    }

    //pass
}