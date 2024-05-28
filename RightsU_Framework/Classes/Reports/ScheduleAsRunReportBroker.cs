using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Data.SqlClient;

public class ScheduleAsRunReportBroker : DatabaseBroker
{
    public ScheduleAsRunReportBroker() { }

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
            if (!string.IsNullOrEmpty(strSearchString))
            {
                strSql = "Exec [dbo].[usp_Schedule_AsRun_Report] '" + p1 + "','" + p2 + "',1,'" + strSearchString + "'";
            }
            else
            {
                strSql = "Exec [dbo].[usp_Schedule_AsRun_Report] '" + p1 + "','" + p2 + "',1,'" + strSearchString + "'";
            }
        }
        else
        {
            strSql = "Exec [dbo].[usp_Schedule_AsRun_Report] 0,0,0,'" + strSearchString + "'";
        }
        return strSql;

    }

    public override Persistent PopulateObject(DataRow dRow, Persistent obj)
    {
        ScheduleAsRunReport objScheduleAsRunReport;
        if (obj == null)
        {
            objScheduleAsRunReport = new ScheduleAsRunReport();
        }
        else
        {
            objScheduleAsRunReport = (ScheduleAsRunReport)obj;
        }

        #region --populate--

        if (dRow["title_code"] != DBNull.Value)
            objScheduleAsRunReport.title_code = Convert.ToInt32(dRow["title_code"]);
        if (dRow["english_title"] != DBNull.Value)
            objScheduleAsRunReport.english_title = Convert.ToString(dRow["english_title"]);
        if (dRow["deal_no"] != DBNull.Value)
            objScheduleAsRunReport.deal_no = Convert.ToString(dRow["deal_no"]);
        if (dRow["deal_movie_code"] != DBNull.Value)
            objScheduleAsRunReport.deal_movie_code = Convert.ToInt32(dRow["deal_movie_code"]);

        if (dRow["platforms"] != DBNull.Value)
            objScheduleAsRunReport.platforms = Convert.ToString(dRow["platforms"]);
        if (dRow["Rights_Period"] != DBNull.Value)
            objScheduleAsRunReport.Rights_Period = Convert.ToString(dRow["Rights_Period"]);
        if (dRow["NoOfRuns"] != DBNull.Value)
            objScheduleAsRunReport.NoOfRuns = Convert.ToString(dRow["NoOfRuns"]);
        if (dRow["Provision_Run"] != DBNull.Value)
            objScheduleAsRunReport.Provision_Run = Convert.ToString(dRow["Provision_Run"]);
        if (dRow["Actual_Run"] != DBNull.Value)
            objScheduleAsRunReport.Actual_Run = Convert.ToString(dRow["Actual_Run"]);
        if (dRow["Balance_Run"] != DBNull.Value)
            objScheduleAsRunReport.Balance_Run = Convert.ToString(dRow["Balance_Run"]);
        if (dRow["Is_Yearwise_Definition"] != DBNull.Value)
            objScheduleAsRunReport.Is_Yearwise_Definition = Convert.ToString(dRow["Is_Yearwise_Definition"]);

        #endregion
        return objScheduleAsRunReport;
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
            strSql = "Exec [dbo].[usp_Schedule_AsRun_Report] '0',10,2,'" + strSearchString + "'";
        }
        else
        {
            strSql = "Exec [dbo].[usp_Schedule_AsRun_Report] '0',10,2,''";
        }
        return strSql;
    }

    public override string GetSelectSqlOnCode(Persistent obj)
    {
        //return " SELECT * FROM [Down_Time] WHERE  down_time_code = " + obj.IntCode;
        return "";
    }




}
