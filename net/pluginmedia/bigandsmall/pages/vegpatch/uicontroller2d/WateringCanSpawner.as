package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   import net.pluginmedia.brain.ui.SpawnDraggable;
   
   public class WateringCanSpawner extends DraggableSpawner
   {
      
      public function WateringCanSpawner(param1:Class, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "", param6:GlowFilter = null)
      {
         super(param1,param2,param3,param4,param5);
         MovieClip(userDataInst).gotoAndStop(1);
         if(param6)
         {
            overStateFilters = [param6];
         }
      }
      
      override public function spawnDraggable(param1:Number, param2:Number) : SpawnDraggable
      {
         var _loc3_:Point = new Point(this.x,this.y);
         var _loc4_:Point = localToGlobal(_loc3_);
         return new SpawnDraggableWateringCan(this,spawnDataClass,_loc4_.x - this.x,_loc4_.y - this.y,this.value);
      }
      
      override public function get canSpawn() : Boolean
      {
         return true;
      }
      
      override public function onSpawn() : void
      {
      }
      
      override public function setOverState(param1:Boolean) : void
      {
         if(param1)
         {
            this.filters = overStateFilters;
         }
         else
         {
            this.filters = [];
         }
      }
   }
}

