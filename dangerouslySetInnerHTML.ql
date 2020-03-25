import javascript

/**
 * Gets a warning message for `pref` if one of the `nodeIntegration` features is enabled.
 */

class ReactDangerousSetInnerHTMLSinks extends DataFlow::Node {
   ReactDangerousSetInnerHTMLSinks() {
    exists(JSXAttribute attr |
      attr.getName() = "dangerouslySetInnerHTML" and attr.getValue() = this.asExpr()
    )

  }
}

class ReactSetInnerHtmlTracker extends TaintTracking::Configuration{
    ReactSetInnerHtmlTracker() {
        this = "ReactSetInnerHtmlTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       exists(|
       not (nd.asExpr() instanceof ConstantExpr)
       and nd.toString().toLowerCase().indexOf("icon") = -1)
    }

    override predicate isSink(DataFlow::Node nd){
        exists(ReactDangerousSetInnerHTMLSinks rd|
            nd = rd)
    }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(DataFlow::ObjectLiteralNode obj, DataFlow::Node html_value |
        obj.hasPropertyWrite("__html", html_value) and
        succ = obj and
        pred = html_value
        )
    }
}



from ReactSetInnerHtmlTracker pt, DataFlow::Node source, DataFlow::Node sink
where pt.hasFlow(source, sink)
select source,sink

/*
from ObjectExpr ob, Property value
where value = ob.getPropertyByName("nodeIntegration")
select ob,value
*/