package net.pluginmedia.bigandsmall.core
{
   public class SceneChangeInfo
   {
      
      public var changeAtT2:Number;
      
      public var changeAtT1:Number;
      
      public var useTransition:String;
      
      public function SceneChangeInfo(param1:String, param2:Number, param3:Number)
      {
         super();
         useTransition = param1;
         changeAtT1 = param2;
         changeAtT2 = param3;
      }
   }
}

