package com.tobykurien.sparkler.tools

import java.io.File
import java.io.FileWriter

/**
 * Tools for working with Sparkler applications
 */
class App {
   def init(String[] args) {
      if (args.length < 0 || args.get(0).length == 0) {
         throw new Exception("Please provide the package and class, e.g. com.tobykurien.example.Example1")
      }
      
      if (args.get(0).lastIndexOf(".") <= 0) {
         throw new Exception("Invalid package format, should be something like: com.tobykurien.example.Example1")
      }
      
      var packageName = args.get(0).substring(0, args.get(0).lastIndexOf("."))
      var classPath = "src/main/java/" + packageName.replace(".", "/")
      var className = args.get(0).substring(args.get(0).lastIndexOf(".") + 1)
      
      // create the main class
      var f = new File(classPath)
      f.mkdirs
      var out = new FileWriter(classPath + "/" + className + ".xtend")
      out.write('''
package «packageName»

import spark.servlet.SparkApplication

import static com.tobykurien.sparkler.Sparkler.*

class «className» implements SparkApplication {
   
   override init() {
      // these are optional initializers, must be set before routes
      //setPort(4567) // port to bind on startup, default is 4567

      // Set up path to static files
      val workingDir = System.getProperty("user.dir")
      externalStaticFileLocation(workingDir + "/public")      
      
      // Homepage
      get("/") [req, res|
         render("views/index.html", #{})
      ]
   }
   
   def static void main(String[] args) {
      new «className»().init();
   }
}
      ''')
      out.close

      // create a sample test class
      classPath = "src/test/java/" + packageName.replace(".", "/")
      f = new File(classPath)
      f.mkdirs
      out = new FileWriter(classPath + "/" + className + "Test.xtend")
      out.write('''
package «packageName»

import com.tobykurien.sparkler.test.TestSupport
import org.junit.Test

class «className»Test extends TestSupport {
   override getModelPackageName() {
      // Where your database Model classes are
      «className».package.name 
   }
   
   @Test
   def shouldPass() {
      the("Hello message").shouldNotBeNull
   }
}
      ''')
      out.close
      
      // create the web.xml file
      var webinf = "src/main/webapp/WEB-INF"
      var f2 = new File(webinf)
      f2.mkdirs
      var out2 = new FileWriter(webinf + "/web.xml")
      out2.write('''
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">
 
    <filter>
        <filter-name>SparkFilter</filter-name>
        <filter-class>spark.servlet.SparkFilter</filter-class>
        <init-param>
            <param-name>applicationClass</param-name>
            <param-value>«packageName + "." + className»</param-value>
        </init-param>
    </filter>
   
    <filter-mapping>
      <filter-name>SparkFilter</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>

</web-app>
      ''')      
      out2.close

      // create startup script
      var out3 = new FileWriter("scripts/dev_server.sh")
      out3.write('''
#!/bin/sh
BASEDIR=$(dirname $0)

cd $BASEDIR/..

java -cp bin:libs/* -Denvironment=development «packageName + "." + className»
      ''')      
      out3.close

      // create startup script
      var out4 = new FileWriter("scripts/server.sh")
      out4.write('''
#!/bin/sh
BASEDIR=$(dirname $0)

cd $BASEDIR/..

java -cp bin:libs/* -Denvironment=production «packageName + "." + className»
      ''')      
      out4.close
   }
}