using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.DAL.Repository
{
    public class SynDealRepositories : MainRepository<Syn_Deal>
    {
        public Syn_Deal Get(int Id)
        {
            var obj = new { Syn_Deal_Code = Id };
            var entity = base.GetById<Syn_Deal, Syn_Deal_Movie>(obj);
            return entity;
        }

        public IEnumerable<Syn_Deal> GetAll()
        {
            var entity = base.GetAll<Syn_Deal, Syn_Deal_Movie>();
            return entity;
        }

        public void Add(Syn_Deal entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Syn_Deal entity)
        {
            Syn_Deal oldObj = Get(entity.Syn_Deal_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Syn_Deal entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Syn_Deal> SearchFor(object param)
        {
            var entity = base.SearchForEntity<Syn_Deal, Syn_Deal_Movie>(param);
            return entity;
        }

        public IEnumerable<Syn_Deal> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Syn_Deal>(strSQL);
        }

    }

    #region -------- Syn_Deal_Movie -----------
    public class Syn_Deal_MovieRepositories : MainRepository<Syn_Deal_Movie>
    {
        public Syn_Deal_Movie Get(int Id)
        {
            var obj = new { Syn_Deal_Movie_Code = Id };

            return base.GetById<Syn_Deal_Movie>(obj);
        }
        public IEnumerable<Syn_Deal_Movie> GetAll()
        {
            return base.GetAll<Syn_Deal_Movie>();
        }
        public void Add(Syn_Deal_Movie entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Syn_Deal_Movie entity)
        {
            Syn_Deal_Movie oldObj = Get(entity.Syn_Deal_Movie_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Syn_Deal_Movie entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Syn_Deal_Movie> SearchFor(object param)
        {
            return base.SearchForEntity<Syn_Deal_Movie>(param);
        }

        public IEnumerable<Syn_Deal_Movie> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Syn_Deal_Movie>(strSQL);
        }
    }
    #endregion
}
