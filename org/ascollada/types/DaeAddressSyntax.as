package org.ascollada.types
{
   import org.ascollada.utils.Logger;
   
   public class DaeAddressSyntax
   {
      
      public var member:String;
      
      public var arrayMember:Array;
      
      public var isDotAccess:Boolean;
      
      public var isFullAccess:Boolean;
      
      public var targetID:String;
      
      public var isArrayAccess:Boolean;
      
      public var targetSID:String;
      
      public function DaeAddressSyntax()
      {
         super();
      }
      
      public static function parseAnimationTarget(param1:String) : DaeAddressSyntax
      {
         var _loc2_:Array = null;
         if(param1.indexOf("/") == -1)
         {
            Logger.error("[ERROR] invalid animation target attribute!");
            throw new Error("invalid animation target attribute!");
         }
         _loc2_ = param1.split("/");
         var _loc3_:DaeAddressSyntax = new DaeAddressSyntax();
         _loc3_.targetID = _loc2_[0];
         parseFullMember(_loc3_,_loc2_[1]);
         return _loc3_;
      }
      
      private static function parseFullMember(param1:DaeAddressSyntax, param2:String) : void
      {
         var _loc4_:Array = null;
         param1.isArrayAccess = param1.isDotAccess = param1.isFullAccess = false;
         param1.member = "";
         param1.arrayMember = new Array();
         var _loc3_:RegExp = /\(\d\)/ig;
         if(_loc3_.exec(param2))
         {
            param1.isArrayAccess = true;
            param1.targetSID = param2.split("(")[0];
            param1.arrayMember = param2.match(_loc3_);
         }
         else if(param2.indexOf(".") != -1)
         {
            param1.isDotAccess = true;
            _loc4_ = param2.split(".");
            param1.targetSID = _loc4_[0];
            param1.member = _loc4_[1];
         }
         else
         {
            if(!param2.length)
            {
               Logger.error("[ERROR] can\'t find a SID!");
               throw new Error("can\'t find a SID!");
            }
            param1.isFullAccess = true;
            param1.targetSID = param2;
         }
      }
      
      public function toString() : String
      {
         return "[target:" + targetID + "\nSID:" + targetSID + "\nmember:" + member + "\narrayMember:" + arrayMember + "\n" + isArrayAccess + " " + isDotAccess + " " + isFullAccess + "]";
      }
   }
}

