import javascript

/**
 * Gets a warning message for `pref` if one of the `nodeIntegration` features is enabled.
 */

class WebPrefTracker extends TaintTracking::Configuration{
    WebPrefTracker() {
        this = "WebPrefTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       exists( DataFlow::ObjectLiteralNode obj,DataFlow::ObjectLiteralNode pref,DataFlow::Node value|
         obj.hasPropertyWrite("webPreferences",pref)
         and pref.hasPropertyWrite("nodeIntegration",value)
         and value.mayHaveBooleanValue(true)//and value.mayHaveBooleanValue(true)
         and nd = obj
       )
       //any()
    }

    override predicate isSink(DataFlow::Node nd){
        exists(InvokeExpr Ie |
          (Ie.getCalleeName() = "BrowserWindow"
          or Ie.getCalleeName() = "ElectronWindow"
          or Ie.getCalleeName() = "ShadowWindow")
          and nd.asExpr() = Ie.getArgument(0)
        )

        
    }
}



from WebPrefTracker pt, DataFlow::Node source, DataFlow::Node sink
where pt.hasFlow(source, sink)
select source,sink

/*
from ObjectExpr ob, Property value
where value = ob.getPropertyByName("nodeIntegration")
select ob,value
*/