package net.pluginmedia.bigandsmall.pages.bedroom
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.pluginmedia.brain.core.BrainLogger;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.objects.primitives.Plane;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class TableTopperPlane extends Plane
   {
      
      private var matStateDict:Dictionary = new Dictionary(true);
      
      public var viewportLayer:ViewportLayer;
      
      public function TableTopperPlane(param1:Number = 100, param2:Number = 100, param3:int = 1, param4:int = 1)
      {
         var _loc5_:WireframeMaterial = new WireframeMaterial();
         super(_loc5_,param1,param2,param3,param4);
      }
      
      public function setMaterialState(param1:String) : void
      {
         var _loc2_:MaterialObject3D = matStateDict[param1];
         if(_loc2_ === null)
         {
            BrainLogger.warning("TableTopperPlane :: setMaterialState :: warning :: no material sourced for key",param1," - defaulting to wireframe");
            _loc2_ = new WireframeMaterial();
         }
         this.material = _loc2_;
      }
      
      public function newMaterialState(param1:String, param2:DisplayObject, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false, param6:Rectangle = null) : void
      {
         var _loc7_:MaterialObject3D = new WireframeMaterial();
         if(param2 === null)
         {
            BrainLogger.warning("TableTopperPlane :: newMaterialState :: warning :: DisplayObject asset is null, defaulting to wireframe for key:",param1);
         }
         else
         {
            _loc7_ = new MovieMaterial(param2,param3,param4,param5,param6);
            _loc7_.doubleSided = true;
         }
         matStateDict[param1] = _loc7_;
      }
   }
}

