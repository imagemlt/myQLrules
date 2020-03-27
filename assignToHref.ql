import javascript

/**
 * Gets a warning message for `pref` if one of the `nodeIntegration` features is enabled.
 */


class InnerHTMLSinks extends DataFlow::Node {
   InnerHTMLSinks(){
       exists(DataFlow::PropWrite pw |
       pw.getPropertyName().regexpMatch("href")
       and pw.getRhs() = this
       )
   }
}

class InnerHtmlTracker extends TaintTracking::Configuration{
    InnerHtmlTracker() {
        this = "InnerHtmlTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       exists(|
       not nd.asExpr() instanceof ConstantExpr)
    }

    override predicate isSink(DataFlow::Node nd){
        exists(InnerHTMLSinks Is|
        nd = Is)
    }
}



from InnerHtmlTracker pt, DataFlow::Node source, DataFlow::Node sink
where pt.hasFlow(source, sink)
select source,sink

/*
from DataFlow::PropWrite pw,DataFlow::Node nd
where pw.getPropertyName().regexpMatch("(innerHTML|outerHTML)")
and nd = pw.getRhs()
select nd,pw
*/
/*
from ObjectExpr ob, Property value
where value = ob.getPropertyByName("nodeIntegration")
select ob,value
*/