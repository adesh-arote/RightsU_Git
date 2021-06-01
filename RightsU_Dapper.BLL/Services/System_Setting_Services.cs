using RightsU_Dapper.Entity;
using RightsU_Dapper_DAL.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class System_Parameter_NewService
    {
        private readonly System_Parameter_NewRepository objSystem_Parameter_NewRepository;

        public System_Parameter_NewService()
        {
            this.objSystem_Parameter_NewRepository = new System_Parameter_NewRepository();
        }

        public System_Parameter_New GeListByID(int ID)
        {
            return objSystem_Parameter_NewRepository.Get(ID);
        }

        public IEnumerable<System_Parameter_New> GetList()
        {
            return objSystem_Parameter_NewRepository.GetAll();
        }
        
        public IEnumerable<System_Parameter_New> SearchFor(object param)
        {
            return objSystem_Parameter_NewRepository.SearchFor(param);
        }
        public void UpdateEntity(System_Parameter_New obj)
        {
            objSystem_Parameter_NewRepository.Update(obj);
        }
    }
    //public class Security_Group_Service
    //{
    //    Security_Group_Repository objSecurity_Group_Repository = new Security_Group_Repository();
    //    public Security_Group_Service()
    //    {
    //        this.objSecurity_Group_Repository = new Security_Group_Repository();
    //    }
    //    public Security_Group GetByID(int? ID, Type[] RelationList = null)
    //    {
    //        return objSecurity_Group_Repository.Get(ID, RelationList);
    //    }
    //    public IEnumerable<Security_Group> GetAll(Type[] additionalTypes = null)
    //    {
    //        return objSecurity_Group_Repository.GetAll(additionalTypes);
    //    }
    //    public void AddEntity(Security_Group obj)
    //    {
    //        objSecurity_Group_Repository.Add(obj);
    //    }
    //    public void UpdateEntity(Security_Group obj)
    //    {
    //        objSecurity_Group_Repository.Update(obj);
    //    }
    //    public void DeleteEntity(Security_Group obj)
    //    {
    //        objSecurity_Group_Repository.Delete(obj);
    //    }
    //    public IEnumerable<Security_Group> SearchFor(object param)
    //    {
    //        return objSecurity_Group_Repository.SearchFor(param);
    //    }
    //}
    public class Security_Group_Rel_Service
    {
        Security_Group_Rel_Repository objSecurity_Group_Rel_Repository = new Security_Group_Rel_Repository();
        public Security_Group_Rel_Service()
        {
            this.objSecurity_Group_Rel_Repository = new Security_Group_Rel_Repository();
        }
        public Security_Group_Rel GetByID(int? ID, Type[] RelationList = null)
        {
            return objSecurity_Group_Rel_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Security_Group_Rel> GetAll()
        {
            return objSecurity_Group_Rel_Repository.GetAll();
        }
        public void AddEntity(Security_Group_Rel obj)
        {
            objSecurity_Group_Rel_Repository.Add(obj);
        }
        public void UpdateEntity(Security_Group_Rel obj)
        {
            objSecurity_Group_Rel_Repository.Update(obj);
        }
        public void DeleteEntity(Security_Group_Rel obj)
        {
            objSecurity_Group_Rel_Repository.Delete(obj);
        }
        public IEnumerable<Security_Group_Rel> SearchFor(object param)
        {
            return objSecurity_Group_Rel_Repository.SearchFor(param);
        }
    }
}
