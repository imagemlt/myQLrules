import javascript

class AssignToHrefSinks extends DataFlow::Node {
   AssignToHrefSinks(){
       exists(DataFlow::PropWrite pw |
       pw.getPropertyName().regexpMatch("href")
       and pw.getRhs() = this
       )
   }
}

class AssignToHrefTracker extends TaintTracking::Configuration{
    AssignToHrefTracker() {
        this = "AssignToHrefTracker"
    }

    override predicate isSource(DataFlow::Node nd){
       not nd.asExpr() instanceof ConstantExpr
    }

    override predicate isSink(DataFlow::Node nd){
        nd instanceof AssignToHrefSinks
    }
}



from AssignToHrefTracker pt, DataFlow::Node source, DataFlow::Node sink
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