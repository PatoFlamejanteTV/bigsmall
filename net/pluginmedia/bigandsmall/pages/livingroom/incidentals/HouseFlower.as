package net.pluginmedia.bigandsmall.pages.livingroom.incidentals
{
   import flash.display.MovieClip;
   import net.pluginmedia.bigandsmall.core.Incidental;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class HouseFlower extends Incidental
   {
      
      private var flowerSprite:PointSprite;
      
      private var smallFlower:AnimationOld;
      
      private var flowerMaterial:SpriteParticleMaterial;
      
      private var bigFlower:AnimationOld;
      
      private var currentFlower:AnimationOld;
      
      public function HouseFlower(param1:String)
      {
         super(param1);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
      }
      
      override public function set scale(param1:Number) : void
      {
         flowerSprite.size = param1;
      }
      
      override public function setCharacter(param1:String) : void
      {
         switch(param1)
         {
            case CharacterDefinitions.BIG:
               flowerMaterial.movie = currentFlower = bigFlower;
               break;
            case CharacterDefinitions.SMALL:
               flowerMaterial.movie = currentFlower = smallFlower;
         }
      }
      
      override public function get scale() : Number
      {
         return flowerSprite.size;
      }
      
      override public function stop() : void
      {
      }
      
      private function handleAnimComplete(param1:AnimationOldEvent) : void
      {
         playing = false;
         AnimationOld(param1.target).gotoAndStop(1);
      }
      
      override public function play() : void
      {
         if(!playing && active)
         {
            playing = true;
            currentFlower.playOutLabel("growth");
         }
      }
      
      public function setContent(param1:MovieClip, param2:MovieClip) : void
      {
         bigFlower = new AnimationOld(param1);
         bigFlower.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         bigFlower.stop();
         smallFlower = new AnimationOld(param2);
         smallFlower.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         smallFlower.stop();
         currentFlower = bigFlower;
         flowerMaterial = new SpriteParticleMaterial(currentFlower);
         flowerSprite = new PointSprite(flowerMaterial);
         playing = false;
         addChild(flowerSprite);
      }
      
      override public function rollover() : void
      {
         if(!currentFlower.isPlaying && active)
         {
            currentFlower.playToNextLabel();
         }
      }
      
      override public function park() : void
      {
         super.park();
         flowerMaterial.removeSprite();
      }
   }
}

