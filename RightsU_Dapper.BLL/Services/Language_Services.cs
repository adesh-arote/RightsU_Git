using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Language_Services
    {
        Language_Repository objLanguage_Repository = new Language_Repository();
        public Language_Services()
        {
            this.objLanguage_Repository = new Language_Repository();
        }
        public Language GetByID(int? ID, Type[] RelationList = null)
        {
            return objLanguage_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Language> GetAll(Type[] additionalTypes = null)
        {
            return objLanguage_Repository.GetAll();
        }
        public void AddEntity(Language obj)
        {
            objLanguage_Repository.Add(obj);
        }
        public void UpdateEntity(Language obj)
        {
            objLanguage_Repository.Update(obj);
        }
        public void DeleteEntity(Language obj)
        {
            objLanguage_Repository.Delete(obj);
        }
        public IEnumerable<Language> SearchFor(object param)
        {
            return objLanguage_Repository.SearchFor(param);
        }
    }

}
