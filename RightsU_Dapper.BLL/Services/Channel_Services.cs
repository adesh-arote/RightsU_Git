using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity.Master_Entities;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    //public class Channel_Service
    //{
    //    Channel_Repository objChannel_Repository = new Channel_Repository();
    //    public Channel_Service()
    //    {
    //        this.objChannel_Repository = new Channel_Repository();
    //    }
    //    public Channel GetByID(int? ID, Type[] RelationList = null)
    //    {
    //        return objChannel_Repository.Get(ID, RelationList);
    //    }
    //    public IEnumerable<Channel> GetAll(Type[] additionalTypes = null)
    //    {
    //        return objChannel_Repository.GetAll();
    //    }
    //    public void AddEntity(Channel obj)
    //    {
    //        objChannel_Repository.Add(obj);
    //    }
    //    public void UpdateEntity(Channel obj)
    //    {
    //        objChannel_Repository.Update(obj);
    //    }
    //    public void DeleteEntity(Channel obj)
    //    {
    //        objChannel_Repository.Delete(obj);
    //    }
    //    public IEnumerable<Channel> SearchFor(object param)
    //    {
    //        return objChannel_Repository.SearchFor(param);
    //    }

    //}
    public class Entity_Service
    {
        Entity_Repository objEntity_Repository = new Entity_Repository();
        public Entity_Service()
        {
            this.objEntity_Repository = new Entity_Repository();
        }
        public RightsU_Dapper.Entity.Entity GetByID(int? ID, Type[] RelationList = null)
        {
            return objEntity_Repository.Get(ID, RelationList);
        }
        public IEnumerable<RightsU_Dapper.Entity.Entity> GetAll(Type[] additionalTypes = null)
        {
            return objEntity_Repository.GetAll();
        }
        public void AddEntity(RightsU_Dapper.Entity.Entity obj)
        {
            objEntity_Repository.Add(obj);
        }
        public void UpdateEntity(RightsU_Dapper.Entity.Entity obj)
        {
            objEntity_Repository.Update(obj);
        }
        public void DeleteEntity(RightsU_Dapper.Entity.Entity obj)
        {
            objEntity_Repository.Delete(obj);
        }
        public IEnumerable<RightsU_Dapper.Entity.Entity> SearchFor(object param)
        {
            return objEntity_Repository.SearchFor(param);
        }

    }
}
