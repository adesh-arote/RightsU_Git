using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;

public class AncillaryPlatformBroker:DatabaseBroker
{
    public  AncillaryPlatformBroker()
    {
    }
        //AncillaryPlatform


    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Ancillary_Platform] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(System.Data.DataRow dRow, Persistent obj)
    {
        AncillaryPlatform objAncillaryRight;
        if (obj == null)
        {
            objAncillaryRight = new AncillaryPlatform();
        }
        else
        {
            objAncillaryRight = (AncillaryPlatform)obj;
        }

        objAncillaryRight.IntCode = Convert.ToInt32(dRow["Ancillary_Platform_code"]);
        objAncillaryRight.AncillaryTypeCode = Convert.ToInt32(dRow["Ancillary_Type_code"]);
        if (dRow["Platform_code"] != DBNull.Value)
            objAncillaryRight.PlatformCode = Convert.ToInt32(dRow["Platform_code"]);
        objAncillaryRight.PlatformName = Convert.ToString(dRow["Platform_Name"]);
        return objAncillaryRight;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetInsertSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetUpdateSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        throw new NotImplementedException();
    }

    public override string GetDeleteSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new NotImplementedException();
    }

    public override string GetCountSql(string strSearchString)
    {
        throw new NotImplementedException();
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Ancillary_Platform] WHERE  Ancillary_Platform_code = " + obj.IntCode;
    }
}