using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;

namespace RightsU_DAL
{
    /// <summary>
    /// This class is for Create Update Delete Operations (CUD) -- It sets the objects Entity State
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class Save_Entitiy_Lists_Generic<T> where T : class
    {
        public ICollection<T> SetListFlagsCUD(ICollection<T> lstForCrud, DbContext dbContext)
        {
            //lstForCrud = SetListFlagsC(lstForCrud, dbContext);
            //lstForCrud = SetListFlagsU(lstForCrud, dbContext);
            //lstForCrud = SetListFlagsD(lstForCrud, dbContext);

            lstForCrud.ToList<T>().ForEach(t =>
            {
                if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Added))
                    dbContext.Entry(t).State = EntityState.Added;
                else if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Modified))
                    dbContext.Entry(t).State = EntityState.Modified;
                else if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Deleted)
                    &&
                    GetPrimaryKeyValue(dbContext.Entry(t), dbContext) == "0"
                    )
                    lstForCrud.Remove(t);
                else if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Deleted))
                    dbContext.Entry(t).State = EntityState.Deleted;
                //else
                //    dbContext.Entry(t).State = EntityState.Unchanged;
            });

            return lstForCrud;
        }
        /// <summary>
        /// Create Method
        /// </summary>
        /// <param name="lstForCrud"></param>
        /// <param name="dbContext"></param>
        /// <returns></returns>
        //public ICollection<T> SetListFlagsC(ICollection<T> lstForCrud, DbContext dbContext)
        //{
        //    lstForCrud.ToList<T>().ForEach(t =>
        //    {
        //        if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Added))
        //            dbContext.Entry(t).State = EntityState.Added;
        //    });

        //    return lstForCrud;
        //}
        ///// <summary>
        ///// Update Method
        ///// </summary>
        ///// <param name="lstForCrud"></param>
        ///// <param name="dbContext"></param>
        ///// <returns></returns>
        //public ICollection<T> SetListFlagsU(ICollection<T> lstForCrud, DbContext dbContext)
        //{
        //    lstForCrud.ToList<T>().ForEach(t =>
        //    {
        //        if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Modified))
        //            dbContext.Entry(t).State = EntityState.Modified;
        //    });

        //    return lstForCrud;
        //}
        ///// <summary>
        ///// Delete Method
        ///// </summary>
        ///// <param name="lstForCrud"></param>
        ///// <param name="dbContext"></param>
        ///// <returns></returns>
        //public ICollection<T> SetListFlagsD(ICollection<T> lstForCrud, DbContext dbContext)
        //{
        //    //GetPrimaryKeyValue(db.Entry(dr));
        //    lstForCrud.ToList<T>().ForEach(t =>
        //    {
        //        if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Deleted)
        //            &&
        //            GetPrimaryKeyValue(dbContext.Entry(t), dbContext) == "0"
        //            )
        //            lstForCrud.Remove(t);
        //        else if (Convert.ToString(t.GetType().GetProperty("EntityState").GetValue(t, null)) == Convert.ToString(State.Deleted))
        //            dbContext.Entry(t).State = EntityState.Deleted;
        //    });

        //    return lstForCrud;
        //}

        protected string GetPrimaryKeyValue(DbEntityEntry entry, DbContext dbContext)
        {
            string str = "0";
            try
            {
                var objectStateEntry = ((IObjectContextAdapter)dbContext).ObjectContext.ObjectStateManager.GetObjectStateEntry(entry.Entity);
                str = Convert.ToString(objectStateEntry.EntityKey.EntityKeyValues[0].Value);
            }
            catch (Exception) { }
            return str;
        }

    }
}
