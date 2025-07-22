package net.pluginmedia.bigandsmall.pages.bedroom.mobile
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.pluginmedia.bigandsmall.physics.VerletParticle;
   import net.pluginmedia.bigandsmall.physics.VerletString;
   import net.pluginmedia.brain.buttons.*;
   import net.pluginmedia.brain.core.*;
   import net.pluginmedia.brain.core.events.*;
   import net.pluginmedia.brain.pages.*;
   import net.pluginmedia.brain.ui.*;
   import net.pluginmedia.pv3d.materials.special.LineMaterial3D;
   import org.papervision3d.core.geom.Lines3D;
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class MobileStruct3D extends DisplayObject3D
   {
      
      private var hangerVerts:Array = [];
      
      private var lineThick:Number = 1;
      
      private var dragPlaneNormal:Number3D;
      
      private var numHangerVerts:int = 2;
      
      private var hangerLines:Lines3D;
      
      private var hangerRoot:VerletParticle;
      
      private var hangerTerm:VerletParticle;
      
      private var mobilePartA:MobilePart3D;
      
      private var mobilePartB:MobilePart3D;
      
      private var dragPlaneAngle:Number = 10;
      
      private var _isDragging:Boolean = false;
      
      public var spinDamp:Number = 0.99;
      
      private var verletSpring:Number = 0.35;
      
      private var stringRestLength1:Number = 8;
      
      private var stringRestLength2:Number = 10;
      
      private var stringRestLength3:Number = 6;
      
      private var stringRestLength4:Number = 12;
      
      private var worldOffset:Number3D;
      
      private var gravity:Number = 10;
      
      private var planeWorldOffset:Number3D;
      
      private var ikHangerString:VerletString;
      
      private var actorSpinDamp:Number = spinDamp;
      
      private var hangerLength:Number = 30;
      
      private var dragEnabled:Boolean = false;
      
      private var verletIterations:Number = 5;
      
      private var verletTimeStep:Number = 0.25;
      
      private var basicView:BasicView;
      
      private var isInited:Boolean = false;
      
      public var spinVel:Number = 0;
      
      public function MobileStruct3D(param1:BasicView)
      {
         basicView = param1;
         super();
         autoCalcScreenCoords = true;
      }
      
      public function initLayers(param1:ViewportLayer) : void
      {
         mobilePartA.initLayers(param1);
         mobilePartB.initLayers(param1);
         param1.addDisplayObject3D(hangerLines);
      }
      
      private function updatePhys() : void
      {
         mobilePartA.accumulateForce(0,gravity);
         mobilePartB.accumulateForce(0,gravity);
         var _loc1_:int = 0;
         while(_loc1_ < verletIterations)
         {
            ikHangerString.update();
            mobilePartA.update();
            mobilePartB.update();
            _loc1_++;
         }
      }
      
      private function handleMobileDragProgress(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function handleStageClick(param1:MouseEvent) : void
      {
         if(_isDragging)
         {
            param1.stopPropagation();
            stopDrag();
         }
      }
      
      public function init(param1:Number3D, param2:DisplayObject, param3:DisplayObject, param4:DisplayObject, param5:DisplayObject, param6:Class) : void
      {
         var _loc9_:Vertex3D = null;
         var _loc10_:Vertex3D = null;
         var _loc11_:Line3D = null;
         if(isInited)
         {
            throw new Error("Mobile :: Attempt to re-init object");
         }
         worldOffset = param1;
         planeWorldOffset = new Number3D(-worldOffset.x,-worldOffset.y,-worldOffset.z);
         var _loc7_:LineMaterial3D = new LineMaterial3D(4268630,1);
         hangerLines = new Lines3D(_loc7_,"hangerLines");
         addChild(hangerLines);
         ikHangerString = new VerletString(Math.random(),Math.random(),numHangerVerts,hangerLength,0,1);
         ikHangerString.timeStep = verletTimeStep;
         ikHangerString.spring = verletSpring;
         hangerRoot = ikHangerString.cParts[0] as VerletParticle;
         hangerRoot.isPinned = true;
         hangerTerm = ikHangerString.cParts[ikHangerString.cParts.length - 1] as VerletParticle;
         var _loc8_:int = 0;
         while(_loc8_ < numHangerVerts)
         {
            _loc9_ = null;
            _loc9_ = new Vertex3D(0,0,0);
            hangerVerts.push(_loc9_);
            if(_loc8_ > 0)
            {
               _loc10_ = hangerVerts[_loc8_ - 1] as Vertex3D;
               _loc11_ = new Line3D(hangerLines,_loc7_,lineThick,_loc9_,_loc10_);
               hangerLines.addLine(_loc11_);
            }
            _loc8_++;
         }
         mobilePartA = new MobilePart3D(basicView);
         mobilePartA.init(basicView.camera,param2,param3,4268630,1449031,param6,hangerTerm,verletTimeStep,verletSpring,stringRestLength1,stringRestLength2);
         mobilePartA.addEventListener("StartDrag",handleStartDrag);
         mobilePartA.addEventListener(MobileDragEvent.PROGRESS,handleMobileDragProgress);
         addChild(mobilePartA);
         mobilePartB = new MobilePart3D(basicView);
         mobilePartB.init(basicView.camera,param4,param5,1449031,4268630,param6,hangerTerm,verletTimeStep,verletSpring,stringRestLength3,stringRestLength4);
         mobilePartB.addEventListener("StartDrag",handleStartDrag);
         mobilePartB.addEventListener(MobileDragEvent.PROGRESS,handleMobileDragProgress);
         mobilePartB.rotationY = 90;
         addChild(mobilePartB);
         dragPlaneNormal = new Number3D(0,0,-1);
         dragPlaneNormal.rotateY(dragPlaneAngle);
         this.rotationY = dragPlaneAngle;
         mobilePartA.planeObj.setNormalAndPoint(dragPlaneNormal,planeWorldOffset);
         mobilePartB.planeObj.setNormalAndPoint(dragPlaneNormal,planeWorldOffset);
         isInited = true;
      }
      
      public function get isDragging() : Boolean
      {
         return _isDragging;
      }
      
      public function stopJingleSpin(param1:Boolean = false) : void
      {
         if(param1)
         {
            spinVel = 0;
         }
         else
         {
            actorSpinDamp = spinDamp;
         }
      }
      
      private function startDrag(param1:MobilePart3D) : void
      {
         _isDragging = true;
         stopJingleSpin(true);
         if(param1 == mobilePartA)
         {
            this.rotationY = dragPlaneAngle;
         }
         else
         {
            this.rotationY = dragPlaneAngle + 90;
         }
         spinVel = 0;
      }
      
      public function disableDrag() : void
      {
         dragEnabled = false;
         basicView.stage.removeEventListener(MouseEvent.CLICK,handleStageClick,true);
      }
      
      public function enableDrag() : void
      {
         dragEnabled = true;
         basicView.stage.addEventListener(MouseEvent.CLICK,handleStageClick,true);
      }
      
      public function update(param1:int = 1) : void
      {
         if(!isInited)
         {
            return;
         }
         do
         {
            updatePhys();
            param1--;
         }
         while(param1 > 0);
         
         update3D();
      }
      
      private function handleMobileDecalRollOver(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      public function pickUpRandomDecal() : void
      {
         var _loc1_:Number = Math.floor(Math.random() * 2);
         var _loc2_:MobilePart3D = null;
         var _loc3_:MobileDecor = null;
         if(dragEnabled)
         {
            if(_loc1_ < 1)
            {
               _loc2_ = mobilePartA;
            }
            else
            {
               _loc2_ = mobilePartB;
            }
            _loc1_ = Math.floor(Math.random() * 2);
            if(_loc1_ < 1)
            {
               _loc2_.startDrag(_loc2_.decorPlane1);
            }
            else
            {
               _loc2_.startDrag(_loc2_.decorPlane2);
            }
         }
      }
      
      public function stopDrag() : void
      {
         if(_isDragging)
         {
            _isDragging = false;
            mobilePartA.drop();
            mobilePartB.drop();
            dispatchEvent(new Event("StopDrag"));
         }
      }
      
      private function update3D() : void
      {
         var _loc2_:VerletParticle = null;
         var _loc3_:Vertex3D = null;
         mobilePartA.updateStrutRotation(mobilePartB.strutAngle);
         mobilePartB.updateStrutRotation(-mobilePartA.strutAngle);
         var _loc1_:int = 0;
         while(_loc1_ < numHangerVerts)
         {
            _loc2_ = ikHangerString.cParts[_loc1_] as VerletParticle;
            _loc3_ = hangerVerts[_loc1_] as Vertex3D;
            _loc3_.x = _loc2_.loc.x;
            _loc3_.y = -_loc2_.loc.y;
            _loc1_++;
         }
         if(Math.abs(spinVel) < 0.0001)
         {
            spinVel = 0;
         }
         if(spinVel != 0)
         {
            this.rotationY += spinVel;
            spinVel *= actorSpinDamp;
         }
         mobilePartA.x = mobilePartB.x = hangerTerm.loc.x;
         mobilePartA.y = mobilePartB.y = -hangerTerm.loc.y;
         mobilePartA.worldOffset.x = worldOffset.x;
         mobilePartA.worldOffset.y = worldOffset.y;
         mobilePartA.worldOffset.z = worldOffset.z;
         mobilePartB.worldOffset.x = worldOffset.x;
         mobilePartB.worldOffset.y = worldOffset.y;
         mobilePartB.worldOffset.z = worldOffset.z;
      }
      
      private function handleStartDrag(param1:Event) : void
      {
         if(dragEnabled)
         {
            dispatchEvent(param1.clone());
            startDrag(param1.target as MobilePart3D);
         }
      }
      
      public function doJingleSpin(param1:Number) : void
      {
         spinVel = param1;
         actorSpinDamp = 1;
      }
   }
}

