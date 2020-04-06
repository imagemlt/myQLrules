import javascript

/**
 * Gets a warning message for `pref` if one of the `nodeIntegration` features is enabled.
 */

class ReactSetHrefSinks extends DataFlow::Node {
   ReactSetHrefSinks() {
    exists(JSXAttribute attr |
      attr.getName() = "href" and attr.getValue() = this.asExpr()
    )

  }
}

class ReactSetHrefTracker extends TaintTracking::Configuration{
    ReactSetHrefTracker() {
        this = "ReactSetHrefTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       exists(|
       not (nd.asExpr() instanceof ConstantExpr)
       and not exists(nd.toString().toLowerCase().indexOf("icon"))
       )
       //any()
    }

    override predicate isSink(DataFlow::Node nd){
      nd instanceof ReactSetHrefSinks
    }

    /*override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(DataFlow::ObjectLiteralNode obj, DataFlow::Node html_value |
        obj.hasPropertyWrite("__html", html_value) and
        succ = obj and
        pred = html_value
        )
    }*/
}



from ReactSetHrefTracker pt, DataFlow::Node source, DataFlow::Node sink
where pt.hasFlow(source, sink)
select source,sink

/*
from ObjectExpr ob, Property value
where value = ob.getPropertyByName("nodeIntegration")
select ob,value
*/