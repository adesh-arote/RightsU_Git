using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

/// <summary>
/// Summary description for AncillaryRight
/// </summary>
public class AncillaryRightBroker : DatabaseBroker
{
	public AncillaryRightBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Ancillary_Right] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AncillaryRight objAncillaryRight;
		if (obj == null)
		{
			objAncillaryRight = new AncillaryRight();
		}
		else
		{
			objAncillaryRight = (AncillaryRight)obj;
		}

		objAncillaryRight.IntCode = Convert.ToInt32(dRow["Ancillary_Right_Code"]);
		#region --populate--
		objAncillaryRight.AncillaryRightName = Convert.ToString(dRow["Ancillary_Right_Name"]);
		if (dRow["Inserted_On"] != DBNull.Value)
            objAncillaryRight.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
		if (dRow["Inserted_By"] != DBNull.Value)
			objAncillaryRight.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
		if (dRow["Lock_Time"] != DBNull.Value)
            objAncillaryRight.LockTime = Convert.ToString(dRow["Lock_Time"]);
		if (dRow["Last_Updated_Time"] != DBNull.Value)
            objAncillaryRight.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
		if (dRow["Last_Action_By"] != DBNull.Value)
			objAncillaryRight.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
		objAncillaryRight.Is_Active = Convert.ToString(dRow["Is_Active"]);
		#endregion
		return objAncillaryRight;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        AncillaryRight objAncillaryRight = (AncillaryRight)obj;
        bool doop = DBUtil.IsDuplicate(myConnection,"Ancillary_Right", "Ancillary_Right_Name", objAncillaryRight.AncillaryRightName,"Ancillary_Right_Code",objAncillaryRight.IntCode,"Record Already Exist","");
        return doop;
    }

    public override string GetInsertSql(Persistent obj)
    {
		AncillaryRight objAncillaryRight = (AncillaryRight)obj;
		return "insert into [Ancillary_Right]([Ancillary_Right_Name], [Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values('" + objAncillaryRight.AncillaryRightName.Trim().Replace("'", "''") + "', GetDate(), '" + objAncillaryRight.InsertedBy + "',  Null, GetDate(), '" + objAncillaryRight.InsertedBy + "',  '" + objAncillaryRight.Is_Active + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		AncillaryRight objAncillaryRight = (AncillaryRight)obj;
		return "update [Ancillary_Right] set [Ancillary_Right_Name] = '" + objAncillaryRight.AncillaryRightName.Trim().Replace("'", "''") + "', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objAncillaryRight.LastActionBy + "', [Is_Active] = '" + objAncillaryRight.Is_Active + "' where Ancillary_Right_Code = '" + objAncillaryRight.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		AncillaryRight objAncillaryRight = (AncillaryRight)obj;

		return " DELETE FROM [Ancillary_Right] WHERE Ancillary_Right_Code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        AncillaryRight objAncillaryRight = (AncillaryRight)obj;
        return "Update [Ancillary_Right] set Is_Active='" + objAncillaryRight.Is_Active + "',lock_time=null, last_updated_time= getdate() where Ancillary_Right_Code = '" + objAncillaryRight.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Ancillary_Right] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Ancillary_Right] WHERE  Ancillary_Right_Code = " + obj.IntCode;
    }  
}
