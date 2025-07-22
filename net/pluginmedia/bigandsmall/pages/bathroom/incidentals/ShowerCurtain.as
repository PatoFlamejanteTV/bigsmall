package net.pluginmedia.bigandsmall.pages.bathroom.incidentals
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.pluginmedia.brain.core.interfaces.IUpdatable;
   import net.pluginmedia.brain.core.updating.UpdateInfo;
   import net.pluginmedia.maths.SuperMath;
   import net.pluginmedia.pv3d.materials.FadeChangeableBitmapMaterial;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.objects.primitives.Plane;
   
   public class ShowerCurtain extends DisplayObject3D implements IUpdatable
   {
      
      private var curtainMoving:Boolean = false;
      
      private var originalPositions:Array;
      
      private var closedTex:BitmapData;
      
      private var timeoutMoveMult:uint = 5;
      
      private var rolloverPositions:Array;
      
      private var newPositions:Array;
      
      private var openClip:MovieClip;
      
      private var velocities:Array;
      
      private var segw:uint;
      
      private var segh:uint;
      
      private var delays:Array;
      
      private var halfHeight:Number;
      
      private var halfWidth:Number;
      
      private var targetPositions:Array;
      
      private var plane:Plane;
      
      private var mat:FadeChangeableBitmapMaterial;
      
      private var closedClip:MovieClip;
      
      private var rolloverTimer:Timer;
      
      private var planeVertices:Array;
      
      private var lowPolyPlane:Plane;
      
      private var openTex:BitmapData;
      
      public function ShowerCurtain(param1:MovieClip, param2:MovieClip, param3:uint, param4:uint, param5:uint = 10, param6:uint = 6)
      {
         super();
         openClip = param1;
         closedClip = param2;
         segw = param5;
         segh = param6;
         halfWidth = param3 * 0.5;
         halfHeight = param4 * 0.5;
         init();
      }
      
      public function get active() : Boolean
      {
         return curtainMoving;
      }
      
      private function updatePoints(param1:Number = 0.45, param2:Number = 0.3, param3:Number = 0.2, param4:Number = -0.15, param5:Boolean = false) : void
      {
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:Vertex3D = null;
         var _loc13_:Number3D = null;
         var _loc14_:Vertex3D = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc6_:Number = -1;
         var _loc7_:int = 0;
         while(_loc7_ < planeVertices.length)
         {
            _loc8_ = planeVertices[_loc7_];
            _loc9_ = velocities[_loc7_];
            _loc10_ = targetPositions[_loc7_];
            _loc11_ = 0;
            while(_loc11_ < _loc8_.length)
            {
               if(param5)
               {
                  _loc12_ = Vertex3D(_loc8_[_loc11_]);
                  _loc13_ = Number3D(_loc10_[_loc11_]);
                  _loc12_.x = _loc13_.x;
                  _loc12_.y = _loc13_.y;
                  _loc12_.z = _loc13_.z;
               }
               else if(delays[_loc7_][_loc11_] <= 0)
               {
                  _loc14_ = _loc8_[_loc11_];
                  _loc15_ = Math.abs(_loc14_.y) / halfHeight;
                  _loc16_ = param1 + _loc15_ * param2;
                  _loc17_ = param3 + _loc15_ * param4;
                  _loc18_ = _loc14_.x;
                  if(targetPositions == originalPositions)
                  {
                     _loc16_ = param1;
                     _loc17_ = param3;
                  }
                  easeVertex(_loc8_[_loc11_],_loc9_[_loc11_],_loc10_[_loc11_],_loc16_,_loc17_);
                  _loc19_ = _loc14_.x;
                  _loc20_ = Math.abs(_loc19_ - _loc18_);
                  if(_loc20_ > _loc6_)
                  {
                     _loc6_ = _loc20_;
                  }
               }
               else
               {
                  --delays[_loc7_][_loc11_];
               }
               _loc11_++;
            }
            _loc7_++;
         }
         if(_loc6_ > 0.115 || targetPositions != originalPositions)
         {
            curtainMoving = true;
         }
         else
         {
            curtainMoving = false;
            curtain.visible = false;
            lowPolyCurtain.visible = true;
         }
      }
      
      public function init() : void
      {
         openTex = new BitmapData(openClip.width,openClip.height,true,0);
         closedTex = openTex.clone();
         openTex.draw(openClip,null,null,BlendMode.MULTIPLY,null,true);
         closedTex.draw(closedClip,null,null,BlendMode.MULTIPLY,null,true);
         mat = new FadeChangeableBitmapMaterial(openTex,"open",openTex.width,openTex.height,true);
         mat.addBitmap(closedTex,"closed");
         mat.doubleSided = true;
         mat.fadeFrames = 8;
         plane = new Plane(mat,halfWidth * 2,halfHeight * 2,segw,segh);
         plane.y = -halfHeight;
         plane.x = halfWidth;
         addChild(plane);
         planeVertices = setupVertices(plane);
         calculateDestPoints(-halfWidth);
         targetPositions = newPositions;
         toggle();
         var _loc1_:BitmapMaterial = new BitmapMaterial(openTex);
         _loc1_.doubleSided = true;
         lowPolyPlane = new Plane(_loc1_,halfWidth * 2,halfHeight * 2,3,2);
         lowPolyPlane.y = plane.y;
         lowPolyPlane.x = plane.x;
         addChild(lowPolyPlane);
         rolloverTimer = new Timer(500,1);
         rolloverTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handleRolloverTimer);
      }
      
      public function get curtain() : Plane
      {
         return plane;
      }
      
      private function setupVertices(param1:Plane) : Array
      {
         var _loc4_:Vertex3D = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Array = null;
         var _loc2_:Object = {};
         var _loc3_:Array = [];
         for each(_loc4_ in param1.geometry.vertices)
         {
            _loc8_ = _loc4_.x.toFixed(0);
            if(!(_loc2_[_loc8_] is Array))
            {
               _loc2_[_loc8_] = [];
            }
            _loc2_[_loc8_].push(_loc4_);
         }
         for each(_loc5_ in _loc2_)
         {
            _loc5_.sortOn("y");
            _loc3_.push(_loc5_);
         }
         _loc6_ = 0;
         _loc7_ = 0;
         _loc6_ = _loc3_.length - 2;
         while(_loc6_ >= 0)
         {
            _loc7_ = 0;
            while(_loc7_ <= _loc6_)
            {
               _loc9_ = Vertex3D(_loc3_[_loc7_][0]).x;
               _loc10_ = Vertex3D(_loc3_[_loc7_ + 1][0]).x;
               if(_loc9_ > _loc10_)
               {
                  _loc11_ = _loc3_[_loc7_ + 1];
                  _loc3_[_loc7_ + 1] = _loc3_[_loc7_];
                  _loc3_[_loc7_] = _loc11_;
               }
               _loc7_++;
            }
            _loc6_--;
         }
         return _loc3_;
      }
      
      public function snapShut() : void
      {
         close();
         updatePoints(0.45,0.3,0.2,-0.15,true);
         curtainMoving = false;
      }
      
      private function isOdd(param1:Number) : Boolean
      {
         return Boolean(int(param1 % 2));
      }
      
      private function calculateDestPoints(param1:Number = -250, param2:Number = 90, param3:Number = 70, param4:Number = 1.8, param5:Number = 10) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Vertex3D = null;
         var _loc12_:Number3D = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number3D = null;
         originalPositions = [];
         newPositions = [];
         velocities = [];
         rolloverPositions = [];
         var _loc6_:Number = param1 + param2;
         var _loc7_:Number = param1;
         _loc8_ = 0;
         while(_loc8_ < planeVertices.length)
         {
            _loc10_ = planeVertices[_loc8_];
            originalPositions[_loc8_] = [];
            newPositions[_loc8_] = [];
            velocities[_loc8_] = [];
            rolloverPositions[_loc8_] = [];
            _loc9_ = 0;
            while(_loc9_ < _loc10_.length)
            {
               _loc11_ = _loc10_[_loc9_] as Vertex3D;
               originalPositions[_loc8_][_loc9_] = new Number3D(_loc11_.x,_loc11_.y,_loc11_.z);
               _loc12_ = new Number3D();
               _loc13_ = _loc8_ / planeVertices.length;
               _loc14_ = 1 - Math.abs(_loc11_.y) / halfHeight;
               _loc15_ = param2 - param3 * Math.pow(_loc14_,param4);
               _loc12_.x = _loc7_ + _loc13_ * _loc15_;
               _loc12_.y = _loc11_.y;
               if(_loc8_ != 0 && _loc8_ != planeVertices.length - 1)
               {
                  _loc12_.z = isOdd(_loc8_) ? param5 : -param5;
               }
               else
               {
                  _loc12_.z = _loc8_ == 0 ? _loc11_.z : _loc11_.z;
               }
               newPositions[_loc8_][_loc9_] = _loc12_;
               _loc16_ = originalPositions[_loc8_][_loc9_].clone();
               if(_loc8_ >= planeVertices.length - 2)
               {
                  _loc16_.x -= Math.pow(_loc14_,param4) * 40;
               }
               rolloverPositions[_loc8_][_loc9_] = _loc16_;
               velocities[_loc8_][_loc9_] = new Number3D();
               _loc9_++;
            }
            _loc8_++;
         }
      }
      
      private function handleRolloverTimer(param1:TimerEvent) : void
      {
         targetPositions = originalPositions;
      }
      
      public function rollout() : void
      {
         if(targetPositions == rolloverPositions)
         {
            targetPositions = originalPositions;
            plane.visible = true;
            lowPolyPlane.visible = false;
         }
      }
      
      public function get lowPolyCurtain() : Plane
      {
         return lowPolyPlane;
      }
      
      public function update(param1:UpdateInfo = null) : void
      {
         updatePoints();
      }
      
      public function open() : void
      {
         rolloverTimer.reset();
         rolloverTimer.stop();
         curtain.visible = true;
         lowPolyCurtain.visible = false;
         if(targetPositions != newPositions)
         {
            targetPositions = originalPositions;
            toggle();
            mat.activeBitmap = "closed";
            plane.visible = true;
            lowPolyPlane.visible = false;
            dispatchEvent(new Event("OPEN"));
         }
      }
      
      public function rollover() : void
      {
         if(targetPositions == originalPositions)
         {
            targetPositions = rolloverPositions;
            plane.visible = true;
            lowPolyPlane.visible = false;
         }
      }
      
      public function toggle() : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vertex3D = null;
         var _loc6_:Number = NaN;
         delays = [];
         var _loc1_:int = 0;
         while(_loc1_ < planeVertices.length)
         {
            _loc2_ = planeVertices[_loc1_];
            _loc3_ = delays[_loc1_] = [];
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = _loc2_[_loc4_];
               _loc6_ = Math.abs(_loc5_.y) / halfHeight;
               _loc3_[_loc4_] = int(_loc6_ * timeoutMoveMult);
               _loc4_++;
            }
            _loc1_++;
         }
         if(targetPositions == newPositions)
         {
            targetPositions = originalPositions;
         }
         else
         {
            targetPositions = newPositions;
         }
         dispatchEvent(new Event("TOGGLE"));
      }
      
      private function easeVertex(param1:Vertex3D, param2:Number3D, param3:Number3D, param4:Number = 0.7, param5:Number = 0.15) : void
      {
         param4 = SuperMath.clamp(param4,0,1);
         param5 = SuperMath.clamp(param5,0,1);
         param2.x *= param4;
         param2.y *= param4;
         param2.z *= param4;
         var _loc6_:Number = param3.x - param1.x;
         var _loc7_:Number = param3.y - param1.y;
         var _loc8_:Number = param3.z - param1.z;
         _loc6_ *= param5;
         _loc7_ *= param5;
         _loc8_ *= param5;
         param2.x += _loc6_;
         param2.y += _loc7_;
         param2.z += _loc8_;
         param1.x += param2.x;
         param1.y += param2.y;
         param1.z += param2.z;
      }
      
      public function close() : void
      {
         if(targetPositions != originalPositions)
         {
            targetPositions = newPositions;
            toggle();
            mat.activeBitmap = "open";
            dispatchEvent(new Event("CLOSE"));
         }
      }
   }
}

