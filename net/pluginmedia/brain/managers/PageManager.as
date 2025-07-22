package net.pluginmedia.brain.managers
{
   import flash.events.Event;
   import gs.TweenMax;
   import net.pluginmedia.brain.core.*;
   import net.pluginmedia.brain.core.events.PageEvent;
   import net.pluginmedia.brain.core.interfaces.IPage;
   import net.pluginmedia.brain.core.interfaces.IPageManager;
   
   public class PageManager extends Manager implements IPageManager
   {
      
      protected var _nextPage:Page = null;
      
      protected var shareManager:ShareManager = null;
      
      protected var _pagesByID:Object = {};
      
      protected var _currentPage:Page = null;
      
      protected var _cuedPages:Array;
      
      protected var _pageHeight:Number;
      
      protected var _pageWidth:Number;
      
      public function PageManager(param1:ShareManager, param2:Number = 640, param3:Number = 480)
      {
         super();
         this.setShareManager(param1);
         _pageWidth = param2;
         _pageHeight = param3;
         _cuedPages = [];
      }
      
      protected function handleTransitionComplete(param1:Page, param2:Page) : void
      {
         if(param1)
         {
            if(contains(param1))
            {
               removeChild(param1);
            }
            param1.park();
         }
         _currentPage = param2;
         _nextPage = null;
         param2.activate();
         if(_cuedPages.length > 0)
         {
            changePage(_cuedPages.pop());
            _cuedPages = [];
         }
      }
      
      public function set pageWidth(param1:Number) : void
      {
         _pageWidth = param1;
      }
      
      protected function handleTransitionOutComplete(param1:Page, param2:Page) : void
      {
         if(contains(param1))
         {
            setChildIndex(param1,0);
         }
      }
      
      protected function handlePageReady(param1:Event) : void
      {
         _nextPage.removeEventListener(PageEvent.TRANSITION_READY,handlePageReady);
         transitionPages(_currentPage,_nextPage);
      }
      
      public function setShareManager(param1:ShareManager) : void
      {
         shareManager = param1;
      }
      
      public function get pageHeight() : Number
      {
         return _pageHeight;
      }
      
      public function getPageByID(param1:String) : IPage
      {
         BrainLogger.out("PageManager :: getPageByID:",param1,_pagesByID[param1]);
         var _loc2_:Page = _pagesByID[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         BrainLogger.out("PageManager :: getPageByID - could not find ID:",param1);
         return null;
      }
      
      public function changePage(param1:Page) : void
      {
         if(_nextPage)
         {
            _cuedPages.push(param1);
            return;
         }
         _nextPage = param1;
         if(_nextPage == _currentPage)
         {
            return;
         }
         if(_currentPage !== null)
         {
            if(!_currentPage.isTransitionReady)
            {
               _currentPage.removeEventListener(PageEvent.TRANSITION_READY,handlePageReady);
            }
         }
         _nextPage.prepare();
         if(_nextPage.isTransitionReady)
         {
            transitionPages(_currentPage,_nextPage);
         }
         else
         {
            _nextPage.addEventListener(PageEvent.TRANSITION_READY,handlePageReady);
         }
      }
      
      public function get nextPage() : Page
      {
         return _nextPage;
      }
      
      override public function register(param1:Object) : void
      {
         BrainLogger.out("PageManager registers page...",param1);
         super.register(param1);
         var _loc2_:IPage = param1 as IPage;
         _loc2_.pageWidth = pageWidth;
         _loc2_.pageHeight = pageHeight;
         _pagesByID[_loc2_.pageID] = _loc2_;
      }
      
      public function set pageHeight(param1:Number) : void
      {
         _pageHeight = param1;
      }
      
      public function get currentPage() : Page
      {
         return _currentPage;
      }
      
      protected function transitionPages(param1:Page, param2:Page) : void
      {
         if(!contains(param2))
         {
            addChild(param2);
            setChildIndex(param2,0);
         }
         TweenMax.to(param2,0,{"removeTint":true});
         var _loc3_:Number = _cuedPages.length > 0 ? 0.1 : 0.5;
         if(param1)
         {
            param1.deactivate();
            TweenMax.to(param1,_loc3_,{
               "tint":0,
               "onComplete":handleTransitionOutComplete,
               "onCompleteParams":[param1,param2]
            });
            TweenMax.from(param2,_loc3_,{
               "tint":0,
               "delay":_loc3_,
               "onComplete":handleTransitionComplete,
               "onCompleteParams":[param1,param2]
            });
         }
         else
         {
            TweenMax.from(param2,_loc3_,{
               "tint":0,
               "onComplete":handleTransitionComplete,
               "onCompleteParams":[param1,param2]
            });
         }
      }
      
      public function get pageWidth() : Number
      {
         return _pageWidth;
      }
      
      public function changePageByID(param1:String) : void
      {
         BrainLogger.out("CHANGE PAGE ",param1);
         var _loc2_:Page = getPageByID(param1) as Page;
         if(_loc2_ === null)
         {
            throw new Error("Cannot find page object for page ref: " + param1);
         }
         changePage(_loc2_);
      }
      
      override public function unregister(param1:Object) : Boolean
      {
         BrainLogger.out("PageManager unregisters page...",param1);
         var _loc2_:IPage = param1 as IPage;
         _loc2_.destroy();
         _pagesByID[_loc2_.pageID] = null;
         delete _pagesByID[_loc2_.pageID];
         return super.unregister(param1);
      }
   }
}

