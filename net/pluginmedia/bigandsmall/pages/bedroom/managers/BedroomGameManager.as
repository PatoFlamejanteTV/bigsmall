package net.pluginmedia.bigandsmall.pages.bedroom.managers
{
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.pages.bedroom.Blind;
   import net.pluginmedia.bigandsmall.pages.bedroom.TableTopperPlane;
   import net.pluginmedia.bigandsmall.pages.bedroom.mobile.MobileStruct3D;
   import net.pluginmedia.bigandsmall.ui.VPortLayerButton;
   import org.papervision3d.view.BasicView;
   
   public class BedroomGameManager extends EventDispatcher
   {
      
      protected var page:BigAndSmallPage3D;
      
      public var doneBlindResponse:Boolean = false;
      
      protected var blind:Blind;
      
      protected var lamp:TableTopperPlane;
      
      protected var clock:TableTopperPlane;
      
      protected var clockButton:VPortLayerButton;
      
      protected var lightDarkManager:LightDarkManager;
      
      protected var mobile:MobileStruct3D;
      
      public var doneMobileResponse:Boolean = false;
      
      protected var blindButton:VPortLayerButton;
      
      protected var lampButton:VPortLayerButton;
      
      protected var _active:Boolean;
      
      protected var basicView:BasicView;
      
      protected var mobileLayerButton:VPortLayerButton;
      
      public function BedroomGameManager(param1:BigAndSmallPage3D, param2:BasicView)
      {
         super();
         _active = false;
         page = param1;
         basicView = param2;
      }
      
      public function enableMobile() : void
      {
         mobileLayerButton.setEnabledState(true);
      }
      
      public function get active() : Boolean
      {
         return _active;
      }
      
      public function stopInteractive() : void
      {
         setLightsEnabled(false);
      }
      
      public function activate() : void
      {
         _active = true;
         startInteractive();
      }
      
      public function park() : void
      {
      }
      
      public function setBlind(param1:Blind, param2:VPortLayerButton) : void
      {
         this.blind = param1;
         blindButton = param2;
         blindButton.addEventListener(MouseEvent.CLICK,handleBlindClicked);
      }
      
      public function reset() : void
      {
         doneMobileResponse = false;
         doneBlindResponse = false;
         mobile.spinVel = 0;
      }
      
      public function disableMobile() : void
      {
         mobileLayerButton.setEnabledState(false);
      }
      
      public function setLamp(param1:TableTopperPlane, param2:VPortLayerButton) : void
      {
         this.lamp = param1;
         lampButton = param2;
         lampButton.addEventListener(MouseEvent.CLICK,handleLampClicked);
      }
      
      public function prepare() : void
      {
      }
      
      public function setLightDarkManager(param1:LightDarkManager) : void
      {
         lightDarkManager = param1;
      }
      
      public function setMobile(param1:MobileStruct3D, param2:VPortLayerButton) : void
      {
         this.mobile = param1;
         this.mobileLayerButton = param2;
      }
      
      protected function setLightsEnabled(param1:Boolean) : void
      {
         if(Boolean(lampButton) && Boolean(blindButton))
         {
            blindButton.setEnabledState(param1);
            lampButton.setEnabledState(param1);
            clockButton.setEnabledState(param1);
         }
      }
      
      protected function lightChange() : void
      {
         doneBlindResponse = true;
         setLightsEnabled(false);
      }
      
      protected function handleLampClicked(param1:MouseEvent) : void
      {
         if(active)
         {
            lightChange();
         }
      }
      
      public function startInteractive() : void
      {
         setLightsEnabled(true);
      }
      
      protected function handleBlindClicked(param1:MouseEvent) : void
      {
         if(active)
         {
            lightChange();
         }
      }
      
      public function deactivate() : void
      {
         _active = false;
         stopInteractive();
      }
      
      public function setAlarmClock(param1:TableTopperPlane, param2:VPortLayerButton) : void
      {
         this.clock = param1;
         clockButton = param2;
         param2.addEventListener(MouseEvent.CLICK,handleBlindClicked);
      }
   }
}

