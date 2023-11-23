using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class TitleRepositories : MainRepository<title>
    {
        public TitleReturn GetTitle_List(string order, Int32 page, string search_value, Int32 size, string sort,string Date_GT,string Date_LT,Int32 id)
        {
            TitleReturn ObjTitleReturn = new TitleReturn();

            var param = new DynamicParameters();
            param.Add("@order", order);
            param.Add("@page", page);
            param.Add("@search_value", search_value);
            param.Add("@size", size);
            param.Add("@sort", sort);
            param.Add("@date_gt", Date_GT);
            param.Add("@date_lt", Date_LT);
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjTitleReturn.assets = base.ExecuteSQLProcedure<title>("USP_API_Title_List", param).ToList();
            ObjTitleReturn.paging.total= param.Get<Int64>("@RecordCount");
            return ObjTitleReturn;
        }

        public List<USP_Bind_Extend_Column_Grid_Result> USP_Bind_Extend_Column_Grid(Nullable<int> title_Code)
        {
            List<USP_Bind_Extend_Column_Grid_Result> ObjExtended = new List<USP_Bind_Extend_Column_Grid_Result>();

            var param = new DynamicParameters();
            param.Add("@Title_Code", title_Code);
            ObjExtended = base.ExecuteSQLProcedure<USP_Bind_Extend_Column_Grid_Result>("USP_API_Bind_Extend_Column_Grid", param).ToList();            
            return ObjExtended;
        }

        public title GetTitleById(Int32 id)
        {
            title ObjTitleReturn = new title();

            var param = new DynamicParameters();            
            //param.Add("@id", id);

            param.Add("@order", "ASC");
            param.Add("@page", 1);
            param.Add("@search_value", "");
            param.Add("@size", 1);
            param.Add("@sort", "Last_UpDated_Time");
            param.Add("@date_gt", "");
            param.Add("@date_lt", "");
            param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
            param.Add("@id", id);
            ObjTitleReturn = base.ExecuteSQLProcedure<title>("USP_API_Title_List", param).FirstOrDefault();            
            return ObjTitleReturn;
        }
    }

}
