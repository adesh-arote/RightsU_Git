using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
}
