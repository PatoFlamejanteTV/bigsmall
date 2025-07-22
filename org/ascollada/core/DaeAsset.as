package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeAsset extends DaeEntity
   {
      
      public var yUp:String;
      
      public var unit_name:String;
      
      public var contributors:Array;
      
      public var modified:String;
      
      public var keywords:String;
      
      public var subject:String;
      
      public var unit_meter:Number;
      
      public var created:String;
      
      public var revision:String;
      
      public var title:String;
      
      public function DaeAsset(param1:XML = null)
      {
         super(param1);
      }
      
      override public function write(param1:String = "") : String
      {
         var _loc4_:DaeContributor = null;
         var _loc2_:String = writeSimpleStartElement(ASCollada.DAE_ASSET_ELEMENT,param1);
         var _loc3_:int = 0;
         while(_loc3_ < this.contributors.length)
         {
            _loc4_ = this.contributors[_loc3_];
            _loc2_ += _loc4_.write(param1 + "\t");
            _loc3_++;
         }
         return _loc2_ + writeSimpleEndElement(ASCollada.DAE_ASSET_ELEMENT,param1);
      }
      
      private function parseContributors(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:DaeContributor = null;
         this.contributors = new Array();
         var _loc2_:XMLList = getNodeList(param1,ASCollada.DAE_CONTRIBUTOR_ASSET_ELEMENT);
         for each(_loc3_ in _loc2_)
         {
            this.contributors.push(new DaeContributor(_loc3_));
         }
         if(!this.contributors.length)
         {
            _loc4_ = new DaeContributor();
            _loc4_.author = "Tim Knip";
            _loc4_.authoring_tool = "ASCollada";
            _loc4_.comment = "";
            _loc4_.source_data = "";
            this.contributors.push(_loc4_);
         }
      }
      
      override public function read(param1:XML) : void
      {
         if(param1.localName() != ASCollada.DAE_ASSET_ELEMENT)
         {
            throw new Error("expected a \'" + ASCollada.DAE_ASSET_ELEMENT + "\' element");
         }
         super.read(param1);
         parseContributors(param1);
         this.created = getNodeContent(getNode(param1,ASCollada.DAE_CREATED_ASSET_PARAMETER));
         this.keywords = getNodeContent(getNode(param1,ASCollada.DAE_KEYWORDS_ASSET_PARAMETER));
         this.modified = getNodeContent(getNode(param1,ASCollada.DAE_MODIFIED_ASSET_PARAMETER));
         this.revision = getNodeContent(getNode(param1,ASCollada.DAE_REVISION_ASSET_PARAMETER));
         this.subject = getNodeContent(getNode(param1,ASCollada.DAE_SUBJECT_ASSET_PARAMETER));
         this.title = getNodeContent(getNode(param1,ASCollada.DAE_TITLE_ASSET_PARAMETER));
         var _loc2_:XML = getNode(param1,ASCollada.DAE_UNITS_ASSET_PARAMETER);
         this.unit_meter = _loc2_ ? getAttributeAsFloat(_loc2_,ASCollada.DAE_METERS_ATTRIBUTE,1) : 1;
         this.unit_name = _loc2_ ? getAttribute(_loc2_,ASCollada.DAE_NAME_ATTRIBUTE) : "meter";
         var _loc3_:XML = getNode(param1,ASCollada.DAE_UP);
         this.yUp = _loc3_ ? _loc3_.toString() : ASCollada.DAE_Y_UP;
      }
   }
}

