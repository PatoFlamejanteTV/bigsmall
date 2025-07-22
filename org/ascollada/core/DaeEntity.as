package org.ascollada.core
{
   import org.ascollada.ASCollada;
   import org.ascollada.namespaces.*;
   import org.ascollada.utils.StringUtil;
   
   public class DaeEntity
   {
      
      public var name:String;
      
      public var sid:String;
      
      public var id:String;
      
      public var extras:Object;
      
      public var asset:DaeAsset;
      
      public var async:Boolean;
      
      public function DaeEntity(param1:XML = null, param2:Boolean = false)
      {
         super();
         this.async = param2;
         if(param1)
         {
            read(param1);
         }
      }
      
      public function getAttributeAsFloat(param1:XML, param2:String, param3:Number = 0) : Number
      {
         var _loc4_:String = getAttribute(param1,param2);
         return isNaN(parseFloat(_loc4_)) ? param3 : parseFloat(_loc4_);
      }
      
      public function getStrings(param1:XML) : Array
      {
         return StringUtil.trim(param1.text().toString()).split(/\s+/);
      }
      
      public function getFloats(param1:XML) : Array
      {
         var _loc2_:Array = getStrings(param1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = parseFloat(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function writeSimpleStartElement(param1:String, param2:String = "") : String
      {
         return param2 + "<" + param1 + ">\n";
      }
      
      public function getBools(param1:XML) : Array
      {
         var _loc2_:Array = getStrings(param1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = _loc2_[_loc3_] == "true" ? true : false;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getAttributeAsInt(param1:XML, param2:String, param3:int = 0) : int
      {
         var _loc4_:String = getAttribute(param1,param2);
         return isNaN(parseInt(_loc4_,10)) ? param3 : int(parseInt(_loc4_,10));
      }
      
      public function getInts(param1:XML) : Array
      {
         var _loc2_:Array = getStrings(param1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = parseInt(StringUtil.trim(_loc2_[_loc3_]),10);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function read(param1:XML) : void
      {
         this.extras = new Object();
         this.id = getAttribute(param1,ASCollada.DAE_ID_ATTRIBUTE);
         this.name = getAttribute(param1,ASCollada.DAE_NAME_ATTRIBUTE);
         this.sid = getAttribute(param1,ASCollada.DAE_SID_ATTRIBUTE);
      }
      
      public function write(param1:String = "") : String
      {
         return param1;
      }
      
      public function getNodeContent(param1:XML) : String
      {
         return param1 ? param1.text().toString() : "";
      }
      
      public function getAttribute(param1:XML, param2:String, param3:Boolean = true) : String
      {
         var _loc4_:XMLList = param1.attribute(param2);
         var _loc5_:String = _loc4_.length() ? _loc4_.toString() : "";
         if(param3 && _loc5_.indexOf("#") == 0)
         {
            _loc5_ = _loc5_.split("#")[1];
         }
         return _loc5_;
      }
      
      public function getNodeById(param1:XML, param2:String, param3:String) : XML
      {
         var parent:XML = param1;
         var nodeName:String = param2;
         var id:String = param3;
         return parent..collada::[nodeName].([ASCollada.DAE_ID_ATTRIBUTE] == id)[0];
      }
      
      public function writeSimpleEndElement(param1:String, param2:String = "") : String
      {
         return param2 + "</" + param1 + ">\n";
      }
      
      public function getNodeList(param1:XML, param2:String) : XMLList
      {
         return param1.collada::[param2];
      }
      
      public function getNode(param1:XML, param2:String) : XML
      {
         return param1.collada::[param2][0];
      }
   }
}

