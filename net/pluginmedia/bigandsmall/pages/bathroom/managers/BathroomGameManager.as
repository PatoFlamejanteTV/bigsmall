package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.pages.bathroom.BathroomGameProgress;
   import net.pluginmedia.brain.core.events.ShareReferenceEvent;
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.sharing.SharerInfo;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.cameras.OrbitCamera3D;
   import org.papervision3d.core.data.UserData;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   
   public class BathroomGameManager extends EventDispatcher implements IUpdatable
   {
      
      public static const GAME_COMPLETE:String = "GAME_EXIT";
      
      protected var _gameOver:Boolean = false;
      
      protected var basicView:BasicView;
      
      protected var _liveDO3DList:Array = [];
      
      protected var score:Number = 0;
      
      protected var managerPageContainer2D:Sprite;
      
      protected var accessClip:Sprite;
      
      public var toothpasteManager:ToothpasteManager;
      
      protected var _active:Boolean = false;
      
      protected var parentPage3D:BigAndSmallPage3D;
      
      protected var dock:BathroomGameProgress;
      
      public function BathroomGameManager(param1:BigAndSmallPage3D, param2:Sprite, param3:BasicView, param4:BathroomGameProgress, param5:ToothpasteManager)
      {
         super();
         toothpasteManager = param5;
         this.parentPage3D = param1;
         managerPageContainer2D = param2;
         basicView = param3;
         this.dock = param4;
         param4.addEventListener("GAME_EXIT",handleDockExitIssued);
      }
      
      public function get active() : Boolean
      {
         return _active;
      }
      
      public function prepare() : void
      {
         dock.onPrepare();
         _gameOver = false;
      }
      
      public function getLiveVisibleDisplayObjects() : Array
      {
         return _liveDO3DList;
      }
      
      protected function setScore(param1:Number, param2:Boolean = false) : void
      {
         this.score = param1;
         param1 = SuperMath.clamp(param1,0,1);
         dock.gotoPercent(param1 * 100,param2);
         if(param1 >= 1)
         {
            gameOver();
         }
      }
      
      private function handleDockExitIssued(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      public function setAccessClip(param1:Sprite) : void
      {
         accessClip = param1;
      }
      
      protected function get3DPoint(param1:Number, param2:Number, param3:Number, param4:Number3D = null) : Number3D
      {
         if(!param4)
         {
            param4 = new Number3D();
         }
         var _loc5_:OrbitCamera3D = basicView.camera as OrbitCamera3D;
         var _loc6_:Number3D = _loc5_.unproject(param1,param2);
         _loc6_.x += _loc5_.x;
         _loc6_.y += _loc5_.y;
         _loc6_.z += _loc5_.z;
         var _loc7_:Plane3D = new Plane3D();
         var _loc8_:Number3D = new Number3D(0,0,-1);
         var _loc9_:Number3D = parentPage3D.position.clone();
         var _loc10_:Number3D = _loc9_.clone();
         var _loc11_:Number3D = _loc9_.clone();
         _loc7_.setThreePoints(_loc9_,_loc10_,_loc11_);
         var _loc12_:Number3D = new Number3D(_loc5_.x,_loc5_.y,_loc5_.z);
         var _loc13_:Number3D = _loc7_.getIntersectionLineNumbers(_loc12_,_loc6_);
         _loc13_.minusEq(parentPage3D.position);
         return _loc13_;
      }
      
      public function update(param1:UpdateInfo = null) : void
      {
      }
      
      protected function incrementScore(param1:Number, param2:Boolean = false) : void
      {
         setScore(this.score + param1,param2);
      }
      
      protected function removeAccessClipListeners() : void
      {
         accessClip.removeEventListener(MouseEvent.CLICK,handleAccessClipClick);
      }
      
      public function park() : void
      {
         dock.onPark();
      }
      
      protected function registerLiveDO3D(param1:String, param2:DisplayObject3D) : void
      {
         param2.name = param1;
         param2.userData = new UserData({"page3D":parentPage3D});
         _liveDO3DList.push(param1);
         dispatchEvent(new ShareReferenceEvent(ShareReferenceEvent.SHARE_REFERENCE,new SharerInfo(param1,param2)));
      }
      
      protected function addAccessClipListeners() : void
      {
         accessClip.addEventListener(MouseEvent.CLICK,handleAccessClipClick);
      }
      
      public function activate() : void
      {
         _active = true;
         dock.summon();
         if(accessClip)
         {
            addAccessClipListeners();
         }
      }
      
      public function deactivate() : void
      {
         _active = false;
         dock.unSummon();
         toothpasteManager.removeAllParticles();
         if(accessClip)
         {
            removeAccessClipListeners();
         }
      }
      
      protected function gameOver() : void
      {
         _gameOver = true;
         dispatchEvent(new Event(GAME_COMPLETE));
      }
      
      protected function handleAccessClipClick(param1:MouseEvent) : void
      {
         trace("handleAccessClipClick");
      }
   }
}

