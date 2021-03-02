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
    }
}
