package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import gs.TweenMax;
   import gs.easing.Elastic;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   
   public class SeedSpawner extends DraggableSpawner
   {
      
      public var plantType:String;
      
      public function SeedSpawner(param1:Class, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "", param6:GlowFilter = null)
      {
         super(param1,param2,param3,param4,param5);
         userDataInst.scaleX = userDataInst.scaleY = 1.15;
         if(param6)
         {
            overStateFilters = [param6];
         }
      }
      
      override public function spawnDraggable(param1:Number, param2:Number) : SpawnDraggable
      {
         var _loc3_:SpawnDraggableSeed = new SpawnDraggableSeed(this,spawnDataClass,param1,param2,this.value);
         _loc3_.plantType = this.plantType;
         return _loc3_;
      }
      
      override public function get canSpawn() : Boolean
      {
         return true;
      }
      
      override public function onSpawn() : void
      {
         super.onSpawn();
         dispatchEvent(new Event("didSpawn"));
         TweenMax.from(this,1,{
            "overwrite":true,
            "scaleX":0,
            "scaleY":0,
            "ease":Elastic.easeOut,
            "delay":0.25
         });
      }
      
      override public function setOverState(param1:Boolean) : void
      {
         if(!userDataInst["seedVis"])
         {
            return;
         }
         if(param1)
         {
            userDataInst["seedVis"].filters = overStateFilters;
         }
         else
         {
            userDataInst["seedVis"].filters = [];
         }
      }
   }
}

