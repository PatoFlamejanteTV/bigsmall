package net.pluginmedia.brain.managers
{
   import flash.display.Stage;
   import flash.utils.getTimer;
   import net.pluginmedia.brain.core.Manager;
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   
   public class UpdateManager extends Manager
   {
      
      private var prevTime:uint = 0;
      
      private var frameCount:uint = 0;
      
      public function UpdateManager()
      {
         super();
      }
      
      public function update(param1:Stage) : void
      {
         var _loc5_:IUpdatable = null;
         if(_paused)
         {
            return;
         }
         ++frameCount;
         var _loc2_:uint = uint(getTimer());
         var _loc3_:uint = uint(_loc2_ - prevTime);
         prevTime = _loc2_;
         var _loc4_:UpdateInfo = new UpdateInfo(_loc3_,_loc2_,frameCount,param1,param1.mouseX,param1.mouseY);
         for each(_loc5_ in registeredObjs)
         {
            if(_loc5_.active)
            {
               _loc5_.update(_loc4_);
            }
         }
      }
      
      public function moveToLastUpdatable(param1:IUpdatable) : void
      {
         var _loc2_:int = int(registeredObjs.indexOf(param1));
         if(_loc2_ != -1)
         {
            registeredObjs.splice(_loc2_,1);
         }
         registeredObjs.push(param1);
      }
   }
}

