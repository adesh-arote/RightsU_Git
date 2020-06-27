using System;
using System.Data;
using System.Configuration;
using System.Web.Security;

/// <summary>
/// Summary description for ReportQueryBroker
/// </summary>
namespace UTOFrameWork.FrameworkClasses
{
    public class ReportQueryBroker : DatabaseBroker
    {
        public ReportQueryBroker()
        {

        }

        public void LoadChildren(ReportQuery repQry)
        {
            ReportColumnBroker rcolBr = new ReportColumnBroker();
            string sql = rcolBr.GetSelectSql(null, " where query_code='" + repQry.IntCode + "'");

            DataSet ds = ProcessSelect(sql);
            ReportColumn tmpCol;

            foreach (DataRow aDataRow in ds.Tables[0].Rows)
            {
                tmpCol = (ReportColumn)rcolBr.PopulateObject(aDataRow, repQry);
                repQry.AddColumn(tmpCol);
            }

            ReportConditionBroker rCondBr = new ReportConditionBroker();
            sql = rCondBr.GetSelectSql(null, " where query_code='" + repQry.IntCode + "'");

            ds = ProcessSelect(sql);
            ReportCondition tmpCond;

            foreach (DataRow aDataRow in ds.Tables[0].Rows)
            {
                tmpCond = (ReportCondition)rCondBr.PopulateObject(aDataRow, repQry);
                repQry.AddCondition(tmpCond);
            }
        }

        public override string GetSelectSql(Criteria objCriteria, string strSearchString)
        {
            string sqlStr = "SELECT * FROM Report_Query where 1=1 " + strSearchString;

            if (!objCriteria.IsPagingRequired)
                return sqlStr + " ORDER BY " + objCriteria.getASCstr();

            return objCriteria.getPagingSQL(sqlStr);
        }

        public override Persistent PopulateObject(DataRow dRow, Persistent obj)
        {
            ReportQuery objQry = (ReportQuery)obj;
            string viewName = Convert.ToString(dRow["view_name"]);

            if (obj == null)
                objQry = new ReportQuery(viewName);
            else
                objQry = (ReportQuery)obj;      //objQry.ViewName=viewName;

            objQry.IntCode = Convert.ToInt32(dRow["query_code"]);
            objQry.QueryName = Convert.ToString(dRow["Query_Name"]);

            if (dRow["Business_Unit_Code"] != DBNull.Value)
                objQry.Business_Unit_Code = Convert.ToInt32(dRow["Business_Unit_Code"]);

            if (dRow["Security_Group_Code"] != DBNull.Value)
                objQry.Security_Group_Code = Convert.ToInt32(dRow["Security_Group_Code"]);

            if (dRow["Visibility"] != DBNull.Value)
                objQry.Visibility = dRow["Visibility"].ToString();

            if (dRow["Expired_Deals"] != DBNull.Value)
                objQry.Expired_Deals = dRow["Expired_Deals"].ToString();

            if (dRow["Theatrical_Territory"] != DBNull.Value)
                objQry.Theatrical_Territory = dRow["Theatrical_Territory"].ToString();

            if (dRow["last_update_time"] != DBNull.Value)
                objQry.LastUpdatedTime = Convert.ToDateTime(dRow["last_update_time"]).ToString();

            if (dRow["Created_by"] != DBNull.Value)
                objQry.InsertedBy = Convert.ToInt32(dRow["Created_by"]);

            if (dRow["Alternate_Config_Code"] != DBNull.Value)
                objQry.Alternate_Config_Code = dRow["Alternate_Config_Code"].ToString();

            return objQry;
        }

        public override bool CheckDuplicate(Persistent obj)
        {
            ReportQuery objQry = (ReportQuery)obj;
            bool isdup = DBUtil.IsDuplicate(myConnection, "Report_Query", "query_name", objQry.QueryName, "query_Code", objQry.IntCode, "Duplicate Query Name", "", true);
            return isdup;
        }

        public override string GetInsertSql(Persistent obj)
        {
            ReportQuery objQry = (ReportQuery)obj;
            return "Insert into Report_Query(view_name, Query_Name, Business_Unit_Code, Theatrical_Territory, Expired_Deals, Security_Group_Code, Visibility, Created_by, Alternate_Config_Code) values ('"
                + objQry.ViewName + "', N'" + objQry.QueryName.Trim().Replace("'", "''") + "','"
                + objQry.Business_Unit_Code + "','" + objQry.Theatrical_Territory + "','" + objQry.Expired_Deals + "','"
                + objQry.Security_Group_Code + "','" + objQry.Visibility + "','" + objQry.InsertedBy + "','" +objQry.Alternate_Config_Code +"')";
        }

        public override string GetUpdateSql(Persistent obj)
        {
            ReportQuery objQry = (ReportQuery)obj;
            return "Update Report_Query set view_name ='" + objQry.ViewName
                + "', Query_Name =N'" + objQry.QueryName.Trim().Replace("'", "''")
                + "', Created_by = '" + objQry.InsertedBy
                + "', Business_Unit_Code = '" + objQry.Business_Unit_Code
                + "', Security_Group_Code = '" + objQry.Security_Group_Code
                + "', Visibility = '" + objQry.Visibility
                + "', Theatrical_Territory = '" + objQry.Theatrical_Territory
                + "', Expired_Deals = '" + objQry.Expired_Deals
                + "', Alternate_Config_Code = '" + objQry.Alternate_Config_Code
                + "' Where Query_Code = '" + objQry.IntCode + "'";
        }

        public override bool CanDelete(Persistent obj, out string strMessage)
        {
            strMessage = "";
            return true; //so far no depndency
        }

        public override string GetDeleteSql(Persistent obj)
        {
            ReportQuery objQry = (ReportQuery)obj;
            return "begin transaction; delete from Report_Column where query_code='" + objQry.IntCode + "';"
                + "delete from Report_condition where query_code='" + objQry.IntCode + "' "
                + "delete from Report_Query where query_code='" + objQry.IntCode + "';commit;";
        }

        public override string GetActivateDeactivateSql(Persistent obj)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string GetCountSql(string strSearchString)
        {
            return "select count(*) from Report_Query where 1=1 " + strSearchString;
        }

        public override string GetSelectSqlOnCode(Persistent obj)
        {
            return "select * from Report_Query where query_code='" + obj.IntCode + "'";
        }
    }
}
