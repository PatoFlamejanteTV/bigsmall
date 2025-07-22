package net.pluginmedia.bigandsmall.pages.garden.tree.managers
{
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.pages.garden.tree.AppleParticle;
   import net.pluginmedia.bigandsmall.pages.garden.tree.AppleTreeFloor;
   import net.pluginmedia.bigandsmall.pages.garden.tree.events.AppleTreeEvent;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.sound.SoundManager;
   import net.pluginmedia.maths.SuperMath;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class AppleParticleManager extends DisplayObject3D
   {
      
      public static var SFX_APPLE_OVER:String = "AppleOver";
      
      public static var SFX_APPLE_CLICK:String = "AppleClick";
      
      public static var SFX_APPLE_IMPACT_GROUND:String = "AppleImpact_Ground";
      
      public static var SFX_APPLE_IMPACT_BIG:String = "AppleImpact_Big";
      
      private var applesInOwnLayers:Boolean = false;
      
      private var floor:AppleTreeFloor;
      
      private var page:Page3D;
      
      private var layerButtons:Dictionary;
      
      private var basicView:BasicView;
      
      private var apples:Array;
      
      public function AppleParticleManager(param1:BasicView, param2:Page3D, param3:AppleTreeFloor, param4:Sound, param5:Sound, param6:Sound, param7:Sound)
      {
         super();
         SoundManager.quickRegisterSound(SFX_APPLE_OVER,param4);
         SoundManager.quickRegisterSound(SFX_APPLE_CLICK,param5);
         SoundManager.quickRegisterSound(SFX_APPLE_IMPACT_GROUND,param6);
         SoundManager.quickRegisterSound(SFX_APPLE_IMPACT_BIG,param7);
         this.page = param2;
         basicView = param1;
         floor = param3;
         apples = [];
         layerButtons = new Dictionary();
      }
      
      public function activate() : void
      {
         putApplesInPrivateLayers();
         resetApples();
      }
      
      public function prepare() : void
      {
      }
      
      public function resetApples(param1:Boolean = false) : void
      {
         var _loc2_:AppleParticle = null;
         for each(_loc2_ in apples)
         {
            _loc2_.reset(param1);
         }
      }
      
      public function update(param1:Boolean = false) : void
      {
         var _loc2_:AppleParticle = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         for each(_loc2_ in apples)
         {
            if(_loc2_.released && !_loc2_.rest)
            {
               _loc2_.velocity.y -= _loc2_.gravity;
               if(_loc2_.velocity.y < 0)
               {
                  _loc2_.velocity.multiplyEq(1.05);
               }
               if(!_loc2_.hitbig && param1)
               {
                  if(floor.hitsBig(_loc2_))
                  {
                     _loc2_.velocity.x = SuperMath.random(-6,-11);
                     _loc2_.rotationalVelocity = _loc2_.velocity.x * 0.4;
                     _loc2_.velocity.y *= -0.4;
                     _loc2_.hitbig = true;
                     SoundManager.playSound(SFX_APPLE_IMPACT_BIG);
                     dispatchEvent(new AppleTreeEvent(AppleTreeEvent.APPLE_HITS_BIG,_loc2_));
                  }
               }
               _loc2_.x += _loc2_.velocity.x;
               _loc2_.y += _loc2_.velocity.y;
               _loc2_.z += _loc2_.velocity.z;
               _loc2_.incrementRotation(_loc2_.rotationalVelocity);
               _loc3_ = floor.getYFromX(_loc2_.x);
               if(_loc2_.y < _loc3_)
               {
                  SoundManager.playSound(SFX_APPLE_IMPACT_GROUND,_loc2_.velocity.y * -1 / 100);
                  if(!_loc2_.hasDispatchedImpactEvent)
                  {
                     dispatchEvent(new AppleTreeEvent(AppleTreeEvent.APPLE_IMPACTS_FLOOR,_loc2_));
                     _loc2_.hasDispatchedImpactEvent = true;
                  }
                  _loc2_.y = _loc3_;
                  _loc4_ = floor.getGradientFromX(_loc2_.x);
                  if(_loc2_.velocity.y < -3)
                  {
                     _loc2_.velocity.y *= -0.3;
                     if(_loc2_.velocity.x == 0)
                     {
                        _loc2_.velocity.x = -_loc4_ * 8 * (_loc2_.velocity.y / 10);
                     }
                     else
                     {
                        _loc2_.velocity.x *= 0.5;
                     }
                     if(_loc2_.rotationalVelocity == 0)
                     {
                        _loc2_.rotationalVelocity = _loc2_.velocity.y / 3.4 * -_loc4_ * 1.8;
                     }
                     else
                     {
                        _loc2_.rotationalVelocity *= 0.2;
                     }
                  }
                  else
                  {
                     _loc2_.velocity.multiplyEq(0);
                     _loc2_.rotationalVelocity = 0;
                     _loc2_.rest = true;
                     dispatchEvent(new AppleTreeEvent(AppleTreeEvent.APPLE_FINDS_REST,_loc2_));
                  }
               }
            }
            page.flagDirtyLayer(_loc2_.container);
         }
      }
      
      public function addApple(param1:AppleParticle) : void
      {
         addChild(param1);
         apples.push(param1);
         var _loc2_:ViewportLayer = basicView.viewport.getChildLayer(param1,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 4;
         param1.viewportLayer = _loc2_;
         layerButtons[param1] = _loc2_;
         param1.addEventListener(MouseEvent.CLICK,handleAppleClick);
         param1.addEventListener(MouseEvent.ROLL_OVER,handleAppleOver);
         param1.reset(true);
      }
      
      public function putApplesInSharedLayer(param1:ViewportLayer) : void
      {
         var _loc2_:AppleParticle = null;
         for each(_loc2_ in apples)
         {
            param1.addDisplayObject3D(_loc2_);
         }
         applesInOwnLayers = false;
      }
      
      public function park() : void
      {
      }
      
      private function handleAppleOver(param1:MouseEvent) : void
      {
         SoundManager.playSound(SFX_APPLE_OVER);
      }
      
      private function handleAppleClick(param1:MouseEvent) : void
      {
         SoundManager.playSound(SFX_APPLE_CLICK);
      }
      
      public function deactivate() : void
      {
      }
      
      public function putApplesInPrivateLayers() : void
      {
         var _loc1_:AppleParticle = null;
         if(applesInOwnLayers)
         {
            return;
         }
         for each(_loc1_ in apples)
         {
            _loc1_.viewportLayer.addDisplayObject3D(_loc1_);
         }
         applesInOwnLayers = true;
      }
   }
}

