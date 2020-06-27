using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for DealType
/// </summary>
public class DealTagBroker : DatabaseBroker
{
    public DealTagBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Deal_Tag] where 1=1 " + strSearchString;

		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();

		return objCriteria.getPagingSQL(sqlStr);
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        DealTag objDealTag;
		if (obj == null)
		{
            objDealTag = new DealTag();
		}
		else
		{
            objDealTag = (DealTag)obj;
		}

        objDealTag.IntCode = Convert.ToInt32(dRow["Deal_Tag_Code"]);
		#region --populate--
        if (dRow["Deal_Tag_Description"] != DBNull.Value)
            objDealTag.DealTagDescription = Convert.ToString(dRow["Deal_Tag_Description"]);
		#endregion
        return objDealTag;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        DealTag objDealTag = (DealTag)obj;
        return "insert into [Deal_Tag]([Deal_Tag_Description]) values('" + objDealTag.DealTagDescription.Trim().Replace("'", "''") + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        DealTag objDealTag = (DealTag)obj;
        return "update [Deal_Tag] set [Deal_Tag_Description] = '" + objDealTag.DealTagDescription.Trim().Replace("'", "''") + "' where Deal_Tag_Code = '" + objDealTag.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        DealTag objDealTag = (DealTag)obj;
        return " DELETE FROM [Deal_Tag] WHERE Deal_Tag_Code = " + obj.IntCode;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new Exception("The method 'GetActivateDeactivateSql' of class 'DealTagBroker' is not implemented.");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(*) FROM [Deal_Tag] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM [Deal_Tag] WHERE  Deal_Tag_Code = " + obj.IntCode;
    }  
}
