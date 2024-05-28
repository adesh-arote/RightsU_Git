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
/// Summary description for DocumentType
/// </summary>
public class DocumentTypeBroker : DatabaseBroker
{
	public DocumentTypeBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT * FROM [Document_Type] where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        DocumentType objDocumentType;
		if (obj == null)
		{
			objDocumentType = new DocumentType();
		}
		else
		{
			objDocumentType = (DocumentType)obj;
		}

		objDocumentType.IntCode = Convert.ToInt32(dRow["Document_Type_Code"]);
		#region --populate--
		objDocumentType.DocumentTypeName = Convert.ToString(dRow["Document_Type_Name"]);
		if (dRow["Inserted_On"] != DBNull.Value)
			objDocumentType.InsertedOn = Convert.ToString(dRow["Inserted_On"]);
		if (dRow["Inserted_By"] != DBNull.Value)
			objDocumentType.InsertedBy = Convert.ToInt32(dRow["Inserted_By"]);
		if (dRow["Lock_Time"] != DBNull.Value)
            objDocumentType.LockTime = Convert.ToString(dRow["Lock_Time"]);
		if (dRow["Last_Updated_Time"] != DBNull.Value)
            objDocumentType.LastUpdatedTime = Convert.ToString(dRow["Last_Updated_Time"]);
		if (dRow["Last_Action_By"] != DBNull.Value)
			objDocumentType.LastActionBy = Convert.ToInt32(dRow["Last_Action_By"]);
		objDocumentType.Is_Active = Convert.ToString(dRow["Is_Active"]);
		#endregion
		return objDocumentType;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        DocumentType objDocumentType = (DocumentType)obj;
        return DBUtil.IsDuplicate(myConnection, objDocumentType.tableName, "Document_Type_Name ", objDocumentType.DocumentTypeName, objDocumentType.pkColName, objDocumentType.IntCode, "Record already exist", "");
    }

    public override string GetInsertSql(Persistent obj)
    {
		DocumentType objDocumentType = (DocumentType)obj;
		return "insert into [Document_Type]([Document_Type_Name], [Inserted_On], [Inserted_By], [Lock_Time], [Last_Updated_Time], [Last_Action_By], [Is_Active]) values(N'" + objDocumentType.DocumentTypeName.Trim().Replace("'", "''") + "', GetDate(), '" + objDocumentType.InsertedBy + "',  Null, GetDate(), '" + objDocumentType.InsertedBy + "',  '" + objDocumentType.Is_Active + "');";
    }

    public override string GetUpdateSql(Persistent obj)
    {
		DocumentType objDocumentType = (DocumentType)obj;
		return "update [Document_Type] set [Document_Type_Name] = N'" + objDocumentType.DocumentTypeName.Trim().Replace("'", "''") + "', [Lock_Time] = Null, [Last_Updated_Time] = GetDate(), [Last_Action_By] = '" + objDocumentType.LastActionBy + "', [Is_Active] = '" + objDocumentType.Is_Active + "' where Document_Type_Code = '" + objDocumentType.IntCode + "';";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {	
		DocumentType objDocumentType = (DocumentType)obj;

		return " DELETE FROM [Document_Type] WHERE Document_Type_Code = " + obj.IntCode ;
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        DocumentType objDocumentType = (DocumentType)obj;
return "Update [Document_Type] set Is_Active='" + objDocumentType.Is_Active + "',lock_time=null, last_updated_time= getdate() where Document_Type_Code = '" + objDocumentType.IntCode + "'";
    }

    public override string GetCountSql(string strSearchString)
    {
		return " SELECT Count(*) FROM [Document_Type] WHERE 1=1 " + strSearchString;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		return " SELECT * FROM [Document_Type] WHERE  Document_Type_Code = " + obj.IntCode;
    }  
}
