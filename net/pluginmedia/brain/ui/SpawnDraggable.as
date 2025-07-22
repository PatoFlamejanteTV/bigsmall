package net.pluginmedia.brain.ui
{
   import net.pluginmedia.brain.core.interfaces.ISpawnDraggable;
   
   public class SpawnDraggable extends Draggable implements ISpawnDraggable
   {
      
      private var _parentSpawner:DraggableSpawner;
      
      public function SpawnDraggable(param1:DraggableSpawner, param2:Class, param3:Number = 0, param4:Number = 0, param5:String = "")
      {
         _parentSpawner = param1;
         super(param2,param3,param4,param5);
      }
      
      public function get parentSpawner() : DraggableSpawner
      {
         return _parentSpawner;
      }
   }
}

