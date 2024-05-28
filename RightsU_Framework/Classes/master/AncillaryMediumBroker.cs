using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;

public class AncillaryMediumBroker : DatabaseBroker
{
	public AncillaryMediumBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Ancillary_Medium] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AncillaryMedium objAncillaryMedium;
		if (obj == null)
		{
			objAncillaryMedium = new AncillaryMedium();
		}
		else
		{
			objAncillaryMedium = (AncillaryMedium)obj;
		}

		objAncillaryMedium.IntCode = Convert.ToInt32(dRow["Ancillary_Medium_Code"]);
		#region --populate--
		objAncillaryMedium.AncillaryMediumName = Convert.ToString(dRow["Ancillary_Medium_Name"]);
		#endregion
		return objAncillaryMedium;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		AncillaryMedium objAncillaryMedium = (AncillaryMedium)obj;
		string sql= "insert into [Ancillary_Medium]([Ancillary_Medium_Name])  values "
				+ "('" + objAncillaryMedium.AncillaryMediumName.Trim().Replace("'", "''") + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
		AncillaryMedium objAncillaryMedium = (AncillaryMedium)obj;
		string sql="update [Ancillary_Medium] set [Ancillary_Medium_Name] = '" + objAncillaryMedium.AncillaryMediumName.Trim().Replace("'", "''") + "' "
				+ " where Ancillary_Medium_Code = '" + objAncillaryMedium.IntCode + "'";
		return  sql;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		AncillaryMedium objAncillaryMedium = (AncillaryMedium)obj;

		string sql= " DELETE FROM [Ancillary_Medium] WHERE Ancillary_Medium_Code = " + obj.IntCode ;
		return  sql;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        //AncillaryMedium objAncillaryMedium = (AncillaryMedium)obj;
        //string sql= "Update [Ancillary_Medium] set IsActive='" + objAncillaryMedium.IsActive + "',lock_time=null, "
        //            + " last_updated_time= getdate() where Ancillary_Medium_Code = '" + objAncillaryMedium.IntCode + "'";
        //return  sql;
        throw new NotImplementedException();
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Ancillary_Medium] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Ancillary_Medium] WHERE  Ancillary_Medium_Code = " + obj.IntCode;
		return  sql;
    }  
}
