package net.pluginmedia.brain.core
{
   import net.pluginmedia.brain.core.events.PageEvent;
   import net.pluginmedia.brain.core.interfaces.IPage;
   
   public class Page extends Broadcaster implements IPage
   {
      
      protected var registeredObjs:Array = [];
      
      protected var _pageID:String;
      
      protected var _isReady:Boolean = false;
      
      protected var _pageHeight:Number = 768;
      
      protected var _pageWidth:Number = 1024;
      
      public function Page(param1:String)
      {
         super();
         _pageID = param1;
         build();
      }
      
      public function destroy() : void
      {
         _isReady = false;
         registeredObjs = null;
      }
      
      public function deactivate() : void
      {
      }
      
      public function get isTransitionReady() : Boolean
      {
         return _isReady;
      }
      
      public function get pageWidth() : Number
      {
         return _pageWidth;
      }
      
      public function prepare(param1:String = null) : void
      {
      }
      
      public function park() : void
      {
      }
      
      protected function build() : void
      {
         setReadyState();
      }
      
      public function get pageHeight() : Number
      {
         return _pageHeight;
      }
      
      public function set pageHeight(param1:Number) : void
      {
         _pageHeight = param1;
      }
      
      public function set pageWidth(param1:Number) : void
      {
         _pageWidth = param1;
      }
      
      public function get pageID() : String
      {
         return _pageID;
      }
      
      public function activate() : void
      {
      }
      
      public function initialise() : void
      {
      }
      
      protected function setReadyState() : void
      {
         _isReady = true;
         dispatchEvent(new PageEvent(PageEvent.TRANSITION_READY));
      }
   }
}

