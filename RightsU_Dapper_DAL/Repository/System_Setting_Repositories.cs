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
        public System_Parameter_New Get(int Id)
        {
            var obj = new { System_Parameter_News_Code = Id };
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
    }
}
