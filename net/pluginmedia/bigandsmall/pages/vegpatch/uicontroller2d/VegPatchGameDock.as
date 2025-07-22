package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller2d
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gs.TweenMax;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.brain.buttons.AssetButton;
   import net.pluginmedia.brain.ui.DraggableSpawner;
   
   public class VegPatchGameDock extends Sprite
   {
      
      private var container:Sprite;
      
      private var currentTray:VegPatchSeedTray;
      
      private var _dockClip:MovieClip;
      
      private var bigTray:VegPatchSeedTray;
      
      private var _smallSeeds:Array;
      
      private var smallTray:VegPatchSeedTray;
      
      private var _bigSeeds:Array;
      
      private var _wateringCanSpawner:DraggableSpawner;
      
      private var _trowelSpawner:DraggableSpawner;
      
      private var currentSeeds:Array;
      
      private var seedClipPos:Point;
      
      private var _seedPacket:AssetButton;
      
      public var banishDepth:Number;
      
      public function VegPatchGameDock(param1:MovieClip, param2:Array, param3:Array, param4:DraggableSpawner, param5:DraggableSpawner)
      {
         super();
         _smallSeeds = param2;
         _bigSeeds = param3;
         container = new Sprite();
         _dockClip = param1;
         container.addChild(_dockClip);
         _wateringCanSpawner = param4;
         _wateringCanSpawner.x = 185;
         _wateringCanSpawner.y = -100;
         container.addChild(_wateringCanSpawner);
         _trowelSpawner = param5;
         _trowelSpawner.x = 260;
         _trowelSpawner.y = -70;
         container.addChild(_trowelSpawner);
         seedClipPos = new Point(-400,-55);
         smallTray = new VegPatchSeedTray();
         smallTray.x = seedClipPos.x;
         smallTray.y = seedClipPos.y;
         smallTray.shuffle(param2);
         bigTray = new VegPatchSeedTray();
         bigTray.x = seedClipPos.x;
         bigTray.y = seedClipPos.y;
         bigTray.shuffle(param3);
         banishDepth = container.height + 10;
         container.y = banishDepth;
         addChild(container);
      }
      
      public function hideWateringCan() : void
      {
         _wateringCanSpawner.visible = false;
      }
      
      private function seedClipDropComplete() : void
      {
      }
      
      private function handleSeedPacketClick(param1:MouseEvent) : void
      {
      }
      
      public function smallSeed(param1:int) : DraggableSpawner
      {
         return _smallSeeds[param1] as DraggableSpawner;
      }
      
      public function bigSeed(param1:int) : DraggableSpawner
      {
         return _bigSeeds[param1] as DraggableSpawner;
      }
      
      public function get wateringCan() : DraggableSpawner
      {
         return _wateringCanSpawner;
      }
      
      public function banish(param1:Number = 0.3) : void
      {
         TweenMax.to(container,param1,{"y":banishDepth});
      }
      
      public function showTrowel() : void
      {
         _trowelSpawner.visible = true;
      }
      
      public function setCharacter(param1:String) : void
      {
         if(param1 == CharacterDefinitions.BIG)
         {
            if(currentSeeds != _bigSeeds)
            {
               currentSeeds = _bigSeeds;
               if(container.contains(smallTray))
               {
                  container.removeChild(smallTray);
               }
               container.addChild(bigTray);
            }
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            if(currentSeeds != _smallSeeds)
            {
               currentSeeds = _smallSeeds;
               if(container.contains(bigTray))
               {
                  container.removeChild(bigTray);
               }
               container.addChild(smallTray);
            }
         }
      }
      
      public function showWateringCan() : void
      {
         _wateringCanSpawner.visible = true;
      }
      
      public function hideTrowel() : void
      {
         _trowelSpawner.visible = false;
      }
      
      public function summon(param1:Number = 0.3) : void
      {
         TweenMax.to(container,param1,{"y":0});
      }
   }
}

