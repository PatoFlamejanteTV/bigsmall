package net.pluginmedia.bigandsmall.pages.garden
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.pluginmedia.bigandsmall.definitions.ScreenDepthDefinitions;
   import net.pluginmedia.bigandsmall.pages.garden.culling.ManualDisplayObject3DCullable;
   import net.pluginmedia.bigandsmall.pages.garden.culling.MeshGardenCullable;
   import net.pluginmedia.bigandsmall.pages.garden.interfaces.IGardenCullable;
   import net.pluginmedia.maths.Vector2D;
   import net.pluginmedia.pv3d.DAEFixed;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.DisplayObjectContainer3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.BasicView;
   import org.papervision3d.view.layer.ViewportLayer;
   import org.papervision3d.view.layer.util.ViewportLayerSortMode;
   
   public class GardenDAEController
   {
      
      public var vegepatchFrontStr:String = "vegepatch_front";
      
      public var mysteriousWoodsFrontLyr:ViewportLayer;
      
      public var middleHedgeMdl:DisplayObject3D;
      
      public var treeLyr:ViewportLayer;
      
      private var parents:Dictionary;
      
      private var basicView:BasicView;
      
      private var viewAng:Number;
      
      public var pondfrontGrassStr:String = "grass_pondfront";
      
      public var topGrassStr:String = "grass_top";
      
      public var houseLayer:ViewportLayer;
      
      private var objects:Dictionary;
      
      public var dirtMoundStr:String = "vegepatch";
      
      public var bottomHedgeStr:String = "hedges_part03";
      
      private var _cullingInited:Boolean = false;
      
      public var vegepatchMdl:DisplayObject3D;
      
      public var reflObjContainer:DisplayObject3D;
      
      public var washlineStr:String = "washingline1";
      
      private var cullables:Array;
      
      public var shedLyr:ViewportLayer;
      
      public var wheelbarrowLyr:ViewportLayer;
      
      public var butterflyHouseMdl:DisplayObject3D;
      
      public var treeMdl:DisplayObject3D;
      
      public var bottomGrassLyr:ViewportLayer;
      
      public var mysteriousWoodsFrontMdl:DisplayObject3D;
      
      public var pondParentMdl:DisplayObject3D;
      
      public var foliageMdls:Array = [];
      
      public var gardenSignStr:String = "gardensign";
      
      public var topHedgeStr:String = "hedges_part01";
      
      public var middleGrassStr:String = "grass_middle";
      
      public var woodsHedgeStr:String = "hedges_part04";
      
      public var wheelbarrowMdl:DisplayObject3D;
      
      public var pondLyr:ViewportLayer;
      
      public var underLayer:ViewportLayer;
      
      private var control:Point;
      
      public var shedMdl:DisplayObject3D;
      
      public var mysteriousWoodsBackStr:String = "mysteriouswoods_background";
      
      public var pondfrontGrassLyr:ViewportLayer;
      
      private var vect:Vector2D;
      
      public var bottomGrassMdl:DisplayObject3D;
      
      public var topGrassLyr:ViewportLayer;
      
      public var washlineLyr:ViewportLayer;
      
      public var houseMdl:DisplayObject3D;
      
      public var byHouseHedgeMdl:DisplayObject3D;
      
      public var dirtMoundContainerLyr:ViewportLayer;
      
      public var houseDoorStr:String = "house_door";
      
      private var central:Point;
      
      public var pondMdl:DisplayObject3D;
      
      public var middleHedgeStr:String = "hedges_part02";
      
      public var butterflyHouseStr:String = "butterflyhouse";
      
      public var dirtMoundLyr:ViewportLayer;
      
      public var dae:DAEFixed;
      
      public var numTriangles:int = 0;
      
      public var pondfrontGrassMdl:DisplayObject3D;
      
      public var topGrassMdl:DisplayObject3D;
      
      private var alldo3ds:Array;
      
      public var dirtMoundMdl:DisplayObject3D;
      
      public var bottomHedgeMdl:DisplayObject3D;
      
      public var washlineMdl:DisplayObject3D;
      
      public var middleGrassLyr:ViewportLayer;
      
      public var mysteriousWoodsFrontStr:String = "mysteriouswood_foreground";
      
      public var treeStr:String = "tree";
      
      public var beneathPondLyr:ViewportLayer;
      
      public var mysteriousWoodsBackLyr:ViewportLayer;
      
      public var pondParentStr:String = "pond";
      
      public var gardenSignMdl:DisplayObject3D;
      
      public var topHedgeMdl:DisplayObject3D;
      
      public var wheelbarrowStr:String = "wheelbarrow";
      
      public var woodsHedgeMdl:DisplayObject3D;
      
      public var butterflyHouseLyr:ViewportLayer;
      
      public var middleGrassMdl:DisplayObject3D;
      
      public var overLayer:ViewportLayer;
      
      public var bottomGrassStr:String = "grass_bottom";
      
      public var houseDoorMdl:DisplayObject3D;
      
      public var shedStr:String = "shed";
      
      public var houseStr:String = "house";
      
      public var reflObjLayer:ViewportLayer;
      
      public var byHouseHedgeStr:String = "hedges_part05";
      
      public var abovePondLyr:ViewportLayer;
      
      public var pondStr:String = "pond";
      
      public var mysteriousWoodsBackMdl:DisplayObject3D;
      
      public function GardenDAEController(param1:BasicView, param2:DAEFixed)
      {
         super();
         dae = param2;
         basicView = param1;
         objects = new Dictionary();
         parents = new Dictionary();
         fetchObjectRefs();
         initObjectLayers();
         initCullingVars();
      }
      
      public function fetchTriangleCount(param1:DisplayObject3D = null) : void
      {
         var _loc2_:* = undefined;
         if(!param1)
         {
            return;
         }
         for(_loc2_ in param1.children)
         {
            fetchTriangleCount(param1.children[_loc2_]);
         }
         if(param1.geometry)
         {
            numTriangles += param1.geometry.faces.length;
         }
      }
      
      public function initCullingVars() : void
      {
         central = new Point();
         control = new Point();
         vect = new Vector2D();
      }
      
      private function fetchObjectRefs() : void
      {
         var _loc1_:DisplayObject3D = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:DisplayObject3D = null;
         topGrassMdl = dae.getChildByName(topGrassStr,true);
         middleGrassMdl = dae.getChildByName(middleGrassStr,true);
         bottomGrassMdl = dae.getChildByName(bottomGrassStr,true);
         pondfrontGrassMdl = dae.getChildByName(pondfrontGrassStr,true);
         reflObjContainer = new DisplayObject3D();
         bottomGrassMdl.addChild(reflObjContainer);
         treeMdl = dae.getChildByName(treeStr,true);
         washlineMdl = dae.getChildByName(washlineStr,true);
         topHedgeMdl = dae.getChildByName(topHedgeStr,true);
         middleHedgeMdl = dae.getChildByName(middleHedgeStr,true);
         bottomHedgeMdl = dae.getChildByName(bottomHedgeStr,true);
         woodsHedgeMdl = dae.getChildByName(woodsHedgeStr,true);
         byHouseHedgeMdl = dae.getChildByName(byHouseHedgeStr,true);
         mysteriousWoodsBackMdl = dae.getChildByName(mysteriousWoodsBackStr,true);
         mysteriousWoodsFrontMdl = dae.getChildByName(mysteriousWoodsFrontStr,true);
         butterflyHouseMdl = dae.getChildByName(butterflyHouseStr,true);
         shedMdl = dae.getChildByName(shedStr,true);
         dirtMoundMdl = dae.getChildByName(dirtMoundStr,true);
         gardenSignMdl = dae.getChildByName(gardenSignStr,true);
         vegepatchMdl = dae.getChildByName(vegepatchFrontStr,true);
         pondParentMdl = dae.getChildByName(pondParentStr,true);
         for each(_loc1_ in pondParentMdl.children)
         {
            if(_loc1_.name == pondStr)
            {
               pondMdl = _loc1_;
            }
         }
         wheelbarrowMdl = dae.getChildByName(wheelbarrowStr,true);
         houseMdl = dae.getChildByName(houseStr,true);
         houseDoorMdl = dae.getChildByName(houseDoorStr,true);
         alldo3ds = [topGrassMdl,middleGrassMdl,bottomGrassMdl,pondfrontGrassMdl,treeMdl,washlineMdl,topHedgeMdl,middleHedgeMdl,bottomHedgeMdl,woodsHedgeMdl,mysteriousWoodsBackMdl,mysteriousWoodsFrontMdl,butterflyHouseMdl,shedMdl,pondParentMdl,wheelbarrowMdl,dirtMoundMdl,vegepatchMdl,houseMdl];
         _loc2_ = 1;
         while(_loc2_ <= 10)
         {
            _loc3_ = "hillfoliage0" + _loc2_.toString();
            _loc4_ = dae.getChildByName(_loc3_,true);
            if(_loc4_)
            {
               foliageMdls.push(_loc4_);
               alldo3ds.push(_loc4_);
            }
            _loc2_++;
         }
      }
      
      private function initObjectLayers() : void
      {
         var _loc1_:DisplayObject3D = null;
         var _loc2_:int = 0;
         var _loc4_:String = null;
         var _loc5_:DisplayObject3D = null;
         var _loc7_:ViewportLayer = null;
         underLayer = basicView.viewport.getChildLayer(topHedgeMdl,true,true);
         underLayer.addDisplayObject3D(middleHedgeMdl);
         underLayer.addDisplayObject3D(bottomHedgeMdl);
         underLayer.getChildLayer(topGrassMdl,true,true);
         underLayer.getChildLayer(middleGrassMdl,true,true);
         underLayer.getChildLayer(bottomGrassMdl,true,true);
         underLayer.getChildLayer(washlineMdl,true,true);
         underLayer.screenDepth = ScreenDepthDefinitions.GARDEN_UNDERLAYER;
         underLayer.forceDepth = true;
         overLayer = basicView.viewport.getChildLayer(shedMdl,true,true);
         overLayer.addDisplayObject3D(treeMdl,true);
         overLayer.addDisplayObject3D(wheelbarrowMdl,true);
         overLayer.addDisplayObject3D(mysteriousWoodsBackMdl,true);
         overLayer.addDisplayObject3D(mysteriousWoodsFrontMdl,true);
         houseLayer = overLayer.getChildLayer(houseMdl,true,true);
         overLayer.screenDepth = ScreenDepthDefinitions.GARDEN_OVERLAYER;
         overLayer.forceDepth = true;
         pondfrontGrassLyr = basicView.viewport.getChildLayer(pondfrontGrassMdl,true,true);
         for each(_loc1_ in pondParentMdl.children)
         {
            if(_loc1_.name !== pondStr)
            {
               overLayer.addDisplayObject3D(_loc1_,true);
            }
         }
         _loc2_ = 0;
         while(_loc2_ < foliageMdls.length)
         {
            overLayer.addDisplayObject3D(foliageMdls[_loc2_] as DisplayObject3D,true);
            _loc2_++;
         }
         pondLyr = basicView.viewport.getChildLayer(pondParentMdl,true);
         pondLyr.screenDepth = ScreenDepthDefinitions.GARDEN_PONDLAYER;
         pondLyr.forceDepth = true;
         dirtMoundContainerLyr = new ViewportLayer(basicView.viewport,null);
         dirtMoundContainerLyr.sortMode = ViewportLayerSortMode.INDEX_SORT;
         basicView.viewport.containerSprite.addLayer(dirtMoundContainerLyr);
         dirtMoundContainerLyr.screenDepth = ScreenDepthDefinitions.GARDEN_VEGPATCHLAYER;
         dirtMoundContainerLyr.forceDepth = true;
         dirtMoundLyr = dirtMoundContainerLyr.getChildLayer(dirtMoundMdl,true,true);
         dirtMoundLyr.layerIndex = 0;
         dirtMoundLyr.addDisplayObject3D(gardenSignMdl);
         var _loc3_:ViewportLayer = dirtMoundContainerLyr.getChildLayer(vegepatchMdl,true,true);
         _loc3_.layerIndex = 2;
         _loc3_.getChildLayer(dae.getChildByName("hillfoliage08",true),true,true);
         _loc3_.getChildLayer(dae.getChildByName("hillfoliage09",true),true,true);
         var _loc6_:Array = [8,9];
         _loc2_ = 1;
         while(_loc2_ <= 10)
         {
            if(_loc6_.indexOf(_loc2_) == -1)
            {
               _loc4_ = "hillfoliage0" + _loc2_.toString();
               _loc5_ = dae.getChildByName(_loc4_,true);
               if(_loc5_)
               {
                  _loc7_ = pondfrontGrassLyr.getChildLayer(_loc5_,true,true);
               }
            }
            _loc2_++;
         }
         _loc2_ = 1;
         while(_loc2_ <= 10)
         {
            _loc4_ = "pondplane0" + _loc2_.toString();
            _loc5_ = dae.getChildByName(_loc4_,true);
            if(_loc5_)
            {
               overLayer.getChildLayer(_loc5_,true,true);
            }
            _loc2_++;
         }
         butterflyHouseLyr = overLayer.getChildLayer(butterflyHouseMdl,true,true);
         treeLyr = overLayer.getChildLayer(treeMdl,true,true);
         overLayer.getChildLayer(dae.getChildByName("rockplane01",true),true,true);
         abovePondLyr = overLayer;
         beneathPondLyr = pondLyr;
      }
      
      public function initCulling() : void
      {
         var _loc1_:DisplayObject3D = null;
         var _loc2_:IGardenCullable = null;
         var _loc3_:TriangleMesh3D = null;
         cullables = [];
         for each(_loc1_ in alldo3ds)
         {
            _loc3_ = _loc1_ as TriangleMesh3D;
            if(_loc3_)
            {
               _loc2_ = new MeshGardenCullable(_loc1_);
               _loc2_.initCullPoints();
               cullables.push(_loc2_);
               continue;
            }
            switch(_loc1_)
            {
               case treeMdl:
                  _loc2_ = new ManualDisplayObject3DCullable(_loc1_);
                  _loc2_.manuallyDefineCullRect(new Rectangle(-2755,515,750,450));
                  cullables.push(_loc2_);
                  break;
               case topGrassMdl:
                  _loc2_ = new ManualDisplayObject3DCullable(_loc1_);
                  _loc2_.manuallyDefineCullRect(new Rectangle(-1625,-120,1400,950));
                  cullables.push(_loc2_);
                  break;
               case wheelbarrowMdl:
                  _loc2_ = new ManualDisplayObject3DCullable(_loc1_);
                  _loc2_.manuallyDefineCullRect(new Rectangle(-1625,620,400,265));
                  cullables.push(_loc2_);
                  break;
               case houseMdl:
                  _loc2_ = new ManualDisplayObject3DCullable(_loc1_);
                  _loc2_.manuallyDefineCullRect(new Rectangle(-419,-236,360,565));
                  cullables.push(_loc2_);
                  break;
               case shedMdl:
                  _loc2_ = new ManualDisplayObject3DCullable(_loc1_);
                  _loc2_.manuallyDefineCullRect(new Rectangle(-800,615,500,285));
                  cullables.push(_loc2_);
                  break;
            }
         }
         _cullingInited = true;
      }
      
      public function addManualCullable(param1:DisplayObject3D, param2:Rectangle) : void
      {
         if(!_cullingInited)
         {
            throw new Error("culling not inited");
         }
         var _loc3_:IGardenCullable = new ManualDisplayObject3DCullable(param1);
         _loc3_.manuallyDefineCullRect(param2);
         cullables.push(_loc3_);
      }
      
      public function fetchLiveTriangleCount() : int
      {
         var _loc1_:* = undefined;
         numTriangles = 0;
         for(_loc1_ in basicView.scene.children)
         {
            fetchTriangleCount(basicView.scene.children[_loc1_]);
         }
         return numTriangles;
      }
      
      public function update(param1:BasicView) : void
      {
         var _loc11_:IGardenCullable = null;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:DisplayObject3D = null;
         var _loc15_:DisplayObjectContainer3D = null;
         var _loc16_:Point = null;
         var _loc17_:Point = null;
         var _loc18_:Vector2D = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Point = null;
         var _loc26_:Point = null;
         var _loc27_:Point = null;
         var _loc28_:Point = null;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Point = null;
         var _loc38_:Point = null;
         var _loc2_:Number = param1.viewport.viewportWidth / param1.viewport.viewportHeight;
         var _loc3_:CameraObject3D = param1.camera;
         viewAng = _loc3_.fov * _loc2_ * 0.565;
         if(!cullingInited)
         {
            return;
         }
         if(!param1.camera.target)
         {
            return;
         }
         central.x = _loc3_.x;
         central.y = _loc3_.z;
         control.x = _loc3_.target.x;
         control.y = _loc3_.target.z;
         vect.x = control.x - central.x;
         vect.y = control.y - central.y;
         var _loc4_:Number = vect.angle();
         var _loc5_:Number = (_loc4_ - viewAng) * Math.PI / 180;
         var _loc6_:Number = (_loc4_ + viewAng) * Math.PI / 180;
         var _loc7_:Vector2D = new Vector2D(Math.cos(_loc5_),Math.sin(_loc5_));
         var _loc8_:Vector2D = new Vector2D(Math.cos(_loc6_),Math.sin(_loc6_));
         var _loc9_:Point = new Point(central.x + _loc7_.x * vect.length,central.y + _loc7_.y * vect.length);
         var _loc10_:Point = new Point(central.x + _loc8_.x * vect.length,central.y + _loc8_.y * vect.length);
         for each(_loc11_ in cullables)
         {
            _loc12_ = false;
            _loc13_ = 0;
            while(_loc13_ < _loc11_.points.length)
            {
               _loc16_ = _loc11_.points[_loc13_];
               if(!_loc12_)
               {
                  if(_loc11_.points.length != 1)
                  {
                     _loc17_ = _loc13_ != _loc11_.points.length - 1 ? _loc11_.points[_loc13_ + 1] : _loc11_.points[0];
                     _loc18_ = new Vector2D(_loc17_.x - _loc16_.x,_loc17_.y - _loc16_.y);
                     _loc19_ = _loc16_.y - central.y;
                     _loc20_ = _loc16_.x - central.x;
                     _loc21_ = (_loc7_.x * _loc19_ - _loc7_.y * _loc20_) / (_loc7_.y * _loc18_.x - _loc7_.x * _loc18_.y);
                     _loc22_ = (_loc18_.x * _loc19_ - _loc18_.y * _loc20_) / (_loc7_.y * _loc18_.x - _loc7_.x * _loc18_.y);
                     _loc23_ = (_loc8_.x * _loc19_ - _loc8_.y * _loc20_) / (_loc8_.y * _loc18_.x - _loc8_.x * _loc18_.y);
                     _loc24_ = (_loc18_.x * _loc19_ - _loc18_.y * _loc20_) / (_loc8_.y * _loc18_.x - _loc8_.x * _loc18_.y);
                     if(_loc21_ >= 0 && _loc21_ <= 1 && _loc22_ > 0 || _loc23_ >= 0 && _loc23_ <= 1 && _loc24_ > 0)
                     {
                        _loc12_ = true;
                     }
                     if(_loc22_ > 0 && _loc24_ > 0)
                     {
                        if(_loc21_ < 0 && _loc23_ > 1 || _loc21_ > 1 && _loc23_ < 0)
                        {
                           _loc12_ = true;
                        }
                     }
                  }
                  else
                  {
                     _loc25_ = new Point(_loc16_.x,_loc16_.y);
                     _loc26_ = _loc25_.subtract(central);
                     _loc27_ = _loc9_.subtract(central);
                     _loc28_ = _loc10_.subtract(central);
                     _loc29_ = _loc27_.x * _loc27_.x + _loc27_.y * _loc27_.y;
                     _loc30_ = _loc27_.x * _loc28_.x + _loc27_.y * _loc28_.y;
                     _loc31_ = _loc28_.x * _loc28_.x + _loc28_.y * _loc28_.y;
                     _loc32_ = 1 / (_loc29_ * _loc31_ - _loc30_ * _loc30_);
                     _loc33_ = _loc27_.x * _loc26_.x + _loc27_.y * _loc26_.y;
                     _loc34_ = _loc28_.x * _loc26_.x + _loc28_.y * _loc26_.y;
                     _loc35_ = (_loc31_ * _loc33_ - _loc30_ * _loc34_) * _loc32_;
                     _loc36_ = (_loc29_ * _loc34_ - _loc30_ * _loc33_) * _loc32_;
                     _loc37_ = _loc7_.getClosestPointOnLine(central,_loc25_);
                     _loc38_ = _loc8_.getClosestPointOnLine(central,_loc25_);
                     if(_loc35_ > 0 && _loc36_ > 0)
                     {
                        _loc12_ = true;
                     }
                     else if(_loc35_ + _loc36_ > 0)
                     {
                        if(_loc11_.checkIsIn(_loc37_.subtract(_loc25_).length,_loc38_.subtract(_loc25_).length))
                        {
                           _loc12_ = true;
                        }
                     }
                  }
               }
               _loc13_++;
            }
            _loc14_ = _loc11_.referringDisplayObject3D;
            _loc15_ = _loc11_.referringDisplayObject3DParent;
            if(_loc12_)
            {
               if(_loc15_.getChildByName(_loc14_.name) === null)
               {
                  _loc15_.addChild(_loc14_);
               }
            }
            else if(_loc15_.getChildByName(_loc14_.name) !== null)
            {
               _loc15_.removeChild(_loc14_);
            }
         }
      }
      
      public function get cullingInited() : Boolean
      {
         return _cullingInited;
      }
   }
}

