using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;


    public class CostTypeMappingBroker : DatabaseBroker
    {
        public CostTypeMappingBroker() { }



        public override string GetSelectSql(Criteria objCriteria, string strSearchString)
        {
            string sqlStr = "SELECT * FROM [Paf_Cost_Type_Mapping] where 1=1 " + strSearchString;
            if (!objCriteria.IsPagingRequired)
                return sqlStr + " ORDER BY " + objCriteria.getASCstr();
            return objCriteria.getPagingSQL(sqlStr);
        }

        public override Persistent PopulateObject(System.Data.DataRow dRow, Persistent obj)
        {
            CostTypeMapping objCostTypeMapping;
            if (obj == null)
            {
                objCostTypeMapping = new CostTypeMapping();
            }
            else
            {
                objCostTypeMapping = (CostTypeMapping)obj;
            }

            objCostTypeMapping.IntCode = Convert.ToInt32(dRow["paf_ctm_code"]);
            if (dRow["paf_cost_type"] != DBNull.Value)
                objCostTypeMapping.PafCostType = Convert.ToString(dRow["paf_cost_type"]);
            if (dRow["ams_cost_type_code"] != DBNull.Value)
                objCostTypeMapping.AMSCostTypeCode = Convert.ToInt32(dRow["ams_cost_type_code"]);

            if (dRow["Is_Mapped"] != DBNull.Value)
            {
                objCostTypeMapping.IsMapped = Convert.ToChar(dRow["Is_Mapped"]);
            }
            
            objCostTypeMapping.IsAnyReference = CheckIfReferenceExists(objCostTypeMapping.IntCode);
            objCostTypeMapping.AMSCostTypeName = GetAMScostTypeName(objCostTypeMapping.IntCode);


            return objCostTypeMapping;

        }

        public override bool CheckDuplicate(Persistent obj)
        {
            return false;
        }

        public override string GetInsertSql(Persistent obj)
        {
            CostTypeMapping objCostTypeMapping = (CostTypeMapping)obj;
            return "insert into [Paf_Cost_Type_Mapping]([paf_cost_type], [ams_cost_type_code],[Is_Mapped]) values('" + objCostTypeMapping.PafCostType+"','"+objCostTypeMapping.AMSCostTypeCode+"','"+objCostTypeMapping.IsMapped+"')";
        }

        public override string GetUpdateSql(Persistent obj)
        {
            CostTypeMapping objCostTypeMapping = (CostTypeMapping)obj;
            string sql = "update [Paf_Cost_Type_Mapping] set [paf_cost_type] = '" + objCostTypeMapping.PafCostType + "', [ams_cost_type_code] = '" + objCostTypeMapping.AMSCostTypeCode + "',[Is_Mapped] ='" + objCostTypeMapping.IsMapped + "' where paf_ctm_code = '" + objCostTypeMapping.IntCode + "'";
            return sql; 
        }

        public override bool CanDelete(Persistent obj, out string strMessage)
        {
            strMessage = "";
            return true;
        }

        public override string GetDeleteSql(Persistent obj)
        {
            CostTypeMapping objCostTypeMapping = (CostTypeMapping)obj;
            return "delete from Paf_Cost_Type_Mapping where paf_ctm_code = '" + objCostTypeMapping.IntCode + "'";
        }

        public override string GetActivateDeactivateSql(Persistent obj)
        {
            throw new NotImplementedException();
        }

        public override string GetCountSql(string strSearchString)
        {
            return " SELECT Count(*) FROM [Paf_Cost_Type_Mapping] WHERE 1=1 " + strSearchString;
        }

        public override string GetSelectSqlOnCode(Persistent obj)
        {
            throw new NotImplementedException();
        }


        internal string CheckIfReferenceExists(int pafctmcode)
        {
            string result = "";
            string sql = "select   CASE when paf_cost_type_code = NULL then 'N' Else 'Y' END "+
	                     " from Paf_Cost_Type  " +
	                    " where paf_ctm_code = '"+pafctmcode+"'";
            result = ProcessScalarReturnString(sql);
            return result;
        }


        internal string GetAMScostTypeName(int pafctmcode)
        {
            string result = "";
            string sql = "select  ct.cost_type_name from Paf_Cost_Type_Mapping pctm " +
                          " inner join  Cost_Type ct on ct.cost_type_code = pctm.ams_cost_type_code  " +
                           " where pctm.paf_ctm_code = '" + pafctmcode + "'";
            result = ProcessScalarReturnString(sql);
            return result;
        }
    }

