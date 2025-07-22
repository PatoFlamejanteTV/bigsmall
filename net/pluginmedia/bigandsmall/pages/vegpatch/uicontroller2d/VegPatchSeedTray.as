package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.display.Sprite;
   
   public class VegPatchSeedTray extends Sprite
   {
      
      private var seeds:Array;
      
      public function VegPatchSeedTray()
      {
         super();
         seeds = [];
      }
      
      public function shuffle(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SeedSpawner = null;
         var _loc4_:SeedSpawner = null;
         param1 = param1.slice(0,param1.length);
         _loc2_ = int(seeds.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = seeds[_loc2_] as SeedSpawner;
            if(contains(_loc3_))
            {
               removeChild(_loc3_);
            }
            seeds.pop();
            _loc2_--;
         }
         _loc2_ = int(param1.length);
         while(_loc2_ > 0)
         {
            _loc4_ = param1.splice(int(Math.random() * param1.length),1)[0] as SeedSpawner;
            seeds.push(_loc4_);
            _loc4_.x = _loc2_ * 75 + 14;
            _loc4_.y = (1 - _loc2_ % 2) * 30 - 25;
            addChild(_loc4_);
            _loc2_--;
         }
      }
   }
}

