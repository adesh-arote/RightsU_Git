using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;

public class SAP_WBSBroker : DatabaseBroker
{
    public SAP_WBSBroker()
    {

    }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM SAP_WBS where 1=1 " + strSearchString;
        if (!objCriteria.IsPagingRequired)
            return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        SAP_WBS objSAP_WBS;
        if (obj == null)
            objSAP_WBS = new SAP_WBS();
        else
            objSAP_WBS = (SAP_WBS)obj;


        objSAP_WBS.IntCode = Convert.ToInt32(dRow["SAP_WBS_Code"]);

        if (dRow["WBS_Code"] != DBNull.Value)
            objSAP_WBS.WBS_Code = Convert.ToString(dRow["WBS_Code"]);

        if (dRow["WBS_Description"] != DBNull.Value)
            objSAP_WBS.WBS_Description = Convert.ToString(dRow["WBS_Description"]);

        if (dRow["Studio_Vendor"] != DBNull.Value)
            objSAP_WBS.Studio_Vendor = Convert.ToString(dRow["Studio_Vendor"]);

        if (dRow["Original_Dubbed"] != DBNull.Value)
            objSAP_WBS.Original_Dubbed = Convert.ToString(dRow["Original_Dubbed"]);

        if (dRow["Status"] != DBNull.Value)
            objSAP_WBS.Status = Convert.ToString(dRow["Status"]);

        if (dRow["Sport_Type"] != DBNull.Value)
            objSAP_WBS.Sport_Type = Convert.ToString(dRow["Sport_Type"]);

        if (dRow["Insert_On"] != DBNull.Value)
            objSAP_WBS.InsertedOn = Convert.ToString(dRow["Insert_On"]);

        if (dRow["File_Code"] != DBNull.Value)
            objSAP_WBS.File_Code = Convert.ToInt32(dRow["File_Code"]);
        
        return objSAP_WBS;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        SAP_WBS objSAP_WBS = (SAP_WBS)obj;

        string strQuery = "INSERT INTO SAP_WBS(WBS_Code,WBS_Description,Studio_Vendor,Original_Dubbed,Status,Sport_Type,Insert_On,File_Code) "
        + " VALUES('" + objSAP_WBS.WBS_Code.Replace("'", "''") + "', '" + objSAP_WBS.WBS_Description.Replace("'", "''") + "', '"
        + objSAP_WBS.Studio_Vendor.Replace("'", "''") + "', '" + objSAP_WBS.Original_Dubbed.Replace("'", "''") + "', '"
        + objSAP_WBS.Status.Replace("'", "''") + "', '" + objSAP_WBS.Sport_Type.Replace("'", "''") + "', GETDATE(), '" + objSAP_WBS.File_Code + "')";

        return strQuery;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        
        SAP_WBS objSAP_WBS = (SAP_WBS)obj;

        string strQuery = "UPDATE SAP_WBS SET "
        + "WBS_Code = '" + objSAP_WBS.WBS_Code.Replace("'", "''") + "',"
        + "WBS_Description = '" + objSAP_WBS.WBS_Description.Replace("'", "''") + "',"
        + "Studio_Vendor = '" + objSAP_WBS.Studio_Vendor.Replace("'", "''") + "',"
        + "Original_Dubbed = '" + objSAP_WBS.Original_Dubbed.Replace("'", "''") + "',"
        + "Status = '" + objSAP_WBS.Status.Replace("'", "''") + "',"
        + "Sport_Type = '" + objSAP_WBS.Sport_Type.Replace("'", "''") + "',"
        + "File_Code = '" + objSAP_WBS.File_Code + "',"
        + "Insert_On = GETDATE() WHERE SAP_WBS_Code = " + objSAP_WBS.IntCode;

        return strQuery;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        string strQuery = "DELETE FROM SAP_WBS WHERE SAP_WBS_Code = " + obj.IntCode;
        return strQuery;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new NotImplementedException("Method 'GetActivateDeactivateSql' not implemented of class SAP_WBSBroker");
    }

    public override string GetCountSql(string strSearchString)
    {
        return " SELECT Count(SAP_WBS_Code) FROM SAP_WBS WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        return " SELECT * FROM SAP_WBS WHERE SAP_WBS_Code = " + obj.IntCode;
    }

    public int GetIntCodeOnWBS_Code(Persistent obj)
    {
        SAP_WBS objSAP_WBS = (SAP_WBS)obj;
        int IntCode = 0;
        try
        {
            string strQuery = "SELECT ISNULL(SAP_WBS_Code, 0) AS SAP_WBS_Code FROM SAP_WBS WHERE WBS_Code = '" + objSAP_WBS.WBS_Code + "'";
            IntCode = Convert.ToInt32(ProcessScalarReturnString(strQuery));
        }
        catch(Exception)
        {
            IntCode = 0;
        }
        return IntCode;
    }

}
