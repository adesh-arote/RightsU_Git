using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper_DAL.Repository
{
    public class System_Parameter_NewRepository : MainRepository<System_Parameter_New>
    {
        public System_Parameter_New Get(int? Id)
        {
            var obj = new { Id = Id };
            return base.GetById<System_Parameter_New>(obj);
        }
        public IEnumerable<System_Parameter_New> GetAll()
        {
            return base.GetAll<System_Parameter_New>();
        }

        public IEnumerable<System_Parameter_New> SearchFor(object param)
        {
            return base.SearchForEntity<System_Parameter_New>(param);
        }
        public void Update(System_Parameter_New entity)
        {
            System_Parameter_New oldObj = Get(entity.Id);
            base.UpdateEntity(oldObj, entity);
        }
    }
    public class Security_Group_Repository : MainRepository<Security_Group>
    {
        public Security_Group Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Security_Group_Code = Id };
            return base.GetById<Security_Group>(obj, RelationList);
        }
        public IEnumerable<Security_Group> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Security_Group>(additionalTypes);
        }
        public void Add(Security_Group entity)
        {
            Security_Group oldObj = Get(entity.Security_Group_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Security_Group entity)
        {
            Security_Group oldObj = Get(entity.Security_Group_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Security_Group entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Security_Group> SearchFor(object param)
        {
            return base.SearchForEntity<Security_Group>(param);
        }   
 
    }
    public class Security_Group_Rel_Repository : MainRepository<Security_Group_Rel>
    {
        public Security_Group_Rel Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Security_Rel_Code = Id };
            return base.GetById<Security_Group_Rel>(obj,RelationList);
        }
        public IEnumerable<Security_Group_Rel> GetAll()
        {
            return base.GetAll<Security_Group_Rel>();
        }
        public void Add(Security_Group_Rel entity)
        {
            Security_Group_Rel oldObj = Get(entity.Security_Rel_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Security_Group_Rel entity)
        {
            Security_Group_Rel oldObj = Get(entity.Security_Rel_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Security_Group_Rel entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Security_Group_Rel> SearchFor(object param)
        {
            return base.SearchForEntity<Security_Group_Rel>(param);
        }
    }
}
