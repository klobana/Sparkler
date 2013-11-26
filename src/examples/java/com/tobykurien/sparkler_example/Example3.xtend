package com.tobykurien.sparkler_example

import spark.Filter

import static com.tobykurien.sparkler.Sparkler.*
import spark.Request
import spark.Response

/**
 * Example showing a very simple (and stupid) autentication filter that is
 * executed before all other resources.
 * 
 * When requesting the resource with e.g. 
 *     http://localhost:4567/hello?user=some&password=guy
 * the filter will stop the execution and the client will get a 401 UNAUTHORIZED with the content 'You are not welcome here'
 * 
 * When requesting the resource with e.g. 
 *     http://localhost:4567/hello?user=foo&password=bar
 * the filter will accept the request and the request will continue to the /hello route.
 * 
 * Note: There is a second "before filter" that adds a header to the response
 * Note: There is also an "after filter" that adds a header to the response
 * @see http://code.google.com/p/spark-java/#Examples
 */
class Example3 {
   var static auths = #{
      "foo" -> "bar",
      "admin" -> "admin"
   }
   
   def static void main(String[] args) {
   	before [req, res, filter|
   	   var user = req.queryParams("user")
         var password = req.queryParams("user")
         
         var dbPassword = auths.get(user)
         if (!(password != null && password.equals(dbPassword))) {
            filter.haltFilter(401, "You are not welcome here!!!")
         }
   	]
   	
   	before("/hello") [req, res, filter|
   	   res.header("Foo", "Set by second before filter")
   	]
   	
      get("/hello") [req, res|
         "Hello World!"
      ]

      after("/hello") [req, res, filter|
         res.header("spark", "added by after-filter")
      ]   	
   }
}