import javascript


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
       not (nd.asExpr() instanceof ConstantExpr)
       and not exists(nd.toString().toLowerCase().indexOf("icon"))
    }

    override predicate isSink(DataFlow::Node nd){
        nd instanceof ReactDangerousSetInnerHTMLSinks
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

