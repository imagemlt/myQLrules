import javascript

class WebPrefTracker extends TaintTracking::Configuration{
    WebPrefTracker() {
        this = "WebPrefTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       exists( ObjectExpr ob,ObjectExpr pref|
         pref = ob.getPropertyByName("webPreferences").getObjectExpr()
         and (not exists(pref.getPropertyByName("contextIsolation"))
         or pref.getPropertyByName("contextIsolation").getAChildExpr().flow().mayHaveBooleanValue(false))
         and nd.asExpr() =  ob.getPropertyByName("webPreferences").getObjectExpr()
       )
       or exists(ObjectExpr ob|
          not exists(ob.getPropertyByName("webPreferences"))
          and nd.asExpr() = ob
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