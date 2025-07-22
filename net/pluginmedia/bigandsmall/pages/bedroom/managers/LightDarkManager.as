package net.pluginmedia.bigandsmall.pages.bedroom.managers
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.core.BigAndSmallPage3D;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.pages.bedroom.Blind;
   import net.pluginmedia.bigandsmall.pages.bedroom.TableTopperPlane;
   import net.pluginmedia.pv3d.materials.FadeChangeableBitmapMaterial;
   
   public class LightDarkManager
   {
      
      public static const LIGHTSTATE_ON:uint = 1;
      
      public static const LIGHTSTATE_OFF:uint = 0;
      
      public var fadeFrames:uint = 12;
      
      public var fadeMaterials:Dictionary;
      
      private var blind:Blind;
      
      private var parentPage:BigAndSmallPage3D;
      
      public var lightState:uint = 1;
      
      private var tableToppers:Array = [];
      
      private var fading:Boolean = false;
      
      protected var _currentPOV:String;
      
      public function LightDarkManager(param1:BigAndSmallPage3D)
      {
         super();
         parentPage = param1;
         fadeMaterials = new Dictionary();
      }
      
      public function updateTableToppers() : void
      {
         var _loc1_:TableTopperPlane = null;
         for each(_loc1_ in tableToppers)
         {
            if(_loc1_ !== null)
            {
               if(lightState == LIGHTSTATE_OFF)
               {
                  _loc1_.setMaterialState(String(currentPOV + "_" + LIGHTSTATE_ON));
               }
               else
               {
                  _loc1_.setMaterialState(String(currentPOV + "_" + LIGHTSTATE_OFF));
               }
               parentPage.flagDirtyLayer(_loc1_.viewportLayer);
            }
         }
      }
      
      public function update(param1:Boolean = false) : void
      {
         updateTableToppers();
         if(blind !== null)
         {
            updateBlind(param1);
         }
         setAllMaterials(!Boolean(lightState),param1);
      }
      
      public function updateBlind(param1:Boolean) : void
      {
         if(lightState == LIGHTSTATE_OFF && !blind.isClosed)
         {
            blind.closeBlind(param1);
         }
         else if(lightState == LIGHTSTATE_ON && blind.isClosed)
         {
            blind.openBlind(param1);
         }
      }
      
      public function setAllMaterials(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc5_:FadeChangeableBitmapMaterial = null;
         var _loc3_:String = param1 ? "dark" : "light";
         var _loc4_:Boolean = false;
         for each(_loc5_ in fadeMaterials)
         {
            if(!_loc4_)
            {
               fading = true;
               _loc5_.addEventListener(FadeChangeableBitmapMaterial.FADE_COMPLETE,handleFadeComplete);
            }
            _loc5_.fadeFrames = param2 ? 0 : this.fadeFrames;
            _loc5_.activeBitmap = _loc3_;
         }
      }
      
      public function toggleLights(param1:Boolean = false) : void
      {
         if(!fading)
         {
            if(lightState == LIGHTSTATE_OFF)
            {
               lightState = LIGHTSTATE_ON;
            }
            else if(lightState == LIGHTSTATE_ON)
            {
               lightState = LIGHTSTATE_OFF;
            }
            update(param1);
         }
      }
      
      public function setBlind(param1:Blind) : void
      {
         this.blind = param1;
      }
      
      public function get currentPOV() : String
      {
         return _currentPOV;
      }
      
      public function addLightDarkMaterial(param1:String, param2:FadeChangeableBitmapMaterial) : void
      {
         fadeMaterials[param1] = param2;
         if(blind)
         {
            if(blind.isClosed && param2.activeBitmap != "dark")
            {
               param2.fadeFrames = 0;
               param2.activeBitmap = "dark";
            }
            else if(param2.activeBitmap != "light")
            {
               param2.fadeFrames = 0;
               param2.activeBitmap = "light";
            }
         }
      }
      
      protected function handleFadeComplete(param1:Event) : void
      {
         fading = false;
         param1.target.removeEventListener(FadeChangeableBitmapMaterial.FADE_COMPLETE,handleFadeComplete);
      }
      
      public function addTableTopper(param1:TableTopperPlane) : void
      {
         tableToppers.push(param1);
      }
      
      public function set currentPOV(param1:String) : void
      {
         _currentPOV = param1;
         if(param1 == CharacterDefinitions.BIG)
         {
            if(lightState == LIGHTSTATE_OFF)
            {
               toggleLights(true);
            }
         }
         else if(lightState == LIGHTSTATE_ON)
         {
            toggleLights(true);
         }
         updateTableToppers();
      }
   }
}

