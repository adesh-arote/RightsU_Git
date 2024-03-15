using Dapper;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.DAL.Repository
{
    //public class RoleRepositories : MainRepository<roles>
    //{
    //    public RoleReturn GetRole_List(string order, Int32 page, string search_value, Int32 size, string sort, Int32 id)
    //    {
    //        RoleReturn ObjRoleReturn = new RoleReturn();

    //        var param = new DynamicParameters();
    //        param.Add("@order", order);
    //        param.Add("@page", page);
    //        param.Add("@search_value", search_value);
    //        param.Add("@size", size);
    //        param.Add("@sort", sort);
    //        param.Add("@RecordCount", dbType: System.Data.DbType.Int64, direction: System.Data.ParameterDirection.Output);
    //        param.Add("@id", id);
    //        ObjRoleReturn.assets = base.ExecuteSQLProcedure<roles>("USPAPI_Role_List", param).ToList();
    //        ObjRoleReturn.paging.total = param.Get<Int64>("@RecordCount");
    //        return ObjRoleReturn;
    //    }
    //}
}
