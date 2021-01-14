using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;

namespace UTOFrameWork.FrameworkClasses
{
    public class ReportColumnBroker : DatabaseBroker {

        public override string GetSelectSql(Criteria objCriteria, string strSearchString) {
            string sqlStr = "SELECT * FROM Report_Column inner join Report_Column_setup on Report_Column.Column_code = Report_Column_setup.column_Code " 
                + strSearchString
                + " order by Report_Column.sort_Ord, Report_Column_setup.display_order";
            //if (objCriteria.IsPagingRequired)
            //    return objCriteria.getPagingSQL(sqlStr);
            return sqlStr;
        }
        public override bool CanDelete(Persistent obj, out string strMessage) {
            //check dependencies here
            throw new Exception("CanDelete not implemented");
        }
        public override bool CheckDuplicate(Persistent obj) {
            return false;//no duplicate check            
        }
        public override string GetActivateDeactivateSql(Persistent obj) {
            throw new Exception("GetActivateDeactivateSql not implemented.");
        }
        public override string GetCountSql(string strSearchString) {
            throw new Exception("Not coded");
            //return "select count(Report_Column_id) from Report_Column " + strSearchString;
        }
        public override string GetDeleteSql(Persistent obj) {
            throw new Exception("Not coded");
            //return "Delete from Report_Column where Report_Column_id='" + obj.IntCode + "'";
        }
        public override string GetInsertSql(Persistent obj) {
            ReportColumn objReportColumn = (ReportColumn)obj;
            if (objReportColumn.dbValue == null)
                objReportColumn.dbValue = "";

            return "Insert into Report_Column(query_code, column_code, db_Value, is_Select, display_Ord, sort_type, sort_Ord, Agg_Function) values ('"
            + objReportColumn.queryCode 
            + "', '" + objReportColumn.columnCode
            + "', '" + objReportColumn.dbValue.Trim().Replace("'", "''") 
            + "', '" + (objReportColumn.IsSelect ? "Y" : "N") 
            + "', '" + objReportColumn.DisplayOrd + "', '" + objReportColumn.SortType.Trim()
            + "', '" + objReportColumn.SortOrd + "', '" + objReportColumn.AggFunction.Trim()
            + "')";

        }

        public override string GetSelectSqlOnCode(Persistent obj) {
            return "select * from Report_Column where Report_Column_id='" + obj.IntCode + "'";
        }
        public override string GetUpdateSql(Persistent obj) {
            //throw new Exception("Not coded");
            ReportColumn objReportColumn = (ReportColumn)obj;

            return "Update Report_Column set  db_Value='" + objReportColumn.dbValue + "'"
                        + ", is_Select='" + (objReportColumn.IsSelect == true ? "Y" : "N") + "'"
                        + ", display_Ord='" + objReportColumn.DisplayOrd + "'"
                        + ", sort_type='" + objReportColumn.SortType.Trim().Replace("'", "''") + "'"
                        + ", sort_Ord='" + objReportColumn.SortOrd + "'"
                        + ", Agg_Function='" + objReportColumn.AggFunction.Trim().Replace("'", "''") + "'"
                        + " where Report_Column_code ='" + objReportColumn.IntCode + "'";
        }
        public override Persistent PopulateObject(DataRow dRow, Persistent obj) {
            if (obj == null) {
                throw new Exception("ReportColumn PopulateObject Expects ReportQuery passed");
            }

            ReportQuery rq = (ReportQuery)obj;
            ReportColumn objReportColumn = PopulateBasic(dRow, rq); 

            objReportColumn.IntCode = Convert.ToInt32(dRow["Report_Column_code"]);
            objReportColumn.dbValue = Convert.ToString(dRow["db_Value"]);
            objReportColumn.IsSelect = (Convert.ToString(dRow["is_Select"]) == "Y");
            objReportColumn.DisplayOrd = Convert.ToInt16(dRow["display_Ord"]);
            objReportColumn.SortType = Convert.ToString(dRow["sort_type"]);
            objReportColumn.SortOrd = Convert.ToInt16(dRow["sort_Ord"]);
            objReportColumn.AggFunction = Convert.ToString(dRow["Agg_Function"]);
            objReportColumn.maxLen = Convert.ToInt32(dRow["max_length"]);
            objReportColumn.WhCondition = Convert.ToString(dRow["whCondition"]);
            objReportColumn.ValidOpList = Convert.ToString(dRow["validOpList"]);
            objReportColumn.Alternate_Config_Code = Convert.ToString(dRow["Alternate_Config_Code"]) == "" ? 0 : Convert.ToInt32(dRow["Alternate_Config_Code"]);
            
            return objReportColumn;
        }

        private ReportColumn PopulateBasic(DataRow dRow, ReportQuery rq) { 
            return new ReportColumn(rq, Convert.ToInt16(dRow["display_Order"])
                , Convert.ToInt32(dRow["Column_code"])
                , (dRow["Alternate_Config_Code"] == DBNull.Value ? 0 : Convert.ToInt32(dRow["Alternate_Config_Code"]))  
                , Convert.ToString(dRow["view_name"])
                , Convert.ToString(dRow["name_in_DB"])
                , Convert.ToString(dRow["display_Name"])
                , Convert.ToInt16(dRow["valued_as"])
                , (dRow["list_source"] == DBNull.Value ?"": Convert.ToString(dRow["list_source"]))
                , (dRow["lookup_column"] == DBNull.Value ? "" : Convert.ToString(dRow["lookup_column"]))
                , (dRow["display_column"] == DBNull.Value ? "" : Convert.ToString(dRow["display_column"]))
                , (dRow["IsPartofSelectOnly"] == DBNull.Value ? "" : Convert.ToString(dRow["IsPartofSelectOnly"]))
                , (dRow["Right_Code"] == DBNull.Value ? 0 : Convert.ToInt32(dRow["Right_Code"])), (dRow["max_length"] == DBNull.Value ? 0 : Convert.ToInt32(dRow["max_length"]))
                , (dRow["whCondition"] == DBNull.Value ? "" : Convert.ToString(dRow["whCondition"]))
                , (dRow["validOpList"] == DBNull.Value ? "" : Convert.ToString(dRow["validOpList"]))                
                );  
        }

        public List<ReportColumn> GetDefaultColumnList(ReportQuery rq) {
            List<ReportColumn> arrRptColumn = new List<ReportColumn>();
            string sql = "";

            if (rq.ViewName.Contains("*"))
                sql = "SELECT * FROM Report_Column_setup where Display_type is null AND view_Name in ('" + rq.ViewName
                    + "','" + rq.ViewName.Substring(0, rq.ViewName.IndexOf("*")) + "') order by display_order";
            else
                sql = "SELECT * FROM Report_Column_setup where Display_type is null AND view_Name ='" + rq.ViewName + "' order by display_order";
            
            DataSet ds = base.ProcessSelect(sql);

            foreach (DataRow dRow in ds.Tables[0].Rows) {
                ReportColumn objReportColumn = PopulateBasic(dRow, rq); 
                arrRptColumn.Add(objReportColumn);
            }

            if (arrRptColumn.Count < 1) {
                throw new Exception("Not coded for view:" + rq.ViewName); 
            }

            return arrRptColumn;
        }
    }
}