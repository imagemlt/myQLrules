import javascript

/**
 * Gets a warning message for `pref` if one of the `nodeIntegration` features is enabled.
 */

class DocumentWriteSinks extends DataFlow::Node {
   DocumentWriteSinks() {
    exists(CallExpr call|
        call.getCalleeName() = "write" 
        and call.getReceiver().toString() = "document" 
        and this.asExpr() = call.getArgument(0)
    )

  }
}

class InnerHTMLSinks extends DataFlow::Node {
    InnerHTMLSinks(){
        exists(DataFlow::PropWrite pw |
        pw.getPropertyName().regexpMatch("(innerHTML|outerHTML)")
        and pw.getRhs() = this
       )
    }
}

class LocationHashSource extends DataFlow::Node {
    LocationHashSource() {
        exists(CallExpr dollarCall, PropAccess pr |
      this.asExpr() instanceof CallExpr and
      (dollarCall.getCalleeName() = "split"
       or dollarCall.getCalleeName() = "substr"
        or dollarCall.getCalleeName() = "substring"
      ) and dollarCall.getReceiver() = pr
      and  (pr.getBase().toString() = "window.location" 
      or pr.getBase().toString() = "location")
      and this.asExpr() = dollarCall
      )
    }
}

class DocumentWriteTracker extends TaintTracking::Configuration{
   DocumentWriteTracker() {
        this = "DocumentWriteTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       exists(|
       nd instanceof LocationHashSource)
    }

    override predicate isSink(DataFlow::Node nd){
        exists(|
            nd instanceof DocumentWriteSinks
            or nd instanceof InnerHTMLSinks)
    }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(CallExpr call |
        (call.getCalleeName() = "unescape"
            or call.getCalleeName() = "atob"
            or call.getCalleeName() = "decodeURI"
            or call.getCalleeName() = "decodeURIComponent"
        ) and succ.asExpr() = call and
        pred.asExpr() = call.getArgument(0)
        )
    }
}

//from LocationHashSource s,CallExpr call
//where s.asExpr() = call
//select s,call.getReceiver().toString()
from DocumentWriteTracker pt, DataFlow::Node source, DataFlow::Node sink
where pt.hasFlow(source, sink) 
select source,sink


/*
from ObjectExpr ob, Property value
where value = ob.getPropertyByName("nodeIntegration")
select ob,value
*/