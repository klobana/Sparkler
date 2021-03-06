package com.tobykurien.sparkler

import spark.Filter
import spark.Request
import spark.Response

/**
 * Implementation of Filter to accept Xtend lambdas
 */
class SFilter extends Filter {
   var (Request, Response, SFilter)=>void handler

   protected new((Request, Response, SFilter)=>void handler) {
      super()
      this.handler = handler
   }

   protected new(String path, (Request, Response, SFilter)=>void handler) {
      super(path)
      this.handler = handler
   }

   protected new(String path, String acceptType, (Request, Response, SFilter)=>void handler) {
      super(path, acceptType)
      this.handler = handler
   }

   override handle(Request req, Response res) {
      handler.apply(req, res, this)
   }
   
   def haltFilter() {
      halt
   }

   def haltFilter(int code) {
      halt(code)
   }

   def haltFilter(String body) {
      halt(body)
   }

   def haltFilter(int code, String body) {
      halt(code, body)
   }
}