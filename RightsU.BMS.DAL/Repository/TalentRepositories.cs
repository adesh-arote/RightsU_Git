using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class TalentRepositories : MainRepository<Talent>
    {
        public void Add(Talent entity)
        {
            base.AddEntity(entity);
        }
        public IEnumerable<Talent> GetAll()
        {
            return base.GetAll<Talent>();
        }
        public Talent GetById(Int32? Id)
        {
            var obj = new { Talent_Code = Id.Value };
            return base.GetById<Talent>(obj);
        }
        public IEnumerable<Talent> SearchFor(object param)
        {
            return base.SearchForEntity<Talent>(param);
        }
        public void Update(Talent entity)
        {
            Talent oldObj = GetById(entity.Talent_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Talent entity)
        {
            base.DeleteEntity(entity);
        }
        public TalentReturn GetTalent_List(string order, Int32 page, string search_value, Int32 size, string sort, string Date_GT, string Date_LT, Int32 id)
        {
            TalentReturn ObjTalentReturn = new TalentReturn();

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
            ObjTalentReturn.content = base.ExecuteSQLProcedure<Talent_List>("USPAPI_Talent_List", param).ToList();
            ObjTalentReturn.paging.total = param.Get<Int64>("@RecordCount");
            return ObjTalentReturn;
        }
        public Talent_Validations Talent_Validation(string InputValue, string InputType)
        {
            var param = new DynamicParameters();

            param.Add("@InputValue", InputValue);
            param.Add("@InputType", InputType);
            return base.ExecuteSQLProcedure<Talent_Validations>("USPAPI_Talent_Validations", param).FirstOrDefault();
        }
    }

    #region -------- Talent_Role -----------
    public class Talent_RoleRepositories : MainRepository<Talent_Role>
    {
        public Talent_Role Get(int Id)
        {
            var obj = new { Talent_Role_Code = Id };

            return base.GetById<Talent_Role>(obj);
        }
        public IEnumerable<Talent_Role> GetAll()
        {
            return base.GetAll<Talent_Role>();
        }
        public void Add(Talent_Role entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Talent_Role entity)
        {
            Talent_Role oldObj = Get(entity.Talent_Role_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Talent_Role entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Talent_Role> SearchFor(object param)
        {
            return base.SearchForEntity<Talent_Role>(param);
        }

        public IEnumerable<Talent_Role> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Talent_Role>(strSQL);
        }
    }
    #endregion
}
