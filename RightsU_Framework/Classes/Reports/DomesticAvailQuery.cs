using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;
using System.Text;

public class DomesticAvailQuery : ReportQuery {
    public DomesticAvailQuery(string viewName) : base(viewName) { 

    }

    protected override void PopulateWhere(StringBuilder sbSql) {
        sbSql.Append('(');

        base.PopulateWhere(sbSql);        
        
        sbSql.Append(") and Country_code in( select Country_code from Country where is_Domestic_territory='Y')");
        sbSql.Append(" and platform_code in ( select platform_code from Platform where ISNULL(applicable_for_Demestic_territory,'N') = 'Y') "); // Added by prashant on 02 August 2011 for to show theaterical availibility report only for theaterical plaform

    }
}

