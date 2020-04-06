import javascript

class InnerHTMLSinks extends DataFlow::Node {
   InnerHTMLSinks(){
       exists(DataFlow::PropWrite pw |
       pw.getPropertyName().regexpMatch("(innerHTML|outerHTML)")
       and pw.getRhs() = this
       )
   }
}

class InnerHtmlTracker extends TaintTracking::Configuration{
    InnerHtmlTracker() {
        this = "InnerHtmlTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       not nd.asExpr() instanceof ConstantExpr
    }

    override predicate isSink(DataFlow::Node nd){
        nd instanceof InnerHTMLSinks
    }
}



from InnerHtmlTracker pt, DataFlow::Node source, DataFlow::Node sink
where pt.hasFlow(source, sink)
select source,sink
