environment cEnviro;

void setup(){
    fullScreen(P2D);

    cEnviro = new environment();
}
void draw(){
    cEnviro.display();
    cEnviro.calc();
}

void keyPressed(){
    cEnviro.keyPressedManager();}
void keyReleased(){
    cEnviro.keyReleasedManager();}
void mousePressed(){
    cEnviro.mousePressedManager();}
void mouseReleased(){
    cEnviro.mouseReleasedManager();}