using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for UploadErrorCodeBroker
/// </summary>
public class UploadErrorCodeBroker:DatabaseBroker 
{
        string strSql = "";
    public UploadErrorCodeBroker()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        strSql = "";
        Criteria objCrt = ((Criteria)objCriteria);
        UploadErrorCode objUEC = ((UploadErrorCode)objCrt.ClassRef);
        int intP1, intP2, inttotalPages;
        if (objCrt.IsPagingRequired)
        {
            inttotalPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(objCrt.RecordCount / objCrt.RecordPerPage)));
            if (objCrt.PageNo == 1)
            {
                intP1 = objCrt.RecordPerPage;
                intP2 = objCrt.RecordCount;
            }
            else
            {
                intP1 = objCrt.RecordPerPage;
                intP2 = Math.Abs((objCrt.RecordCount - (objCrt.RecordPerPage * (objCrt.PageNo - 1))));
            }
            strSql = " select top " + intP1 + " * from (select top " + intP2 + " * from Error_Code_Master where error_code > 0 " + strSearchString + " order by " + objUEC.OrderByColumnName + " " + objUEC.OrderByReverseCondition + ") as a1 order by " + objUEC.OrderByColumnName + " " + objUEC.OrderByCondition + " ";
        }
        else
        {
            strSql = "select * from Error_Code_Master where error_code>0 " + strSearchString + " order by " + objUEC.OrderByColumnName;
        }
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        UploadErrorCode objUploadErrorCode;
        if (obj == null)
        {
            objUploadErrorCode = new UploadErrorCode();
        }
        else
        {
            objUploadErrorCode = (UploadErrorCode)obj;
        }
        objUploadErrorCode.IntCode = Convert.ToInt32(dRow["error_code"]);
        objUploadErrorCode.uploadErrorCode = dRow["upload_error_code"].ToString().Trim();
        objUploadErrorCode.errorDescription = dRow["error_description"].ToString().Trim();
        objUploadErrorCode.errorFor = dRow["error_for"].ToString().Trim();
        return objUploadErrorCode;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }
    public override bool Equals(object obj)
    {
        return base.Equals(obj);
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        UploadErrorCode objUploadErrorCode = (UploadErrorCode)obj;
        strSql = "";
        return strSql;
    }

    public override string GetCountSql(string strSearchString)
    {

        strSql = "select count(1) from Error_Code_Master where error_code>0 " + strSearchString;
        return strSql;
    }
    public override string GetDeleteSql(Persistent obj)
    {
        UploadErrorCode objUploadErrorCode = (UploadErrorCode)obj;
        strSql = "delete from Error_Code_Master where error_code>0 and  error_code=" + objUploadErrorCode.IntCode;
        return strSql;
    }

    public override int GetHashCode()
    {
        return base.GetHashCode();
    }
    public override string GetInsertSql(Persistent obj)
    {
        UploadErrorCode objUploadErrorCode = (UploadErrorCode)obj;
        strSql = "insert into Error_Code_Master(upload_error_code,error_description,error_for) values('" + objUploadErrorCode.uploadErrorCode.Trim().Replace("'", "''") + "','" + objUploadErrorCode.errorDescription.Trim().Replace("'", "''") + "','" + objUploadErrorCode.errorFor.Trim().Replace("'", "''") + "')";
        return strSql;
    }
    public override string GetSelectSqlOnCode(Persistent obj)
    {
        UploadErrorCode objUploadErrorCode = (UploadErrorCode)obj;
        strSql = "select * from Error_Code_Master where error_code>0 and error_code=" + objUploadErrorCode.IntCode;
        return strSql;
    }
    public override string GetUpdateSql(Persistent obj)
    {
        UploadErrorCode objUploadErrorCode = (UploadErrorCode)obj;
        strSql = "update Error_Code_Master set upload_error_code='" + objUploadErrorCode.uploadErrorCode.Trim().Replace("'", "''") + "',error_description='" + objUploadErrorCode.errorDescription.Trim().Replace("'", "''") + "',error_for='" + objUploadErrorCode.errorFor.Trim().Replace("'", "''") + "' where error_code=" + objUploadErrorCode.IntCode;
        return strSql;
    }
}
