class storyManager{
    boolean lairIntroTriggered = false;
    boolean wave1Triggered = false;

    storyManager(){
        //pass
    }

    void runChecks(){
        /*
        Listens for events, then when hits occur it triggers dialogues
        */
        if(cEnviro.cLair.nWave==1 && !wave1Triggered){
            runDialogue_firstWaveEvent();
        }
    }
    void runDialogue_newLairIntro(){
        cEnviro.dialogueMenu = true;
        cEnviro.cDialogue.setupScenario0();
        lairIntroTriggered = true;
    }
    void runDialogue_firstWaveEvent(){
        cEnviro.dialogueMenu = true;
        cEnviro.cDialogue.setupScenario1();
        wave1Triggered = true;
    }
    //...

    void resetStoryValues(){
        /*
        Resets story values to original setup
        */
        lairIntroTriggered  = false;
        wave1Triggered      = false;
    }
}