using System;
using System.Data;
using System.Data.SqlClient;
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for UploadFileBroker.
/// </summary>
public class UploadFileBroker : DatabaseBroker
{
    string strSql = "";
    public UploadFileBroker()
    {
    }


    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        strSql = "";
        Criteria objCrt = ((Criteria)objCriteria);
        UploadFile objUpFile = ((UploadFile)objCrt.ClassRef);
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
            strSql = " select top " + intP1 + " * from (select top " + intP2 + " * from upload_files where file_code > 0 " + strSearchString.Trim() + " order by " + objUpFile.OrderByColumnName + " " + objUpFile.OrderByReverseCondition + ") as a1 order by " + objUpFile.OrderByColumnName + " " + objUpFile.OrderByCondition + " ";
        }
        else
        {
            strSql = "select * from Upload_Files where file_code > 0 " + strSearchString.Trim() + " order by " + objUpFile.OrderByColumnName;
        }
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        UploadFile objUpFile;
        if (obj == null)
        {
            objUpFile = new UploadFile();
        }
        else
        {
            objUpFile = (UploadFile)obj;
        }
        objUpFile.IntCode = Convert.ToInt32(dRow["file_code"]);
        if (dRow["file_name"] != DBNull.Value)
            objUpFile.fileName = Convert.ToString(dRow["file_name"]);
        try
        {
            string[] arrFileName = objUpFile.fileName.Split(new char[] { '~' }, StringSplitOptions.RemoveEmptyEntries);
            objUpFile.fileName = arrFileName[1];
        }
        catch (Exception ex)
        {
            objUpFile.fileName = Convert.ToString(dRow["file_name"]);
        }

        if (dRow["Err_YN"] != DBNull.Value)
            objUpFile.errorYN = Convert.ToString(dRow["Err_YN"]);
        if (dRow["upload_date"] != DBNull.Value)
            objUpFile.UploadedOn = Convert.ToDateTime(dRow["upload_date"]).ToString("dd/MM/yyyy");
        if (dRow["uploaded_by"] != DBNull.Value)
            objUpFile.UploadedBy = Convert.ToInt32(dRow["uploaded_by"]);
        if (dRow["upload_record_count"] != DBNull.Value)
            objUpFile.uploadRecordCount = Convert.ToInt32(dRow["upload_record_count"]);
        if (dRow["upload_type"] != DBNull.Value)
            objUpFile.uploadType = Convert.ToString(dRow["upload_type"]);
        if (dRow["pending_review_yn"] != DBNull.Value)
            objUpFile.pendingReviewYN = Convert.ToString(dRow["pending_review_yn"]);
        if (dRow["bank_code"] != DBNull.Value)
            objUpFile.bankCode = Convert.ToInt32(dRow["bank_code"]);
        if (dRow["records_inserted"] != DBNull.Value)
            objUpFile.recordsInserted = Convert.ToInt32(dRow["records_inserted"]);
        if (dRow["records_updated"] != DBNull.Value)
            objUpFile.recordsUpdated = Convert.ToInt32(dRow["records_updated"]);
        if (dRow["ChannelCode"] != DBNull.Value)
            objUpFile.channelCode = Convert.ToInt32(dRow["ChannelCode"]);


        return objUpFile;
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        /*
        int iRecCount;
        UploadFile objUpFile = (UploadFile)obj;
        strSql = "select count(1) from upload_files where file_code<>" + objUpFile.IntCode.ToString() + " and file_name='" + objUpFile.fileName.Trim().Replace("'", "''") + "'";
        if (obj.SqlTrans != null)
        {
            SqlTransaction sqlTrans = (SqlTransaction)obj.SqlTrans;
            iRecCount = (int)ProcessScalar(strSql, ref sqlTrans);
        }
        else
        {
            iRecCount = (int)ProcessScalar(strSql);
        }
        if (iRecCount > 0)
        {
            return true;
        }
        */
        return false;
    }
    public override bool Equals(object obj)
    {
        return base.Equals(obj);
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        return "";
    }

    public override string GetCountSql(string strSearchString)
    {
        strSql = "select count(1) from Upload_Files where file_code > 0 " + strSearchString.Trim();
        return strSql;
    }
    public override string GetDeleteSql(Persistent obj)
    {
        strSql = "";
        UploadFile objUpFile = (UploadFile)obj;
        strSql = " delete from Upload_Err_Detail where file_code > 0 and file_code=" + objUpFile.IntCode;
        strSql = strSql + "     delete from Upload_Files where file_code > 0 and file_code=" + objUpFile.IntCode;
        return strSql;
    }

    public override int GetHashCode()
    {
        return base.GetHashCode();
    }
    public override string GetInsertSql(Persistent obj)
    {
        UploadFile objUpFile = (UploadFile)obj;
        //strSql = "insert into upload_files(file_name,err_yn,upload_date,upload_by,upload_type,pending_review_yn,upload_record_count) values('" + objUpFile.fileName.Trim().Replace("'","''") + "','" + objUpFile.errorYN + "',getDate(),'" + objUpFile.uploadedBy  + "','" + objUpFile.uploadType + "','" + objUpFile.pendingReviewYN.Trim().Replace("'","''") + "','" + objUpFile.uploadRecordCount + "')";	
        strSql = "insert into upload_files(file_name,err_yn,upload_date,uploaded_by,upload_type,upload_record_count,bank_code,channelcode) values('" + objUpFile.fileName.Trim().Replace("'", "''") + "','" + objUpFile.errorYN + "',getDate(),'" + objUpFile.UploadedBy + "','" + objUpFile.uploadType + "','" + objUpFile.uploadRecordCount + "'," + objUpFile.bankCode + "," + objUpFile.channelCode + ")";
        return strSql;
    }
    public override string GetSelectSqlOnCode(Persistent obj)
    {
        UploadFile objUpFile = (UploadFile)obj;
        strSql = "select * from Upload_Files where file_code > 0 and file_code=" + objUpFile.IntCode;
        return strSql;
    }
    public override string GetUpdateSql(Persistent obj)
    {
        UploadFile objUpFile = (UploadFile)obj;
        strSql = "update upload_files set";
        strSql += " err_yn='" + objUpFile.errorYN.ToString().Trim().Replace("'", "''") + "',";
        strSql += " upload_record_count='" + objUpFile.uploadRecordCount + "'";
        strSql += " where file_code>0 and file_code=" + objUpFile.IntCode;
        return strSql;
    }
    public DataSet getPath(int channelCode, string Type, string parameterName)
    {
        //string sql = " Select parameter_value from system_parameter_new where type ='" + Type + "'  and channel_Code = " + channelCode + " "
        //+ " and parameter_name = '" + parameterName + "' "; 

        ////-----Chnged by dada not need to check channel code upload folder for all channel file are same.
        //string sql = " Select parameter_value from system_parameter_new where parameter_name = '" + parameterName + "' "; 

        //-----Chnged by dada On 08-NOV-2011.

        string sql = string.Empty;
        if (Type == "S")
        {
            sql = " select Schedule_Source_FilePath from Channel where channel_code  = " + channelCode + " ";
        }
        else if (Type == "A")
        {
            //sql = " select AsRun_Source_FilePath from Channel where channel_code  = " + channelCode + " ";
            sql = " Select parameter_value from system_parameter_new where parameter_name = '" + parameterName + "' "; 
        }
		else if (Type == "HU") // Added by Prashant on 09 Nov 11 for House id upload
		{
			sql = " Select parameter_value from system_parameter_new where parameter_name = '" + parameterName + "' "; 
		}

        DataSet ds = ProcessSelect(sql);
        return ds;
    }
}

