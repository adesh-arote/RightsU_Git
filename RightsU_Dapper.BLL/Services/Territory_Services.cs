using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity.Master_Entities;

namespace RightsU_Dapper.BLL.Services
{
    public class Territory_Services
    {
        Territory_Repository objTerritory_Repository = new Territory_Repository();
        public Territory_Services()
        {
            this.objTerritory_Repository = new Territory_Repository();
        }
        public Territory GetByID(int? ID, Type[] RelationList = null)
        {
            return objTerritory_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Territory> GetAll(Type[] additionalTypes = null)
        {
            return objTerritory_Repository.GetAll();
        }
        public void AddEntity(Territory obj)
        {
            objTerritory_Repository.Add(obj);
        }
        public void UpdateEntity(Territory obj)
        {
            objTerritory_Repository.Update(obj);
        }
        public void DeleteEntity(Territory obj)
        {
            objTerritory_Repository.Delete(obj);
        }
        public IEnumerable<Territory> SearchFor(object param)
        {
            return objTerritory_Repository.SearchFor(param);
        }
    }
    public class Territory_Details_Services
    {
        Territory_Details_Repository objTerritory_Details_Repository = new Territory_Details_Repository();
        public Territory_Details_Services()
        {
            this.objTerritory_Details_Repository = new Territory_Details_Repository();
        }
        public Territory_Details GetByID(int? ID, Type[] RelationList = null)
        {
            return objTerritory_Details_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Territory_Details> GetAll(Type[] additionalTypes = null)
        {
            return objTerritory_Details_Repository.GetAll();
        }
        public void AddEntity(Territory_Details obj)
        {
            objTerritory_Details_Repository.Add(obj);
        }
        public void UpdateEntity(Territory_Details obj)
        {
            objTerritory_Details_Repository.Update(obj);
        }
        public void DeleteEntity(Territory_Details obj)
        {
            objTerritory_Details_Repository.Delete(obj);
        }
        public IEnumerable<Territory_Details> SearchFor(object param)
        {
            return objTerritory_Details_Repository.SearchFor(param);
        }
    }
    public class USP_List_Territory_Service
    {
        USP_List_Territory_Repository objUSP_List_Territory_Repository = new USP_List_Territory_Repository();

        public USP_List_Territory_Service()
        {
            this.objUSP_List_Territory_Repository = new USP_List_Territory_Repository();
        }
        public IEnumerable<USP_List_Territory_Result> USP_List_Territory(Nullable<int> sysLanguageCode)
        {
            return objUSP_List_Territory_Repository.USP_List_Territory(sysLanguageCode);
        }
    }
}
