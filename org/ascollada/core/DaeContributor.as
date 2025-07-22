package org.ascollada.core
{
   import org.ascollada.ASCollada;
   
   public class DaeContributor extends DaeEntity
   {
      
      public var authoring_tool:String;
      
      public var source_data:String;
      
      public var author:String;
      
      public var comment:String;
      
      public function DaeContributor(param1:XML = null)
      {
         super(param1);
      }
      
      override public function write(param1:String = "") : String
      {
         var _loc2_:String = writeSimpleStartElement(ASCollada.DAE_CONTRIBUTOR_ASSET_ELEMENT,param1);
         return _loc2_ + writeSimpleEndElement(ASCollada.DAE_CONTRIBUTOR_ASSET_ELEMENT,param1);
      }
      
      override public function read(param1:XML) : void
      {
         super.read(param1);
         var _loc2_:XML = getNode(param1,ASCollada.DAE_AUTHOR_ASSET_PARAMETER);
         var _loc3_:XML = getNode(param1,ASCollada.DAE_AUTHORINGTOOL_ASSET_PARAMETER);
         var _loc4_:XML = getNode(param1,ASCollada.DAE_COMMENTS_ASSET_PARAMETER);
         var _loc5_:XML = getNode(param1,ASCollada.DAE_SOURCEDATA_ASSET_PARAMETER);
         this.author = _loc2_ ? _loc2_.toString() : "";
         this.authoring_tool = _loc3_ ? _loc3_.toString() : "";
         this.comment = _loc4_ ? _loc4_.toString() : "";
         this.source_data = _loc5_ ? _loc5_.toString() : "";
      }
   }
}

