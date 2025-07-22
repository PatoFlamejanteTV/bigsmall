package net.pluginmedia.bigandsmall.pages.bedroom
{
   import flash.events.EventDispatcher;
   import net.pluginmedia.utils.Easing;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ModifiableDuvet extends EventDispatcher
   {
      
      private var yVel:Number = 0;
      
      private var yTarget:Number = 0;
      
      private var mesh:DisplayObject3D;
      
      private var modRad:Number = 10;
      
      public var easeSpeed:Number = 0.7;
      
      private var modVertices:Array = [];
      
      public var velDamp:Number = 0.6;
      
      private var _yCurrent:Number = 0;
      
      public function ModifiableDuvet()
      {
         super();
      }
      
      public function get yCurrent() : Number
      {
         return _yCurrent;
      }
      
      public function update() : void
      {
         if(modVertices.length < 1)
         {
            return;
         }
         yVel *= velDamp;
         var _loc1_:Number = yTarget - _yCurrent;
         yVel += _loc1_ * easeSpeed;
         _yCurrent += yVel;
         if(Math.abs(yVel) > 0.0001)
         {
            updatePoints();
         }
         else
         {
            _yCurrent = yTarget;
         }
      }
      
      public function setTarg(param1:Number, param2:Boolean = false) : void
      {
         yTarget = param1;
         if(param2)
         {
            _yCurrent = yTarget;
            updatePoints();
         }
      }
      
      public function updatePoints() : void
      {
         var _loc1_:ModifiableVertex = null;
         for each(_loc1_ in modVertices)
         {
            _loc1_.vert.y = _loc1_.vertOriginal.y + _yCurrent * _loc1_.dist;
         }
      }
      
      public function initModifiableVerts(param1:Number) : void
      {
         var _loc6_:Vertex3D = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:ModifiableVertex = null;
         if(mesh === null)
         {
            throw new Error("ModifiableDuvet :: updateModifiableVerts :: mesh is null");
         }
         modVertices = new Array();
         modRad = param1;
         var _loc2_:Number3D = null;
         var _loc3_:Number3D = new Number3D(0,0,0);
         var _loc4_:Number = 0;
         var _loc5_:Number3D = new Number3D(0,0,0);
         for each(_loc6_ in mesh.geometry.vertices)
         {
            _loc2_ = _loc6_.getPosition();
            _loc3_.x = _loc2_.x - _loc5_.x;
            _loc3_.y = _loc2_.y - _loc5_.y;
            _loc3_.z = _loc2_.z - _loc5_.z;
            _loc4_ = _loc3_.modulo;
            if(_loc4_ < modRad)
            {
               _loc7_ = 1 - _loc4_ / modRad;
               _loc8_ = Easing.easeInOut(_loc7_,0,1,3);
               _loc9_ = new ModifiableVertex(_loc6_,_loc8_);
               modVertices.push(_loc9_);
            }
         }
      }
      
      public function init(param1:DisplayObject3D, param2:Number) : void
      {
         if(param1 === null)
         {
            throw new Error("ModifiableDuvet :: init :: mesh is null");
         }
         this.mesh = param1;
         initModifiableVerts(param2);
      }
   }
}

