using System;
using System.Data;
using System.Configuration;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Web.UI.HtmlControls;
using System.Collections;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for AvailabilityExportjob
/// </summary>
public class AvailabilityExportjobBroker : DatabaseBroker
{
	public AvailabilityExportjobBroker(){ }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        string sqlStr = "SELECT AE.*, ISNULL(U.first_name, '') + ' ' + ISNULL(U.middle_Name, '') + ' ' + ISNULL(U.last_name,'') as GeneratedBy_UserName FROM [Availability_ExportJob] AE " +
            "INNER JOIN Users U ON AE.Created_By = U.users_code where 1=1 " + strSearchString;
		if (!objCriteria.IsPagingRequired)
			return sqlStr + " ORDER BY " + objCriteria.getASCstr();
		return objCriteria.getPagingSQL(sqlStr);

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        AvailabilityExportjob objAvailabilityExportjob= null;
		if (obj == null)
		{
			objAvailabilityExportjob = new AvailabilityExportjob();
		}
		else
		{
			objAvailabilityExportjob = (AvailabilityExportjob)obj;
		}

        objAvailabilityExportjob.IntCode = Convert.ToInt32(dRow["Availability_ExportJob_Code"]);
		#region --populate--
		objAvailabilityExportjob.SPName = Convert.ToString(dRow["SPName"]);
		objAvailabilityExportjob.PStrsearch = Convert.ToString(dRow["P_strSearch"]);
		objAvailabilityExportjob.PStrsearchdate = Convert.ToString(dRow["P_strSearchDate"]);
		if (dRow["P_colCount"] != DBNull.Value)
			objAvailabilityExportjob.PColcount = Convert.ToInt32(dRow["P_colCount"]);
		objAvailabilityExportjob.PStrcolumnlist = Convert.ToString(dRow["P_strColumnList"]);
        if (dRow["Created_By"] != DBNull.Value)
            objAvailabilityExportjob.InsertedBy = Convert.ToInt32(dRow["Created_By"]);
		if (dRow["Created_On"] != DBNull.Value)
			objAvailabilityExportjob.CreatedOn = Convert.ToDateTime(dRow["Created_On"]);
		if (dRow["Completed_On"] != DBNull.Value)
			objAvailabilityExportjob.CompletedOn = Convert.ToDateTime(dRow["Completed_On"]);
        if (dRow["File_Name"] != DBNull.Value)
            objAvailabilityExportjob.FileName = Convert.ToString(dRow["File_Name"]);
        if (dRow["Availability_ExportJob_Description"] != DBNull.Value)
            objAvailabilityExportjob.Remarks = Convert.ToString(dRow["Availability_ExportJob_Description"]);
        if (dRow["GeneratedBy_UserName"] != DBNull.Value)
            objAvailabilityExportjob.GeneratedBy_UserName = Convert.ToString(dRow["GeneratedBy_UserName"]);

		objAvailabilityExportjob.ISProcessed = Convert.ToString(dRow["IS_Processed"]);
		#endregion
		return objAvailabilityExportjob;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
		return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
		AvailabilityExportjob objAvailabilityExportjob = (AvailabilityExportjob)obj;
		string sql= "insert into [Availability_ExportJob]([SPName], [P_strSearch], [P_strSearchDate] "
                + ", [P_colCount], [P_strColumnList], [Created_By], [Availability_ExportJob_Description] "
				+ ")  values "
				+ "('" + objAvailabilityExportjob.SPName.Trim().Replace("'", "''") + "', '" + 
                objAvailabilityExportjob.PStrsearch.Trim().Replace("'", "''") + "', '" + 
                objAvailabilityExportjob.PStrsearchdate.Trim().Replace("'", "''") + "' " + ", '" 
                + objAvailabilityExportjob.PColcount + "', '" + objAvailabilityExportjob.PStrcolumnlist.Trim().Replace("'", "''") + "', '" +
                objAvailabilityExportjob.InsertedBy + "', '" + objAvailabilityExportjob.Remarks.Trim().Replace("'", "''") + "')";
		return  sql;
    }

    public override string GetUpdateSql(Persistent obj)
    {
        throw new NotImplementedException("'GetUpdateSql' method of 'AvailabilityExportjobBroker' class is not implemented");
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
		strMessage = "";
		return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        throw new NotImplementedException("'GetDeleteSql' method of 'AvailabilityExportjobBroker' class is not implemented");
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        throw new NotImplementedException("'GetActivateDeactivateSql' method of 'AvailabilityExportjobBroker' class is not implemented");
    }

    public override string GetCountSql(string strSearchString)
    {
		string sql= " SELECT Count(*) FROM [Availability_ExportJob] WHERE 1=1 " + strSearchString;
		return  sql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {	
		string sql= " SELECT * FROM [Availability_ExportJob] WHERE  Job_Code = " + obj.IntCode;
		return  sql;
    }  
}
