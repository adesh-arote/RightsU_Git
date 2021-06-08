using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;

namespace RightsU_Dapper_DAL.Repository
{
    public class IPR_Country_Repository : MainRepository<IPR_Country>
    {
        public IPR_Country Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { IPR_Country_Code = Id };
            return base.GetById<IPR_Country>(obj, RelationList);
        }
        public void Add(IPR_Country entity)
        {
            base.AddEntity(entity);
        }
        public void Update(IPR_Country entity)
        {
            IPR_Country oldObj = Get(entity.IPR_Country_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(IPR_Country entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<IPR_Country> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<IPR_Country>(additionalTypes);
        }
        public IEnumerable<IPR_Country> SearchFor(object param)
        {
            return base.SearchForEntity<IPR_Country>(param);
        }
    }
     public class IPR_Opp_Repository : MainRepository<IPR_Opp>
    {
        public IPR_Opp Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { IPR_Opp_Code = Id };
            return base.GetById<IPR_Opp>(obj, RelationList);
        }
        public void Add(IPR_Opp entity)
        {
            base.AddEntity(entity);
        }
        public void Update(IPR_Opp entity)
        {
            IPR_Opp oldObj = Get(entity.IPR_Opp_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(IPR_Opp entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<IPR_Opp> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<IPR_Opp>(additionalTypes);
        }
        public IEnumerable<IPR_Opp> SearchFor(object param)
        {
            return base.SearchForEntity<IPR_Opp>(param);
        }
    }
    public class IPR_APP_STATUS_Repository : MainRepository<IPR_APP_STATUS>
    {
        public IPR_APP_STATUS Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { IPR_App_Status_Code = Id };
            return base.GetById<IPR_APP_STATUS>(obj, RelationList);
        }
        public void Add(IPR_APP_STATUS entity)
        {
            base.AddEntity(entity);
        }
        public void Update(IPR_APP_STATUS entity)
        {
            IPR_APP_STATUS oldObj = Get(entity.IPR_App_Status_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(IPR_APP_STATUS entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<IPR_APP_STATUS> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<IPR_APP_STATUS>(additionalTypes);
        }
        public IEnumerable<IPR_APP_STATUS> SearchFor(object param)
        {
            return base.SearchForEntity<IPR_APP_STATUS>(param);
        }
    }
    public class IPR_ENTITY_Repository : MainRepository<IPR_ENTITY>
    {
        public IPR_ENTITY Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { IPR_Entity_Code = Id };
            return base.GetById<IPR_ENTITY>(obj, RelationList);
        }
        public void Add(IPR_ENTITY entity)
        {
            base.AddEntity(entity);
        }
        public void Update(IPR_ENTITY entity)
        {
            IPR_ENTITY oldObj = Get(entity.IPR_Entity_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(IPR_ENTITY entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<IPR_ENTITY> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<IPR_ENTITY>(additionalTypes);
        }
        public IEnumerable<IPR_ENTITY> SearchFor(object param)
        {
            return base.SearchForEntity<IPR_ENTITY>(param);
        }
    }
    public class IPR_Opp_Status_Repository : MainRepository<IPR_Opp_Status>
    {
        public IPR_Opp_Status Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { IPR_Opp_Status_Code = Id };
            return base.GetById<IPR_Opp_Status>(obj, RelationList);
        }
        public void Add(IPR_Opp_Status entity)
        {
            base.AddEntity(entity);
        }
        public void Update(IPR_Opp_Status entity)
        {
            IPR_Opp_Status oldObj = Get(entity.IPR_Opp_Status_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(IPR_Opp_Status entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<IPR_Opp_Status> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<IPR_Opp_Status>(additionalTypes);
        }
        public IEnumerable<IPR_Opp_Status> SearchFor(object param)
        {
            return base.SearchForEntity<IPR_Opp_Status>(param);
        }
    }
    public class IPR_TYPE_Repository : MainRepository<IPR_TYPE>
    {
        public IPR_TYPE Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { IPR_TYPE_Code = Id };
            return base.GetById<IPR_TYPE>(obj, RelationList);
        }
        public void Add(IPR_TYPE entity)
        {
            base.AddEntity(entity);
        }
        public void Update(IPR_TYPE entity)
        {
            IPR_TYPE oldObj = Get(entity.IPR_Type_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(IPR_TYPE entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<IPR_TYPE> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<IPR_TYPE>(additionalTypes);
        }
        public IEnumerable<IPR_TYPE> SearchFor(object param)
        {
            return base.SearchForEntity<IPR_TYPE>(param);
        }
    }
    public class USP_List_IPR_Result_Repository : ProcRepository
    {
        public IEnumerable<USP_List_IPR_Result> USP_List_IPR(string tabName, string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, out int recordCount, Nullable<int> user_Code, Nullable<int> module_Code)
        {
            var param = new DynamicParameters();

            param.Add("@tabName", tabName);
            param.Add("@StrSearch", strSearch);
            param.Add("@PageNo", pageNo);
            param.Add("@OrderByCndition", orderByCndition);
            param.Add("@IsPaging", isPaging);
            param.Add("@PageSize", pageSize);
            param.Add("@User_Code", user_Code);
            param.Add("@Module_Code", module_Code);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);

            IEnumerable<USP_List_IPR_Result> lstUSP_List_IPR_Result = base.ExecuteSQLProcedure<USP_List_IPR_Result>("USP_List_IPR", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_IPR_Result;
        }
    }
    public class USP_List_IPR_Opp_Result_Repository : ProcRepository
    {
        public IEnumerable<USP_List_IPR_Opp_Result> USP_List_IPR_Opp(string ipr_For, string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, out int recordCount, Nullable<int> user_Code, Nullable<int> module_Code)
        {
            var param = new DynamicParameters();

            param.Add("@Ipr_For", ipr_For);
            param.Add("@StrSearch", strSearch);
            param.Add("@PageNo", pageNo);
            param.Add("@OrderByCndition", orderByCndition);
            param.Add("@IsPaging", isPaging);
            param.Add("@PageSize", pageSize);
            param.Add("@User_Code", user_Code);
            param.Add("@Module_Code", module_Code);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);

            IEnumerable<USP_List_IPR_Opp_Result> lstUSP_List_IPR_Opp_Result = base.ExecuteSQLProcedure<USP_List_IPR_Opp_Result>("USP_List_IPR_Opp", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_IPR_Opp_Result;
        }
    }
    public class IPR_REP_Repository : MainRepository<IPR_REP>
    {
        public IPR_REP Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { IPR_Rep_Code = Id };
            return base.GetById<IPR_REP>(obj, RelationList);
        }
        public void Add(IPR_REP entity)
        {
            base.AddEntity(entity);
        }
        public void Update(IPR_REP entity)
        {
            IPR_REP oldObj = Get(entity.IPR_Rep_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(IPR_REP entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<IPR_REP> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<IPR_REP>(additionalTypes);
        }
        public IEnumerable<IPR_REP> SearchFor(object param)
        {
            return base.SearchForEntity<IPR_REP>(param);
        }
    }
}
