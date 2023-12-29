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
        public Title GetById(Int32? Id)
        {
            var obj = new { Title_Code = Id.Value };
            return base.GetById<Title,Title_Country,Title_Talent,Title_Geners>(obj);
        }

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
            ObjTitleReturn.assets = base.ExecuteSQLProcedure<title_List>("USPAPI_Title_List", param).ToList();
            ObjTitleReturn.paging.total= param.Get<Int64>("@RecordCount");
            return ObjTitleReturn;
        }

        public List<USPAPI_Title_Bind_Extend_Data> USPAPI_Title_Bind_Extend_Data(Nullable<int> title_Code)
        {
            List<USPAPI_Title_Bind_Extend_Data> ObjExtended = new List<USPAPI_Title_Bind_Extend_Data>();

            var param = new DynamicParameters();
            param.Add("@Title_Code", title_Code);
            ObjExtended = base.ExecuteSQLProcedure<USPAPI_Title_Bind_Extend_Data>("USPAPI_Title_Bind_Extend_Data", param).ToList();            
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
            ObjTitleReturn = base.ExecuteSQLProcedure<title>("USPAPI_Title_List", param).FirstOrDefault();            
            return ObjTitleReturn;
        }

        public Title_Validations Title_Validation(string InputValue,string InputType)
        {
            var param = new DynamicParameters();

            param.Add("@InputValue", InputValue);
            param.Add("@InputType", InputType);
            return base.ExecuteSQLProcedure<Title_Validations>("USPAPI_Title_Validations", param).FirstOrDefault();
        }
    }

}
