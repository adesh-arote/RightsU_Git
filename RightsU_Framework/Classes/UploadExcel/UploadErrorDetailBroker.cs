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
	/// Summary description for UploadErrorDetailBroker.
	/// </summary>
	public class UploadErrorDetailBroker:DatabaseBroker
    {
        string strSql = "";
        public UploadErrorDetailBroker()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        strSql = "";
        Criteria objCrt = ((Criteria)objCriteria);
        UploadErrorDetail objUED = ((UploadErrorDetail)objCrt.ClassRef);
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
            strSql = " select top " + intP1 + " * from (select top " + intP2 + " * from Upload_Err_Detail where upload_detail_code > 0 " + strSearchString + " order by " + objUED.OrderByColumnName + " " + objUED.OrderByReverseCondition + ") as a1 order by " + objUED.OrderByColumnName + " " + objUED.OrderByCondition + " ";
        }
        else
        {
            strSql = "select * from Upload_Err_Detail where upload_detail_code > 0 " + strSearchString + " order by " + objUED.OrderByColumnName;
        }
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        UploadErrorDetail objUED;
        if (obj == null)
        {
            objUED = new UploadErrorDetail();
        }
        else
        {
            objUED = (UploadErrorDetail)obj;
        }
        objUED.uploadDetailCode = Convert.ToInt64(dRow["upload_detail_code"].ToString().Trim());
        objUED.fileCode = Convert.ToInt32(dRow["file_code"].ToString().Trim());
        objUED.rowNum = Convert.ToInt32(dRow["Row_Num"].ToString().Trim());
        objUED.rowDelimed = dRow["Row_Delimed"].ToString().Trim();
        objUED.errColumns = dRow["Err_Cols"].ToString().Trim();
        objUED.uploadType = dRow["Upload_Type"].ToString().Trim();
        return objUED;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        UploadErrorDetail objUED = (UploadErrorDetail)obj;
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        UploadErrorDetail objUED = (UploadErrorDetail)obj;
        return false;
    }
    public override bool Equals(object obj)
    {
        return base.Equals(obj);
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        UploadErrorDetail objUED = (UploadErrorDetail)obj;
        return strSql;
    }

    public override string GetCountSql(string strSearchString)
    {
        strSql = "select count(1) from Upload_Err_Detail where upload_detail_code > 0 " + strSearchString;
        return strSql;
    }
    public override string GetDeleteSql(Persistent obj)
    {
        strSql = "";
        UploadErrorDetail objUED = (UploadErrorDetail)obj;
        return strSql;
    }

    public override int GetHashCode()
    {
        return base.GetHashCode();
    }
    public override string GetInsertSql(Persistent obj)
    {
        UploadErrorDetail objUED = (UploadErrorDetail)obj;
        strSql = "insert into Upload_Err_Detail(file_code,row_num,row_delimed,Err_Cols,Upload_Type) values(" + objUED.fileCode + "," + objUED.rowNum + ",'" + objUED.rowDelimed.Trim().Replace("'", "''") + "','" + objUED.errColumns.Trim().Replace("'", "''") + "','" + objUED.uploadType.Trim().Replace("'", "''") + "')";
        return strSql;
    }
    public override string GetSelectSqlOnCode(Persistent obj)
    {
        strSql = "";
        UploadErrorDetail objUED = (UploadErrorDetail)obj;
        strSql = "select * from Upload_Err_Detail where upload_detail_code > 0 and upload_detail_code=" + objUED.uploadDetailCode;
        return null;
    }
    public override string GetUpdateSql(Persistent obj)
    {
        UploadErrorDetail objUED = (UploadErrorDetail)obj;
        strSql = "update Upload_Err_Detail set file_code=" + objUED.fileCode + ",row_num=" + objUED.rowNum + ",row_delimed='" + objUED.errColumns.Trim().Replace("'", "''") + "','" + objUED.rowDelimed.Trim().Replace("'", "''") + "','" + objUED.uploadType.Trim().Replace("'", "''") + "' where upload_detail_code > 0 and upload_detail_code=" + objUED.uploadDetailCode;
        return strSql;
    }
	}
