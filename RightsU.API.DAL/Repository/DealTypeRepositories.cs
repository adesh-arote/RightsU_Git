using System;
using Dapper;
using RightsU.API.Entities;
using System.Collections.Generic;
using System.Linq;

namespace RightsU.API.DAL.Repository
{
    //public class DealTypeRepositories: MainRepository<dealType>
    //{
    //    public Deal_TypeReturn GetDealType_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
    //    {
    //        Deal_TypeReturn ObjDealTypeReturn = new Deal_TypeReturn();

    //        var param = new DynamicParameters();
    //        param.Add("@order", order);
    //        param.Add("@page", page);
    //        param.Add("@search_value", search_value);
    //        param.Add("@size", size);
    //        param.Add("@sort", sort);
    //        param.Add("@date_gt", Date_GT);
    //        param.Add("@date_lt", Date_LT);
    //        param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
    //        param.Add("@id", id);
    //        ObjDealTypeReturn.assets = base.ExecuteSQLProcedure<dealType>("[USPAPI_Deal_Type]", param).ToList();
    //        ObjDealTypeReturn.paging.total = param.Get<Int64>("@RecordCount");
    //        return ObjDealTypeReturn;
    //    }
    //}
}
