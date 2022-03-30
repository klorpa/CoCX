package classes {

import classes.GlobalFlags.kFLAGS;
import classes.Appearance;

public class SceneHunter extends BaseContent {
    public function settingsPage():void {
        clearOutput();
        menu();
		displayHeader("SceneHunter Settings - WIP");
        outputText("The following are QoL improvements meant to make some scenes (and their variations) easier to access.");
        outputText("\nAll these features blend into the game (almost) seamlessly, are lore-accurate and don't change anything gameplay-related.");
        
        addButton(0, "UniHerms", toggle, kFLAGS.SCENEHUNTER_UNI_HERMS);
        outputText("\n\n<b>Universal Herms</b>: ");
        if (flags[kFLAGS.SCENEHUNTER_UNI_HERMS]) {
            outputText("<b><font color=\"#008000\">ENABLED</font></b>");
            outputText("\nMakes scenes unique to male/female PCs accessible to herms. Allows the player to choose the scene when the sex is led by the PC, randomly selects it in rape scenes.");
            outputText("\n<i>New scenes lack the description of herm's other genitalia. Some scenes may look slightly off (rare).</i>");
        }
        else {
            outputText("<b><font color=\"#800000\">DISABLED</font></b>");
            outputText("\nHerms don't get any new scenes.");
        }

        addButton(1, "DickSelect", toggle, kFLAGS.SCENEHUNTER_DICK_SELECT);
        outputText("\n\n<b>Dick Select</b>: ");
        if (flags[kFLAGS.SCENEHUNTER_DICK_SELECT]) {
            outputText("<b><font color=\"#008000\">ENABLED</font></b>");
            outputText("\nWhen the scene presents different options for small/big/TOO big dick sizes, adds selectors for the player to choose the exact 'tool' if different options are available. The dick is selected randomly in rape scenes.");
            outputText("\n<i>Well, you can change which dick will be used now. Yay. Though some rare scenes (especially small dick femdom) may look slightly weird if you have a bigger cock.</i>");
        }
        else {
            outputText("<b><font color=\"#800000\">DISABLED</font></b>");
            outputText("\nThe biggest <b>fitting</b> dick is always used.");
        }

        addButton(2, "MutExScenes", toggle, kFLAGS.SCENEHUNTER_MUTEX_SCENES);
        outputText("\n\n<b>Mutually exclusive scenes</b>: ");
        if (flags[kFLAGS.SCENEHUNTER_MUTEX_SCENES]) {
            outputText("<b><font color=\"#008000\">ENABLED</font></b>");
            outputText("\nSome originally mutually exclusive scenes (when you've selected one scene, you'll never access the other one in this playthrough) are no longer mutually exclusive.");
            outputText("\n<i>This opens up more scenes, but <b>some</b> of them may look off. They are still explained in the game, but be warned that the original writers intended otherwise.</i>");
        }
        else {
            outputText("<b><font color=\"#800000\">DISABLED</font></b>");
            outputText("\n...stay mutually exclusive, as intended by the writers...");
            outputText("\n<i>Some one-time scenes with different options can still be replayed using 'Camp Actions -> Spend Time -> Recall'.</i>");
        }
        outputText("\nNPCs with MutEx scenes: Lottie, Whitney...");
        //Scene list link
        addButton(3, "PrintChecks", toggle, kFLAGS.SCENEHUNTER_PRINT_CHECKS);
        outputText("\n\n<b>Print Checks:</b>: ");
        if (flags[kFLAGS.SCENEHUNTER_PRINT_CHECKS]) {
            outputText("<b><font color=\"#008000\">ENABLED</font></b>");
            outputText("\nSome failed race, dick size and other attribute checks are explicitly printed in the middle of the scene.");
            outputText("\n<i>Can be a little immersion-breaking, but helps you understand when you're missing some secret requirements.</i>");
        }
        else {
            outputText("<b><font color=\"#800000\">DISABLED</font></b>");
            outputText("\nNo extra information is printed, you'll have to find new race-specific scenes yourself");
        }

        addButton(5, "Scene List", openURL, "https://cocxianxia.fandom.com/wiki/Conditional_Scenes");
        outputText("\n\n<b>Conditional Scenes list:</b> <u><a href='https://cocxianxia.fandom.com/wiki/Conditional_Scenes'>https://cocxianxia.fandom.com/wiki/Conditional_Scenes</a></u>");
        outputText("\n<i>This list contains minor spoilers for the entirety of the game. You've been warned.</i>");

        addButton(6, "Reference", openURL, "https://cocxianxia.fandom.com/wiki/Scene_Reference");
        outputText("\n\n<b>Scene Reference:</b> <u><a href='https://cocxianxia.fandom.com/wiki/Scene_Reference'>https://cocxianxia.fandom.com/wiki/Scene_Reference</a></u>");
        outputText("\n<i>This list contains <b>major</b> spoilers for the entirety of the game. You've been warned.</i>");

        addButton(9, "Back", CoC.instance.gameSettings.settingsScreenMain);
    }

	public function toggle(flag:int):void {
		flags[flag] = !flags[flag];
		settingsPage();
	}

    //restore the previous text and start the next function
    public function restoreText(textToRestore:String = "", fun:Function = null):void {
        CoC.instance.currentText = textToRestore;
        if (fun != null)
            fun();
    }
    
    //--------------------------------------------------------------------------------------------------
    // UniHerms
    //--------------------------------------------------------------------------------------------------

    public function get uniHerms():Boolean {
        return flags[kFLAGS.SCENEHUNTER_UNI_HERMS];
    }

    /**
    * Prints the dialogue to select the part to use in the scene. Automatically checks if the part exists.
    * If only one option is available, goes with it.
    * @param    dickPriority    Used if uniHerms are disabled. If true, selects dick option (if possible). False - vag or ass.
                                Vag is always "better" than ass.
    * @param    dickF           Functions to call for dick, vag, ass buttons. Buttons are not displayed when "null"
    * @param    vagF
    * @param    assF
    * @param    dickActive      If false, "dick" button will be disabled.
    * @param    dickDisabledMsg The message to write on the disabled dick button
    */
    public function selectGender(dickF:Function, vagF:Function, assF:Function = null, dickActive:Boolean = true, dickDisabledMsg:String = "", dickPriority:Boolean = true):void {
        //Auto-calls. No auto call when dick is just inactive - player should know!
        if (!(dickF != null && player.hasCock() && dickActive) && !(vagF != null && player.hasVagina()) && assF == null) { //sanity checks
            if (dickF && player.hasCock() && !dickActive)
                outputText("<b><u>SceneHunter.selectGender() was called, but the ONLY option - dick - is disabled. Please report this.</b></u>");
            else
                outputText("<b><u>SceneHunter.selectGender() was called in a wrong way. Please report this.</b></u>");
            goNext(true);
            return;
        }
        /* if ONLY dick is available  - no "active" checks in the first part, should be failsafe
        or if !uniHerms:
            - dick active and higher priority than vag (always higher than ass!!)
            - dick active and no vag */
        if ((dickF != null && player.hasCock()) && (!(vagF != null && player.hasVagina()) && assF == null || !uniHerms && dickActive && (dickPriority || !player.hasVagina()))) {
            dickF();
            return;
        }
        // for !uniHerms: if dick should be called, it was ALREADY called. So call vag anyway, vag > ass
        if ((vagF != null && player.hasVagina()) && (!(dickF != null && player.hasCock()) && assF == null || !uniHerms)) {
            vagF();
            return;
        }
        // with !uniHerms reached only when dick/vag are impossible, call it
        if (!(dickF != null && player.hasCock()) && !(vagF != null && player.hasVagina()) && assF != null || !uniHerms) {
            assF();
            return;
        }
        //Dialogue
        var beforeText:String = CoC.instance.currentText;
        outputText("\n\n<b>Which part of your body do you want to use?</b>");
        menu();
        if (dickF != null) {
            if (player.hasCock()) {
                if (dickActive)
                    addButton(0, "Dick", restoreText, beforeText, dickF);
                else
                    addButtonDisabled(0, "Dick", dickDisabledMsg);
            }
            else
                addButtonDisabled(0, "Dick", "You don't have any.");
        }
        if (vagF != null) {
            if (player.hasVagina())
                    addButton(1, "Vagina", restoreText, beforeText, vagF);
            else
                addButtonDisabled(1, "Vagina", "You don't have any.");
        }
        if (assF != null)
            addButton(2, "Ass", restoreText, beforeText, assF);
    }

    //--------------------------------------------------------------------------------------------------
    // DickSelect
    //--------------------------------------------------------------------------------------------------

    public function get dickSelect():Boolean { 
        return flags[kFLAGS.SCENEHUNTER_DICK_SELECT];
    }

    /**
    * The dialogue to select fitting or not fitting dick. If dickSelect is disabled, tries to call "fitting" function
    * If doesn't fit, selects the biggest one because HELL WHY NOT.
    * When disabled, overrides "tentacle always fit" behavior.
    * @param    fitF        Function to call when fits
    * @param    nofitF      Function to call when doesn't
    * @param    maxSize     Maximum fitting size
    * @param    compareBy   (Optional) Measurement to compare
    */
    public function selectFitNofit(fitF:Function, nofitF:Function, maxSize:Number, compareBy:String = "area"):void {
        //Auto-calls
        if (!dickSelect) {
            if (player.findCock(1, -1, maxSize, compareBy, false) >= 0)
                fitF();
            else
                nofitF();
            return;
        }
        //Dialogue
        var beforeText:String = CoC.instance.currentText;
        outputText("\n\n<b>Will you use the dick that will certainly fit, or press your luck and try to use a bigger 'tool'?</b>");
        menu();
        //fitting cocks
        if (player.findCock(1, -1, maxSize, compareBy, true) >= 0)
            addButton(0, "Fitting", restoreText, beforeText, fitF);
        else
            addButtonDisabled(0, "Fitting", "Requires dick " + compareBy + " less than " + maxSize);
        //too big
        if (player.findCock(1, maxSize, -1, compareBy, true) >= 0)
            addButton(1, "Too big", restoreText, beforeText, nofitF);
        else
            addButtonDisabled(1, "Too big", "Requires dick " + compareBy + " greater than " + maxSize);
    }
    /**
    * The dialogue to select one of 3 dick sizes. There's no points in the game when more are used.
    * When disabled, selects the biggest one.
    * Always overrides "tentacles always fit" behavior for 'smaller' options - your 3-foot-long tentacle is not SMALL in any way :)
    * Assumes that you have any fitting dick - no max size for "Big"
    * @param    bigF, mediumF, smallF   Function for "Big", "Medium", "Small" buttons respectively. 
    * @param    bigMin, smallMax       Borderline sizes for "Big"-"Medium" and "Medium"-"Small"
    * @param    compareBy               (Optional) Measurement to compare
    */
    public function selectBigSmall(bigF:Function, bigMin:Number, mediumF:Function, smallMax:Number = -1, smallF:Function = null, compareBy:String = "area"):void {
        var smallProvided:Boolean = smallMax >= 0 && smallF != null;
        //Auto-calls
        if (!dickSelect) {
            if (player.findCock(1, bigMin, -1, compareBy) >= 0)
                bigF();
            else if (player.findCock(1, smallProvided ? smallMax : -1, bigMin, compareBy, false) >= 0) //called even if mediumMin is not provived (-1 = no minimum)
                mediumF();
            else
                smallF(); //if smallMax is provided, smallF MUST be provided too
            return;
        }
        //Dialogue
        var beforeText:String = CoC.instance.currentText;
        outputText("\n\n<b>Will you use a big" + (smallProvided ? ", medium": "") + " or small sized dick?</b>");
        menu();
        //big cocks
        if (player.findCock(1, bigMin, -1, compareBy) >= 0)
            addButton(0, "Big", restoreText, beforeText, bigF);
        else
            addButtonDisabled(0, "Fitting", "Requires dick " + compareBy + " greater than " + bigMin);
        //medium-small
        if (smallProvided) {
            //medium cocks
            if (player.findCock(1, smallMax, bigMin, compareBy, false) >= 0) //tentacles don't fit
                addButton(1, "Medium", restoreText, beforeText, mediumF);
            else
                addButtonDisabled(1, "Medium", "Requires dick " + compareBy + " greater than " + smallMax + " and less than " + bigMin);
            //small cocks
            if (player.findCock(1, -1, smallMax, compareBy, false) >= 0) //tentacles don't fit
                addButton(2, "Small", restoreText, beforeText, smallF);
            else
                addButtonDisabled(2, "Small", "Requires dick " + compareBy + " less than " + smallMax);
        }
        else {
            //replaced "Medium" text with "Small" to avoid player confusion
            if (player.findCock(1, -1, bigMin, compareBy, false) >= 0) //tentacles don't fit
                addButton(1, "Small", restoreText, beforeText, mediumF);
            else
                addButtonDisabled(1, "Small", "Requires dick " + compareBy + " less than " + bigMin);
        }
    }
    
    //--------------------------------------------------------------------------------------------------
    // MutExScenes
    //--------------------------------------------------------------------------------------------------

    public function get mutExScenes():Boolean {
        return flags[kFLAGS.SCENEHUNTER_MUTEX_SCENES];
    }
    //nothing more here for now... Will it just check the value, or new next will be here too?
    
    //--------------------------------------------------------------------------------------------------
    // PrintChecks
    //--------------------------------------------------------------------------------------------------

    public function get printChecks():Boolean {
        return flags[kFLAGS.SCENEHUNTER_PRINT_CHECKS];
    }

    public function print(text:String):void {
        if (printChecks)
            outputText("\n\n<b>" + text + "</b>\n\n");
    }

    //Some common checks for easier access
    
    //Prints dick requirements if not found
    public function check_dick_typed(type:CockTypesEnum, minSize:Number = -1, maxSize:Number = -1, compareBy:String = "area", moreText:String = ""):void {
        if (printChecks && player.findCockWithType(type, 1, minSize, maxSize, compareBy) < 0) {
            outputText("\n\n<b>FAILED DICK CHECK:")
            if (type != CockTypesEnum.UNDEFINED)
                outputText("\n    Type: " + Appearance.cockNoun(type));
            if (minSize != -1)
                outputText("\n    Min " + compareBy + ": " + minSize);
            if (maxSize != -1)
                outputText("\n    Max " + compareBy + ": " + maxSize);
            if (moreText)
                outputText("\n" + moreText);
            outputText("</b>\n\n")
        }
    }
    public function check_dick(minSize:Number = -1, maxSize:Number = -1, compareBy:String = "area", moreText:String = ""):void {
        check_dick_typed(CockTypesEnum.UNDEFINED, minSize, maxSize, compareBy, moreText);
    }
    
    //Prints dick requirements if not found
    public function check_race(race:String):void {
        if (printChecks && player.race() != race) {
            outputText("\n\n<b>FAILED RACE CHECK:")
            outputText("\n    Expected: " + race);
            outputText("</b>\n\n")
        }
    }
}
}