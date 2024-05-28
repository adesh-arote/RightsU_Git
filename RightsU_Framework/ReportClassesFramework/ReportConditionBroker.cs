using System;
using System.Data;
using System.Configuration;

/// <summary>
/// Summary description for BankBroker
/// </summary>
namespace UTOFrameWork.FrameworkClasses
{
    public class ReportConditionBroker : DatabaseBroker {
        public override string GetSelectSql(Criteria objCriteria, string strSearchString) {
            string sqlStr = "SELECT * FROM Report_Condition " + strSearchString;
            //if (objCriteria.IsPagingRequired) {
            //     return objCriteria.getPagingSQL(sqlStr);
           // }

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
            //return "select count(Report_Condition_id) from Report_Condition " + strSearchString;
        }
        public override string GetDeleteSql(Persistent obj) {
            throw new Exception("Not coded");
            //return "Delete from Report_Condition where Report_Condition_id='" + obj.IntCode + "'";
        }
        public override string GetInsertSql(Persistent obj) {
            ReportCondition objReportCondition = (ReportCondition)obj;
            return "Insert into Report_Condition(query_Code, left_Col_dbname, right_Value, the_op, logical_Connect) values ('"
        + objReportCondition.queryCode + "', '" + objReportCondition.LeftColDbname 
        + "', N'" + objReportCondition.RightValue.Trim().Replace("'", "''") + "', '" + objReportCondition.theOp.Trim()
        + "', '" + objReportCondition.logicalConnect.Trim() + "')";


        }

        public override string GetSelectSqlOnCode(Persistent obj) {
            return "select * from Report_Condition where Report_Condition_id='" + obj.IntCode + "'";
        }
        public override string GetUpdateSql(Persistent obj) {
            //ReportCondition objReportCondition = (ReportCondition)obj;

            //return "Update Report_Condition set Report_Condition_code='" + objReportCondition.reportConditionCode + "'"
            //+ ", query_Code='" + objReportCondition.queryCode + "'"
            //+ ", left_Col_dbname='" + objReportCondition.leftColDbname.Trim().Replace("'", "''") + "'"
            //+ ", right_Value='" + objReportCondition.rightValue.Trim().Replace("'", "''") + "'"
            //+ ", the_op='" + objReportCondition.theOp.Trim().Replace("'", "''") + "'"
            //+ ", logical_Connect='" + objReportCondition.logicalConnect.Trim().Replace("'", "''") + "'"
            //+ " where Report_Condition_code ='" + objReportCondition.reportConditionCode + "'";
            throw new Exception("Not coded");

        }
        public override Persistent PopulateObject(DataRow dRow, Persistent obj) {
            
            if (obj == null) {
                throw new Exception("ReportCondtion PopulateObject Expects ReportQuery passed");
            }

            ReportQuery rq = (ReportQuery)obj;
            ReportColumn repCol = rq.GetReportColumn(Convert.ToString(dRow["left_Col_dbname"]), false);
            ReportCondition objReportCondition = new ReportCondition(repCol);
           
            objReportCondition.IntCode = Convert.ToInt32(dRow["Report_Condition_code"]);
            objReportCondition.LeftCol = repCol;
            repCol.isPartofWhere = true;

            objReportCondition.RightValue = Convert.ToString(dRow["right_Value"]);
            objReportCondition.theOp = Convert.ToString(dRow["the_op"]);
            objReportCondition.logicalConnect = Convert.ToString(dRow["logical_Connect"]);

            return objReportCondition;
        }

        public void DeleteABunchofRowsBroker(Persistent obj)
        {
            ReportCondition objReportCondition = (ReportCondition)obj;
            string sql = "delete from Report_condition where Query_Code =" + objReportCondition.queryCode;
            ProcessNonQuery(sql,false);
        }
    }
}