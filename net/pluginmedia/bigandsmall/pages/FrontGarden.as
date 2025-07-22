package net.pluginmedia.bigandsmall.pages
{
   import flash.display.MovieClip;
   import flash.ui.Keyboard;
   import gs.TweenMax;
   import gs.easing.Back;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.definitions.SWFLocations;
   import net.pluginmedia.bigandsmall.events.BigAndSmallEventType;
   import net.pluginmedia.bigandsmall.pages.housefront.BeePointSprite;
   import net.pluginmedia.bigandsmall.pages.housefront.FlowerPointSprite;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.sound.BrainSoundOld;
   import net.pluginmedia.brain.core.sound.SoundInfoOld;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.utils.KeyUtils;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class FrontGarden extends BigAndSmallPage3D
   {
      
      private var yellowFlowerLeftSprite:FlowerPointSprite;
      
      private var whiteFlowerRightSprite:FlowerPointSprite;
      
      private var flowers:Array;
      
      private var quadBLSprite:PointSprite;
      
      private var beePointSprite:BeePointSprite;
      
      private var scenePrepped:Boolean = false;
      
      private var greenFlowerSprite:FlowerPointSprite;
      
      private var quadTLSprite:PointSprite;
      
      private var beeActive:Boolean = false;
      
      private var magentaFlowerMidSprite:FlowerPointSprite;
      
      private var quadTRSprite:PointSprite;
      
      private var beeSound:BrainSoundOld;
      
      private var whiteFlowerLeftSprite:FlowerPointSprite;
      
      private var subject:PointSprite;
      
      private var beePlaneDist:Number = -175;
      
      private var statics:Array;
      
      private var beeLayer:ViewportLayer;
      
      private var cPos:Number2D;
      
      private var vinesTopSprite:PointSprite;
      
      private var blueFlowerSprite:FlowerPointSprite;
      
      private var useBee:Boolean = false;
      
      private var quadBRSprite:PointSprite;
      
      private var magentaFlowerRightSprite:FlowerPointSprite;
      
      public function FrontGarden(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc5_:OrbitCamera3D = null;
         statics = [];
         flowers = [];
         cPos = new Number2D();
         var _loc4_:Number3D = new Number3D(0,5,-290);
         _loc5_ = new OrbitCamera3D(56);
         _loc5_.rotationYMin = 5;
         _loc5_.rotationYMax = -3;
         _loc5_.radius = 352;
         _loc5_.rotationXMin = 1;
         _loc5_.rotationXMax = -1;
         _loc5_.orbitCentre.x = _loc4_.x;
         _loc5_.orbitCentre.y = _loc4_.y + 80;
         _loc5_.orbitCentre.z = _loc4_.z;
         super(param1,_loc4_,_loc5_,_loc5_,param2);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         var _loc1_:Number = 1.5;
         blowUpTween(quadTLSprite,_loc1_,0);
         blowUpTween(quadTRSprite,_loc1_,0);
         blowUpTween(quadBRSprite,_loc1_,0);
         blowUpTween(quadBLSprite,_loc1_,0);
         blowUpTween(blueFlowerSprite,_loc1_,0.08);
         blowUpTween(greenFlowerSprite,_loc1_,0.01);
         blowUpTween(whiteFlowerRightSprite,_loc1_,0.03);
         blowUpTween(yellowFlowerLeftSprite,_loc1_,0.06);
         blowUpTween(whiteFlowerLeftSprite,_loc1_,0.02);
         blowUpTween(magentaFlowerRightSprite,_loc1_,0.05);
         blowUpTween(magentaFlowerMidSprite,_loc1_,0.1);
         blowUpTween(vinesTopSprite,_loc1_,0);
         if(beeActive)
         {
            blowUpTween(beePointSprite,_loc1_,0,-500);
            SoundManagerOld.stopSound("BeeLoop",1);
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:FlowerPointSprite = null;
         var _loc2_:PointSprite = null;
         for each(_loc1_ in flowers)
         {
            TweenMax.killTweensOf(_loc1_);
            _loc1_.destroy();
         }
         flowers = null;
         for each(_loc2_ in statics)
         {
            TweenMax.killTweensOf(_loc2_);
            _loc2_.material.destroy();
         }
         statics = null;
         if(beeActive)
         {
            TweenMax.killTweensOf(beePointSprite);
            beePointSprite.material.destroy();
         }
         beePointSprite = null;
         subject = null;
         cPos = null;
         scenePrepped = false;
         super.destroy();
      }
      
      private function initStatics() : void
      {
         var _loc1_:MovieParticleMaterial = null;
         var _loc2_:MovieClip = unPackAsset("TopLeftQuadrant");
         _loc1_ = new MovieParticleMaterial(_loc2_);
         quadTLSprite = new PointSprite(_loc1_,0.45);
         statics.push(quadTLSprite);
         var _loc3_:MovieClip = unPackAsset("TopRightQuadrant");
         _loc1_ = new MovieParticleMaterial(_loc3_);
         quadTRSprite = new PointSprite(_loc1_,0.45);
         statics.push(quadTRSprite);
         var _loc4_:MovieClip = unPackAsset("BottomRightQuadrant");
         _loc1_ = new MovieParticleMaterial(_loc4_);
         quadBRSprite = new PointSprite(_loc1_,0.45);
         statics.push(quadBRSprite);
         var _loc5_:MovieClip = unPackAsset("BottomLeftQuadrant");
         _loc1_ = new MovieParticleMaterial(_loc5_);
         quadBLSprite = new PointSprite(_loc1_,0.45);
         statics.push(quadBLSprite);
         var _loc6_:MovieClip = unPackAsset("VinesTop");
         _loc1_ = new MovieParticleMaterial(_loc6_);
         vinesTopSprite = new PointSprite(_loc1_,0.45);
         statics.push(vinesTopSprite);
         positionDO3D(quadTLSprite,-120,216,-200);
         positionDO3D(quadTRSprite,112,210,-195);
         positionDO3D(quadBRSprite,170,-20,-140);
         positionDO3D(quadBLSprite,-112,12,-165);
         positionDO3D(vinesTopSprite,-14,210,-165);
         registerLiveDO3D("quadTL",quadTLSprite);
         registerLiveDO3D("quadTR",quadTRSprite);
         registerLiveDO3D("quadBL",quadBLSprite);
         registerLiveDO3D("quadBR",quadBRSprite);
         registerLiveDO3D("vinesTop",vinesTopSprite);
      }
      
      private function initSounds() : void
      {
         beeSound = new BrainSoundOld("BeeLoop",unPackAsset("BeeLoop"),new SoundInfoOld(1,0,int.MAX_VALUE));
         SoundManagerOld.registerSound(beeSound);
      }
      
      override public function collectionQueueEmpty() : void
      {
         initStatics();
         initFlowers();
         if(useBee)
         {
            initBee();
         }
         initSounds();
         initLayers();
         scenePrepped = true;
         setReadyState();
      }
      
      override public function onRegistration() : void
      {
         dispatchAssetRequest("PreloaderPage.swfAssetLibrary",SWFLocations.preLoaderLibrary,assetLibLoaded);
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         _loc1_.push(DO3DDefinitions.FRONTOFHOUSE_WALL);
         _loc1_.push(DO3DDefinitions.FRONTOFHOUSE_DOOR_BIG);
         _loc1_.push(DO3DDefinitions.FRONTOFHOUSE_DOOR_SMALL);
         _loc1_.push(DO3DDefinitions.FRONTOFHOUSE_GARDEN);
         return _loc1_;
      }
      
      override public function update(param1:UpdateInfo = null) : void
      {
         var _loc2_:FlowerPointSprite = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!isLive)
         {
            return;
         }
         cPos.x = basicView.viewport.containerSprite.mouseX;
         cPos.y = basicView.viewport.containerSprite.mouseY;
         for each(_loc2_ in flowers)
         {
            _loc2_.updateAttraction(cPos);
            this.flagDirtyLayer(_loc2_.viewportLayer);
         }
         if(beeActive)
         {
            this.flagDirtyLayer(beeLayer);
            beePointSprite.updateAttraction();
            _loc3_ = basicView.camera.z - beePointSprite.z;
            _loc4_ = basicView.camera.z + 120;
            _loc5_ = Math.pow(1 / (_loc3_ / _loc4_),6);
            _loc5_ = Math.min(_loc5_,1.5);
            _loc5_ = Math.max(_loc5_,0);
            _loc6_ = beePointSprite.x / (pageWidth / 2);
            _loc6_ = Math.min(_loc6_,1);
            _loc6_ = Math.max(_loc6_,-1);
            SoundManagerOld.updateTransform("BeeLoop",_loc5_,_loc6_);
         }
      }
      
      private function initFlowers() : void
      {
         var _loc1_:AnimationOld = new AnimationOld(unPackAsset("BlueFlower"));
         blueFlowerSprite = new FlowerPointSprite(basicView,_loc1_,475,-10,0.45);
         flowers.push(blueFlowerSprite);
         var _loc2_:AnimationOld = new AnimationOld(unPackAsset("YellowFlowerLeft"));
         yellowFlowerLeftSprite = new FlowerPointSprite(basicView,_loc2_,350,10,0.51);
         flowers.push(yellowFlowerLeftSprite);
         var _loc3_:AnimationOld = new AnimationOld(unPackAsset("MagentaFlowerRight"));
         magentaFlowerRightSprite = new FlowerPointSprite(basicView,_loc3_,400,10,0.49);
         flowers.push(magentaFlowerRightSprite);
         var _loc4_:AnimationOld = new AnimationOld(unPackAsset("GreenFlower"));
         greenFlowerSprite = new FlowerPointSprite(basicView,_loc4_,450,10,0.55);
         flowers.push(greenFlowerSprite);
         var _loc5_:AnimationOld = new AnimationOld(unPackAsset("WhiteFlowerRight"));
         whiteFlowerRightSprite = new FlowerPointSprite(basicView,_loc5_,600,10,0.57);
         flowers.push(whiteFlowerRightSprite);
         var _loc6_:AnimationOld = new AnimationOld(unPackAsset("WhiteFlowerLeft"));
         whiteFlowerLeftSprite = new FlowerPointSprite(basicView,_loc6_,700,-10,0.45);
         flowers.push(whiteFlowerLeftSprite);
         var _loc7_:AnimationOld = new AnimationOld(unPackAsset("MagentaFlowerMid"));
         magentaFlowerMidSprite = new FlowerPointSprite(basicView,_loc7_,375,10,0.43);
         flowers.push(magentaFlowerMidSprite);
         positionDO3D(blueFlowerSprite,99,-116,-190);
         positionDO3D(whiteFlowerLeftSprite,-95,-233,-185);
         positionDO3D(magentaFlowerMidSprite,5,-113,-175);
         positionDO3D(magentaFlowerRightSprite,37,-144,-160);
         positionDO3D(whiteFlowerRightSprite,63,-182,-190);
         positionDO3D(greenFlowerSprite,-73,-118,-150);
         positionDO3D(yellowFlowerLeftSprite,-161,-86,-148);
         registerLiveDO3D("blueflower",blueFlowerSprite);
         registerLiveDO3D("whiteFlowerRightSprite",whiteFlowerRightSprite);
         registerLiveDO3D("greenFlowerSprite",greenFlowerSprite);
         registerLiveDO3D("whiteFlowerLeftSprite",whiteFlowerLeftSprite);
         registerLiveDO3D("yellowFlowerLeftSprite",yellowFlowerLeftSprite);
         registerLiveDO3D("magentaFlowerRightSprite",magentaFlowerRightSprite);
         registerLiveDO3D("magentaFlowerMidSprite",magentaFlowerMidSprite);
      }
      
      private function initBee() : void
      {
         beeActive = true;
         var _loc1_:Plane3D = new Plane3D(new Number3D(0,0,1),new Number3D(0,0,beePlaneDist));
         beePointSprite = new BeePointSprite(basicView,unPackAsset("BeeSprite"),_loc1_,this.position,0.5);
         registerLiveDO3D("beeSprite",beePointSprite);
         positionDO3D(beePointSprite,5,-113,-175);
      }
      
      private function updatePositionHelper() : void
      {
         if(KeyUtils.isDown(Keyboard.NUMPAD_0))
         {
            subject = flowers.shift();
            flowers.push(subject);
            trace("--->",subject);
         }
         if(!subject)
         {
            return;
         }
         flagDirtyLayer(subject.container);
         if(KeyUtils.isDown(Keyboard.LEFT))
         {
            subject.x -= 2;
         }
         else if(KeyUtils.isDown(Keyboard.RIGHT))
         {
            subject.x += 2;
         }
         if(KeyUtils.isDown(Keyboard.UP))
         {
            subject.y += 2;
         }
         else if(KeyUtils.isDown(Keyboard.DOWN))
         {
            subject.y -= 2;
         }
         if(KeyUtils.isDown(Keyboard.SPACE))
         {
            trace(subject);
         }
      }
      
      override public function park() : void
      {
         super.park();
         if(basicView.contains(pageContainer2D))
         {
            basicView.removeChild(pageContainer2D);
         }
         selfDestruct();
      }
      
      override protected function build() : void
      {
      }
      
      private function initLayers() : void
      {
         var _loc1_:ViewportLayer = null;
         var _loc2_:ViewportLayer = null;
         _loc1_ = basicView.viewport.getChildLayer(vinesTopSprite,true,true);
         _loc1_.addDisplayObject3D(quadTRSprite);
         _loc1_.addDisplayObject3D(quadTLSprite);
         _loc1_.forceDepth = true;
         _loc1_.screenDepth = 48;
         _loc1_.mouseEnabled = false;
         _loc2_ = basicView.viewport.getChildLayer(blueFlowerSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 50;
         blueFlowerSprite.setLayer(_loc2_);
         _loc2_ = basicView.viewport.getChildLayer(whiteFlowerLeftSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 51;
         whiteFlowerLeftSprite.setLayer(_loc2_);
         _loc2_ = basicView.viewport.getChildLayer(magentaFlowerMidSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 53;
         magentaFlowerMidSprite.setLayer(_loc2_);
         _loc2_ = basicView.viewport.getChildLayer(quadBLSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 59;
         _loc2_.mouseEnabled = false;
         _loc2_ = basicView.viewport.getChildLayer(whiteFlowerRightSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 61;
         whiteFlowerRightSprite.setLayer(_loc2_);
         _loc2_ = basicView.viewport.getChildLayer(magentaFlowerRightSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 65;
         magentaFlowerRightSprite.setLayer(_loc2_);
         _loc2_ = basicView.viewport.getChildLayer(greenFlowerSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 67;
         greenFlowerSprite.setLayer(_loc2_);
         _loc2_ = basicView.viewport.getChildLayer(yellowFlowerLeftSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 70;
         yellowFlowerLeftSprite.setLayer(_loc2_);
         _loc2_ = basicView.viewport.getChildLayer(quadBRSprite,true,true);
         _loc2_.forceDepth = true;
         _loc2_.screenDepth = 71;
         _loc2_.mouseEnabled = false;
         if(beeActive)
         {
            beeLayer = basicView.viewport.getChildLayer(beePointSprite,true,true);
            beeLayer.forceDepth = true;
            beeLayer.screenDepth = 49;
            beeLayer.mouseEnabled = false;
         }
      }
      
      override public function activate() : void
      {
         super.activate();
         if(beeActive)
         {
            SoundManagerOld.playSound("BeeLoop");
         }
         broadcast(BigAndSmallEventType.HIDE_BS_NAVMENUBUTTON);
      }
      
      override protected function tabEnableViewports(param1:Boolean) : void
      {
         var _loc2_:FlowerPointSprite = null;
         super.tabEnableViewports(param1);
         for each(_loc2_ in flowers)
         {
            _loc2_.setTabEnabled(param1);
         }
      }
      
      private function blowUpTween(param1:DisplayObject3D, param2:Number = 2, param3:Number = 0, param4:Number = -100, param5:Function = null) : void
      {
         if(param5 === null)
         {
            param5 = Back.easeIn;
         }
         var _loc6_:Number2D = new Number2D(0,0);
         var _loc7_:Number2D = new Number2D(param1.x,param1.y);
         var _loc8_:Number2D = Number2D.subtract(_loc6_,_loc7_);
         var _loc9_:Number = _loc8_.modulo;
         _loc8_.normalise();
         TweenMax.to(param1,param2,{
            "delay":param3,
            "x":param1.x + _loc8_.x * param4,
            "y":param1.y + _loc8_.y * param4,
            "ease":param5
         });
      }
   }
}

