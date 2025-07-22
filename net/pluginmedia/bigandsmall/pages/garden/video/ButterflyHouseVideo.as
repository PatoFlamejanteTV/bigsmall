package net.pluginmedia.bigandsmall.pages.garden.video
{
   import flash.events.Event;
   import flash.ui.Keyboard;
   import net.pluginmedia.bigandsmall.definitions.DO3DDefinitions;
   import net.pluginmedia.bigandsmall.pages.shared.video.VideoPage3D;
   import net.pluginmedia.brain.core.Page3D;
   import net.pluginmedia.brain.core.sharing.ShareRequest;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import net.pluginmedia.utils.KeyUtils;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.view.BasicView;
   
   public class ButterflyHouseVideo extends VideoPage3D
   {
      
      public function ButterflyHouseVideo(param1:BasicView, param2:String, param3:Page3D = null)
      {
         var _loc5_:OrbitCamera3D = null;
         var _loc4_:Number3D = new Number3D(-2753,57,537);
         _loc5_ = new OrbitCamera3D(45);
         super(param1,_loc4_,_loc5_,_loc5_,param2,param3);
         _loc5_.rotationYMin = -145;
         _loc5_.rotationYMax = -143;
         _loc5_.radius = 80;
         _loc5_.rotationXMin = 180;
         _loc5_.rotationXMax = 183;
         _loc5_.orbitCentre.x = _loc4_.x;
         _loc5_.orbitCentre.y = _loc4_.y;
         _loc5_.orbitCentre.z = _loc4_.z;
         this.scaleX = this.scaleY = 1.45;
         this.rotationY = 36;
      }
      
      override public function onShareableRegistration() : void
      {
         super.onShareableRegistration();
         dispatchShareRequest(new ShareRequest(this,"VideoFileH",handleVideoLocation));
         registerLiveDO3D(DO3DDefinitions.GARDEN_VIDEOPLANE,videoPlane);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
      }
      
      private function debugEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = 1;
         if(KeyUtils.isDown(Keyboard.LEFT))
         {
            this.x -= _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.RIGHT))
         {
            this.x += _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.UP))
         {
            this.y += _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.DOWN))
         {
            this.y -= _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_0))
         {
            this.z -= _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_1))
         {
            this.z += _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_7))
         {
            this.rotationY -= _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.NUMPAD_8))
         {
            this.rotationY += _loc2_;
         }
         if(KeyUtils.isDown(Keyboard.SPACE))
         {
            trace(this,this.rotationY);
         }
         renderStateIsDirty = true;
      }
      
      override public function getLiveVisibleDisplayObjects() : Array
      {
         var _loc1_:Array = super.getLiveVisibleDisplayObjects();
         _loc1_.push(DO3DDefinitions.GARDEN_DAE);
         _loc1_.push(DO3DDefinitions.GARDEN_PARALLAX);
         return _loc1_;
      }
      
      override public function activate() : void
      {
         super.activate();
      }
   }
}

