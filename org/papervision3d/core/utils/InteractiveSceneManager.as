package org.papervision3d.core.utils
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.utils.virtualmouse.IVirtualMouseEvent;
   import org.papervision3d.core.utils.virtualmouse.VirtualMouse;
   import org.papervision3d.events.InteractiveScene3DEvent;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.Viewport3D;
   
   public class InteractiveSceneManager extends EventDispatcher
   {
      
      public static var MOUSE_IS_DOWN:Boolean = false;
      
      public var currentMaterial:MaterialObject3D;
      
      public var container:Sprite;
      
      public var currentMousePos:Point = new Point();
      
      public var debug:Boolean = false;
      
      public var mouse3D:Mouse3D = new Mouse3D();
      
      public var enableOverOut:Boolean = true;
      
      public var currentDisplayObject3D:DisplayObject3D;
      
      public var _viewportRendered:Boolean = false;
      
      public var virtualMouse:VirtualMouse = new VirtualMouse();
      
      public var lastMousePos:Point = new Point();
      
      public var viewport:Viewport3D;
      
      public var renderHitData:RenderHitData;
      
      public var currentMouseDO3D:DisplayObject3D = null;
      
      public function InteractiveSceneManager(param1:Viewport3D)
      {
         super();
         this.viewport = param1;
         this.container = param1.containerSprite;
         init();
      }
      
      protected function handleMouseClick(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         if(Boolean(renderHitData) && renderHitData.hasHit)
         {
            dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_CLICK,currentDisplayObject3D);
         }
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         var _loc3_:MovieMaterial = null;
         var _loc2_:Boolean = hasMouseMoved();
         if(_loc2_ || _viewportRendered)
         {
            updateRenderHitData();
            _viewportRendered = false;
            if(param1 is IVirtualMouseEvent)
            {
               return;
            }
            if(Boolean(virtualMouse) && Boolean(renderHitData))
            {
               _loc3_ = currentMaterial as MovieMaterial;
               if(_loc3_)
               {
                  virtualMouse.container = _loc3_.movie as Sprite;
               }
               if(virtualMouse.container)
               {
                  virtualMouse.setLocation(renderHitData.u,renderHitData.v);
               }
               if(Mouse3D.enabled && renderHitData && renderHitData.hasHit)
               {
                  mouse3D.updatePosition(renderHitData);
               }
               dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_MOVE,currentDisplayObject3D);
            }
            else if(Boolean(renderHitData) && renderHitData.hasHit)
            {
               dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_MOVE,currentDisplayObject3D);
            }
         }
         lastMousePos.x = currentMousePos.x;
         lastMousePos.y = currentMousePos.y;
      }
      
      public function updateAfterRender() : void
      {
         _viewportRendered = true;
      }
      
      public function initListeners() : void
      {
         if(viewport.interactive)
         {
            container.addEventListener(MouseEvent.MOUSE_DOWN,handleMousePress,false,0,true);
            container.addEventListener(MouseEvent.MOUSE_UP,handleMouseRelease,false,0,true);
            container.addEventListener(MouseEvent.CLICK,handleMouseClick,false,0,true);
            container.addEventListener(MouseEvent.DOUBLE_CLICK,handleMouseDoubleClick,false,0,true);
            container.stage.addEventListener(Event.ENTER_FRAME,handleEnterFrame,false,0,true);
         }
      }
      
      protected function initVirtualMouse() : void
      {
         virtualMouse.stage = container.stage;
         virtualMouse.container = container;
      }
      
      protected function handleMouseOver(param1:DisplayObject3D) : void
      {
         if(hasMouseMoved())
         {
            dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_OVER,param1);
         }
      }
      
      protected function resolveRenderHitData() : void
      {
         renderHitData = viewport.hitTestPoint2D(currentMousePos) as RenderHitData;
      }
      
      public function updateRenderHitData() : void
      {
         resolveRenderHitData();
         currentDisplayObject3D = renderHitData.displayObject3D;
         currentMaterial = renderHitData.material;
         manageOverOut();
      }
      
      protected function hasMouseMoved() : Boolean
      {
         currentMousePos.x = container.mouseX;
         currentMousePos.y = container.mouseY;
         return !currentMousePos.equals(lastMousePos);
      }
      
      protected function dispatchObjectEvent(param1:String, param2:DisplayObject3D) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:InteractiveScene3DEvent = null;
         if(Boolean(renderHitData) && renderHitData.hasHit)
         {
            _loc3_ = renderHitData.u ? renderHitData.u : 0;
            _loc4_ = renderHitData.v ? renderHitData.v : 0;
            _loc5_ = new InteractiveScene3DEvent(param1,param2,container,renderHitData.renderable as Triangle3D,_loc3_,_loc4_,renderHitData);
            _loc5_.renderHitData = renderHitData;
            dispatchEvent(_loc5_);
            param2.dispatchEvent(_loc5_);
         }
         else
         {
            dispatchEvent(new InteractiveScene3DEvent(param1,param2,container));
            if(param2)
            {
               param2.dispatchEvent(new InteractiveScene3DEvent(param1,param2,container));
            }
         }
      }
      
      protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         if(Boolean(renderHitData) && renderHitData.hasHit)
         {
            dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_DOUBLE_CLICK,currentDisplayObject3D);
         }
      }
      
      protected function handleMouseRelease(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         MOUSE_IS_DOWN = false;
         if(virtualMouse)
         {
            virtualMouse.release();
         }
         if(Mouse3D.enabled && renderHitData && renderHitData.renderable != null)
         {
            mouse3D.updatePosition(renderHitData);
         }
         if(Boolean(renderHitData) && renderHitData.hasHit)
         {
            dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_RELEASE,currentDisplayObject3D);
         }
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         container.removeEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
         initVirtualMouse();
         initListeners();
      }
      
      protected function handleMouseOut(param1:DisplayObject3D) : void
      {
         var _loc2_:MovieMaterial = null;
         if(!hasMouseMoved())
         {
            return;
         }
         if(param1)
         {
            _loc2_ = param1.material as MovieMaterial;
            if(_loc2_)
            {
               virtualMouse.exitContainer();
            }
         }
         dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_OUT,param1);
      }
      
      protected function manageOverOut() : void
      {
         if(!enableOverOut)
         {
            return;
         }
         if(Boolean(renderHitData) && renderHitData.hasHit)
         {
            if(!currentMouseDO3D && Boolean(currentDisplayObject3D))
            {
               handleMouseOver(currentDisplayObject3D);
               currentMouseDO3D = currentDisplayObject3D;
            }
            else if(Boolean(currentMouseDO3D) && currentMouseDO3D != currentDisplayObject3D)
            {
               handleMouseOut(currentMouseDO3D);
               handleMouseOver(currentDisplayObject3D);
               currentMouseDO3D = currentDisplayObject3D;
            }
         }
         else if(currentMouseDO3D != null)
         {
            handleMouseOut(currentMouseDO3D);
            currentMouseDO3D = null;
         }
      }
      
      public function destroy() : void
      {
         viewport = null;
         renderHitData = null;
         currentDisplayObject3D = null;
         currentMaterial = null;
         currentMouseDO3D = null;
         virtualMouse.stage = null;
         virtualMouse.container = null;
         container.removeEventListener(MouseEvent.MOUSE_DOWN,handleMousePress);
         container.removeEventListener(MouseEvent.MOUSE_UP,handleMouseRelease);
         container.removeEventListener(MouseEvent.CLICK,handleMouseClick);
         container.removeEventListener(MouseEvent.DOUBLE_CLICK,handleMouseDoubleClick);
         if(container.stage)
         {
            container.stage.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
         }
         container = null;
      }
      
      public function init() : void
      {
         if(container)
         {
            if(container.stage)
            {
               initVirtualMouse();
               initListeners();
            }
            else
            {
               container.addEventListener(Event.ADDED_TO_STAGE,handleAddedToStage,false,0,true);
            }
         }
      }
      
      protected function handleMousePress(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         MOUSE_IS_DOWN = true;
         if(virtualMouse)
         {
            virtualMouse.press();
         }
         if(Mouse3D.enabled && renderHitData && renderHitData.renderable != null)
         {
            mouse3D.updatePosition(renderHitData);
         }
         if(Boolean(renderHitData) && renderHitData.hasHit)
         {
            dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_PRESS,currentDisplayObject3D);
         }
      }
   }
}

