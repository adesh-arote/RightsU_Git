using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class BMSDealRepositories : MainRepository<DealResult>
    {
        public IEnumerable<DealResult> GetDeals(string since,string AssetId)
        {
            var param = new DynamicParameters();
            param.Add("@since", since);
            param.Add("@AssetId", AssetId);
            IEnumerable<DealResult> lstUSPBMSGetDeals = base.ExecuteSQLProcedure<DealResult>("USP_BMS_GetDeals", param);
            return lstUSPBMSGetDeals;
        }
    }
}
