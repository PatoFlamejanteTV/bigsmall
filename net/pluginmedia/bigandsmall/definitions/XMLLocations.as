package net.pluginmedia.bigandsmall.definitions
{
   public class XMLLocations
   {
      
      public static var prefixURL:String;
      
      public function XMLLocations()
      {
         super();
      }
      
      public static function get helperXML() : String
      {
         return prefixURL + "helpertext.xml";
      }
      
      public static function get configXML() : String
      {
         return prefixURL + "config.xml";
      }
   }
}

