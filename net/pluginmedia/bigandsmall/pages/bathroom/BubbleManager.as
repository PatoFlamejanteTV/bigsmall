package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.bathroom.managers.BubbleEvent;
   import org.papervision3d.core.geom.Particles;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.special.ParticleBitmap;
   
   public class BubbleManager extends Particles
   {
      
      public var bubbles:Array;
      
      public var bitmapArrays:Array;
      
      public var frameDeployFreq:int = 0;
      
      public var spareParticles:Dictionary;
      
      public var counter:int = 0;
      
      public function BubbleManager(... rest)
      {
         super("Bubbles");
         bubbles = particles;
         initBitmaps(rest);
         spareParticles = new Dictionary();
      }
      
      public function addBubble(param1:Array = null, param2:Number = 0, param3:Number = 0, param4:Number = 0) : Bubble
      {
         var _loc5_:Bubble = null;
         if(!param1)
         {
            param1 = getRandomBitmapArray();
         }
         if(Boolean(spareParticles[param1]) && spareParticles[param1].length > 0)
         {
            _loc5_ = spareParticles[param1].shift();
            _loc5_.reset(param2,param3,param4);
         }
         else
         {
            _loc5_ = new Bubble(param1);
            _loc5_.x = param2;
            _loc5_.y = param3;
            _loc5_.z = param4;
            _loc5_.maxZ = 50;
            _loc5_.maxX = 50;
            _loc5_.minX = -250;
            _loc5_.maxY = 300;
         }
         _loc5_.respawnCount = 0;
         _loc5_.velocity.y = 2 + Math.random() * 3;
         addParticle(_loc5_);
         dispatchEvent(new BubbleEvent(BubbleEvent.BIRTH,_loc5_));
         return _loc5_;
      }
      
      public function update(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc5_:Bubble = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number3D = null;
         var _loc9_:Bubble = null;
         var _loc4_:int = 0;
         while(_loc4_ < bubbles.length)
         {
            _loc5_ = bubbles[_loc4_];
            _loc5_.update(param1,param2);
            if(param1 > _loc5_.renderRect.left && param1 < _loc5_.renderRect.right)
            {
               if(param2 > _loc5_.renderRect.top && param2 < _loc5_.renderRect.bottom)
               {
                  if(param3 && _loc5_.lifeCounter > 10 && !_loc5_.playing && _loc5_.respawnCount < 5)
                  {
                     _loc6_ = 0.4 + Math.random() * 0.2;
                     _loc7_ = 1 - _loc6_;
                     _loc8_ = _loc5_.velocity;
                     _loc8_.rotateZ(Math.random() * 360);
                     _loc8_.x *= 1.3;
                     _loc9_ = addBubble(null,_loc5_.x,_loc5_.y,_loc5_.z);
                     _loc9_.velocity = _loc5_.velocity.clone();
                     _loc9_.velocity.multiplyEq(-(_loc6_ * 1.5));
                     _loc5_.velocity.multiplyEq(_loc7_ * 1.5);
                     _loc5_.lifeExpectancy = _loc9_.lifeExpectancy = 50;
                     _loc5_.lifeCounter = _loc9_.lifeCounter = 0;
                     _loc5_.playing = _loc9_.playing = false;
                     _loc9_.respawnCount = _loc5_.respawnCount = _loc5_.respawnCount + 1;
                     _loc9_.size = _loc5_.size;
                     _loc5_.size *= _loc6_;
                     _loc9_.size *= _loc7_;
                     dispatchEvent(new BubbleEvent(BubbleEvent.CLONEBIRTH,_loc9_));
                  }
                  else if(!param3)
                  {
                     _loc5_.playing = true;
                  }
               }
            }
            if(_loc5_.killParticle)
            {
               dispatchEvent(new BubbleEvent(BubbleEvent.DEATH,_loc5_));
               removeParticle(_loc5_);
               bubbles.splice(_loc4_,1);
               if(!spareParticles[_loc5_.bitmapArray])
               {
                  spareParticles[_loc5_.bitmapArray] = [];
               }
               spareParticles[_loc5_.bitmapArray].push(_loc5_);
               if(_loc4_ < bubbles.length)
               {
                  _loc4_--;
               }
            }
            _loc4_++;
         }
         if(frameDeployFreq > 0)
         {
            ++counter;
            if(counter % frameDeployFreq == 0)
            {
               addBubble();
            }
         }
      }
      
      public function getRandomBitmapArray() : Array
      {
         return bitmapArrays[int(Math.random() * bitmapArrays.length) % bitmapArrays.length];
      }
      
      public function initBitmaps(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         bitmapArrays = new Array();
         for each(_loc5_ in param1)
         {
            _loc3_ = new Array();
            _loc4_ = 0;
            _loc2_ = 0;
            while(_loc4_ != _loc5_.totalFrames)
            {
               _loc5_.gotoAndStop(_loc4_);
               _loc3_.push(new ParticleBitmap(_loc5_,1,true));
               _loc4_++;
            }
            bitmapArrays.push(_loc3_);
         }
      }
   }
}

