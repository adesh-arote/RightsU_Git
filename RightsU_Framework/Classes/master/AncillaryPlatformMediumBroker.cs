using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;

public class AncillaryPlatformMediumBroker : DatabaseBroker
{
    public AncillaryPlatformMediumBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Ancillary_Platform_Medium] where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AncillaryPlatformMedium objAncillaryPlatformMedium;
        if (obj == null)
        {
            objAncillaryPlatformMedium = new AncillaryPlatformMedium();
        }
        else
        {
            objAncillaryPlatformMedium = (AncillaryPlatformMedium)obj;
        }

        objAncillaryPlatformMedium.IntCode = Convert.ToInt32(dRow["Ancillary_Platform_Medium_Code"]);
        #region --populate--
        if (dRow["Ancillary_Platform_code"] != DBNull.Value)
            objAncillaryPlatformMedium.AncillaryPlatformCode = Convert.ToInt32(dRow["Ancillary_Platform_code"]);
        if (dRow["Ancillary_Medium_Code"] != DBNull.Value)
            objAncillaryPlatformMedium.AncillaryMediumCode = Convert.ToInt32(dRow["Ancillary_Medium_Code"]);        
        #endregion
        return objAncillaryPlatformMedium;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        AncillaryPlatformMedium objAncillaryPlatformMedium = (AncillaryPlatformMedium)obj;
        string sql = "insert into [Ancillary_Platform_Medium]([Ancillary_Platform_code], [Ancillary_Medium_Code])  values "
                + "('" + objAncillaryPlatformMedium.AncillaryPlatformCode + "', '" + objAncillaryPlatformMedium.AncillaryMediumCode + "')";
        return sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        AncillaryPlatformMedium objAncillaryPlatformMedium = (AncillaryPlatformMedium)obj;
        string sql = "update [Ancillary_Platform_Medium] set [Ancillary_Platform_code] = '" + objAncillaryPlatformMedium.AncillaryPlatformCode + "' "
                + ", [Ancillary_Medium_Code] = '" + objAncillaryPlatformMedium.AncillaryMediumCode + "' "
                + " where Ancillary_Platform_Medium_Code = '" + objAncillaryPlatformMedium.IntCode + "'";
        return sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        AncillaryPlatformMedium objAncillaryPlatformMedium = (AncillaryPlatformMedium)obj;

        string sql = " DELETE FROM [Ancillary_Platform_Medium] WHERE Ancillary_Platform_Medium_Code = " + obj.IntCode;
        return sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        //AncillaryPlatformMedium objAncillaryPlatformMedium = (AncillaryPlatformMedium)obj;
        //string sql = "Update [Ancillary_Platform_Medium] set 
        //            last_updated_time= getdate() where Ancillary_Platform_Medium_Code = '" + objAncillaryPlatformMedium.IntCode + "'";
        //return sql;
        throw new NotImplementedException();
    }

    public override string GetCountSql(string strSearchString)
    {
        string sql = " SELECT Count(*) FROM [Ancillary_Platform_Medium] WHERE 1=1 " + strSearchString;
        return sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        string sql = " SELECT * FROM [Ancillary_Platform_Medium] WHERE  Ancillary_Platform_Medium_Code = " + obj.IntCode;
        return sql;
    }
}
