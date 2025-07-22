package net.pluginmedia.bigandsmall.pages.livingroom.bandgame
{
   import flash.display.MovieClip;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   
   public class InstrumentDraggableSpawner extends DraggableSpawner
   {
      
      private var instrumentMC:MovieClip = null;
      
      public function InstrumentDraggableSpawner(param1:Class, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "")
      {
         super(param1,param2,param3,param4,param5);
         if(userDataInst !== null && Boolean(userDataInst.hasOwnProperty("instrument")))
         {
            instrumentMC = userDataInst["instrument"];
         }
      }
      
      override public function setOverState(param1:Boolean) : void
      {
         if(instrumentMC === null)
         {
            super.setOverState(param1);
         }
         else if(param1)
         {
            instrumentMC.filters = overStateFilters;
         }
         else
         {
            instrumentMC.filters = [];
         }
      }
      
      override public function onSpawn() : void
      {
         super.onSpawn();
         if(instrumentMC !== null)
         {
            instrumentMC.gotoAndPlay(1);
         }
      }
   }
}

