using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Data.SqlClient;

public class ShowHouseId_DummyBroker : DatabaseBroker
{
    public ShowHouseId_DummyBroker() { }

    public override string GetSelectSql(Criteria objCriteria, string strSearchString)
    {
        //string sql = getSql();
        //string sqlStr = sql + strSearchString;
        //string sqlStr = "SELECT * FROM [Down_Time] where 1=1 " + strSearchString;
        //if (!objCriteria.IsPagingRequired)
        //    return sqlStr + " ORDER BY " + objCriteria.getASCstr();
        //return objCriteria.getPagingSQL(sqlStr);

        int p1 = objCriteria.GetPagingP1();
        int p2 = objCriteria.GetPagingP2();
        string strSql = "";

        if (objCriteria.IsPagingRequired)
        {
            strSql = "Exec [dbo].[usp_getHouseIdData] '" + p1 + "','" + p2 + "',1,'" + strSearchString + "'";
        }
        else
        {
            strSql = "Exec [dbo].[usp_getHouseIdData] 0,0,0,'" + strSearchString + "'";
        }
        return strSql;
    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ShowHouseId_Dummy objShowHouseId_Dummy;
        if (obj == null)
        {
            objShowHouseId_Dummy = new ShowHouseId_Dummy();
        }
        else
        {
            objShowHouseId_Dummy = (ShowHouseId_Dummy)obj;
        }

        #region --populate--

        if (dRow["english_title"] != DBNull.Value)
            objShowHouseId_Dummy.english_title = Convert.ToString(dRow["english_title"]);
        if (dRow["HouseID_Type_Name"] != DBNull.Value)
            objShowHouseId_Dummy.HouseID_Type_Name = Convert.ToString(dRow["HouseID_Type_Name"]);
        if (dRow["House_ID"] != DBNull.Value)
            objShowHouseId_Dummy.House_ID = Convert.ToString(dRow["House_ID"]);

        #endregion
        return objShowHouseId_Dummy;
    }

    public override bool CheckDuplicate(Persistent obj)
    {
        return false;
    }

    public override string GetInsertSql(Persistent obj)
    {
        return "";
    }

    public override string GetUpdateSql(Persistent obj)
    {
        return "";
    }

    public override bool CanDelete(Persistent obj, out string strMessage)
    {
        strMessage = "";
        return true;
    }

    public override string GetDeleteSql(Persistent obj)
    {
        return "";
    }

    public override string GetActivateDeactivateSql(Persistent obj)
    {
        return "";
    }

    public override string GetCountSql(string strSearchString)
    {
        //string sql = getSql();
        //return " SELECT Count(*) FROM (" + sql + ") a WHERE 1=1 " + strSearchString;


        string strSql = "";
        if (!string.IsNullOrEmpty(strSearchString))
        {
            strSql = "Exec [dbo].[usp_getHouseIdData] '0',10,2,'" + strSearchString + "'";
        }
        else
        {
            strSql = "Exec [dbo].[usp_getHouseIdData] '0',10,2,''";
        }
        return strSql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        //return " SELECT * FROM [Down_Time] WHERE  down_time_code = " + obj.IntCode;
        return "";
    }




}
