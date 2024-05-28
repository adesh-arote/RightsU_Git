using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_DAL
{
    public abstract class RightsU_Repository<T> where T : class
    {
        private string _conStr;
        public string conStr
        {
            get { return _conStr; }
            set { _conStr = value; }
        }

        private RightsU_NeoEntities dataContext;
        private readonly IDbSet<T> dbset;
        protected RightsU_Repository(string conString)
        {
            conStr = conString;
            DatabaseFactory = new DatabaseFactory();
            dataContext = DataContext;
            dbset = dataContext.Set<T>();
        }

        protected DatabaseFactory DatabaseFactory
        {
            get;
            private set;
        }

        public RightsU_NeoEntities DataContext
        {
            get { return dataContext ?? (dataContext = DatabaseFactory.Get(conStr)); }
        }
        public virtual void Save(T entity)
        {
            dbset.Add(entity);
            dataContext.Commit();
        }
        public virtual void Update(T entity)
        {
            dbset.Attach(entity);
            dataContext.Entry(entity).State = EntityState.Modified;
            dataContext.Commit();
        }
        public virtual void Delete(T entity)
        {
            dbset.Remove(entity);            
            dataContext.Commit();
        }
        public virtual void Delete(Expression<Func<T, bool>> where)
        {
            IQueryable<T> objects = dbset.Where<T>(where);            
            foreach (T obj in objects)
                dbset.Remove(obj);

            dataContext.Commit();
        }
        public virtual T GetById(long id)
        {            
            return dbset.Find(id);
        }
        public virtual T GetById(string id)
        {
            return dbset.Find(id);
        }
        public virtual IQueryable<T> GetAll()
        {
            return dbset;
        }

        public virtual IQueryable<T> SearchFor(Expression<Func<T, bool>> where)
        {
            return dbset.Where(where);
        }

        /// <summary>
        /// Return a paged list of entities
        /// </summary>
        /// <typeparam name="TOrder"></typeparam>
        /// <param name="page">Which page to retrieve</param>
        /// <param name="where">Where clause to apply</param>
        /// <param name="order">Order by to apply</param>
        /// <returns></returns>
        //public virtual IPagedList<T> GetPage<TOrder>(Page page, Expression<Func<T, bool>> where, Expression<Func<T, TOrder>> order)
        //{
        //    var results = dbset.OrderBy(order).Where(where).GetPage(page).ToList();
        //    var total = dbset.Count(where);
        //    return new StaticPagedList<T>(results, page.PageNumber, page.PageSize, total);
        //}

        public T Get(Expression<Func<T, bool>> where)
        {
            return dbset.Where(where).FirstOrDefault<T>();
        }
    }
}
