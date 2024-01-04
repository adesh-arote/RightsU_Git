using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class ProgramRepositories : MainRepository<Program>
    {
        public Program GetById(Int32? Id)
        {
            var obj = new { Program_Code = Id.Value };
            return base.GetById<Program>(obj);
        }
        public void Update(Program entity)
        {
            Program oldObj = GetById(entity.Program_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public ProgramReturn GetProgram_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            ProgramReturn ObjProgramReturn = new ProgramReturn();

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
            ObjProgramReturn.content = base.ExecuteSQLProcedure<Program_List>("USPAPI_Program_List", param).ToList();
            ObjProgramReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjProgramReturn;
        }
    }
}
