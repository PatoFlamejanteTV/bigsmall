package org.ascollada.io
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import org.ascollada.core.DaeDocument;
   import org.ascollada.utils.Logger;
   
   public class DaeReader extends EventDispatcher
   {
      
      private var _numAnimations:uint;
      
      private var _animTimer:Timer;
      
      private var _numGeometries:uint;
      
      private var _geomTimer:Timer;
      
      public var document:DaeDocument;
      
      public var async:Boolean;
      
      public function DaeReader(param1:Boolean = false)
      {
         super();
         this.async = param1;
         _animTimer = new Timer(100);
         _animTimer.addEventListener(TimerEvent.TIMER,loadNextAnimation);
         _geomTimer = new Timer(1);
         _geomTimer.addEventListener(TimerEvent.TIMER,loadNextGeometry);
      }
      
      public function loadDocument(param1:*) : DaeDocument
      {
         this.document = new DaeDocument(param1,this.async);
         _numAnimations = this.document.numQueuedAnimations;
         _numGeometries = this.document.numQueuedGeometries;
         dispatchEvent(new Event(Event.COMPLETE));
         return this.document;
      }
      
      public function readAnimations() : void
      {
         if(this.document.numQueuedAnimations > 0)
         {
            Logger.log("START READING #" + this.document.numQueuedAnimations + " ANIMATIONS");
            _animTimer.repeatCount = this.document.numQueuedAnimations + 1;
            _animTimer.delay = 100;
            _animTimer.start();
         }
         else
         {
            Logger.log("NO ANIMATIONS");
         }
      }
      
      public function readGeometries() : void
      {
         if(this.document.numQueuedGeometries > 0)
         {
            Logger.log("START READING #" + this.document.numQueuedGeometries + " GEOMETRIES");
            _geomTimer.repeatCount = this.document.numQueuedGeometries + 1;
            _geomTimer.delay = 2;
            _geomTimer.start();
         }
         else
         {
            Logger.log("NO GEOMETRIES");
         }
      }
      
      private function loadNextAnimation(param1:TimerEvent) : void
      {
         if(!this.document.readNextAnimation())
         {
            _animTimer.stop();
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,_numAnimations - this.document.numQueuedAnimations,_numAnimations));
         }
      }
      
      private function addListenersToLoader(param1:URLLoader) : void
      {
         param1.addEventListener(Event.COMPLETE,completeHandler);
         param1.addEventListener(ProgressEvent.PROGRESS,progressHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,handleIOError);
      }
      
      private function completeHandler(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         Logger.log("complete!");
         removeListenersFromLoader(_loc2_);
         loadDocument(_loc2_.data);
      }
      
      private function loadNextGeometry(param1:TimerEvent) : void
      {
         _geomTimer.stop();
         if(!this.document.readNextGeometry())
         {
            Logger.log("geometries complete");
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            Logger.log("reading next geometry");
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,_numGeometries - this.document.numQueuedGeometries,_numGeometries));
            _geomTimer.start();
         }
      }
      
      public function read(param1:String) : void
      {
         Logger.log("reading: " + param1);
         if(_animTimer.running)
         {
            _animTimer.stop();
         }
         var _loc2_:URLLoader = new URLLoader();
         addListenersToLoader(_loc2_);
         _loc2_.load(new URLRequest(param1));
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         removeListenersFromLoader(URLLoader(param1.target));
         dispatchEvent(param1);
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         if(hasEventListener(ProgressEvent.PROGRESS))
         {
            dispatchEvent(param1);
         }
      }
      
      private function removeListenersFromLoader(param1:URLLoader) : void
      {
         param1.removeEventListener(Event.COMPLETE,completeHandler);
         param1.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,handleIOError);
      }
   }
}

