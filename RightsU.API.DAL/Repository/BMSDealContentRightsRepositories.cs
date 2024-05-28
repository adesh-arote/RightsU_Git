using Dapper;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.DAL.Repository
{
    public class BMSDealContentRightsRepositories : MainRepository<DealContentRightsResult>
    {
        public IEnumerable<DealContentRightsResult> GetDealContentRights(string since, string AssetId, string DealId)
        {
            var param = new DynamicParameters();
            param.Add("@since", since);
            param.Add("@AssetId", AssetId);
            param.Add("@DealId", DealId);
            IEnumerable<DealContentRightsResult> lstUSPBMSGetDealContentRights = base.ExecuteSQLProcedure<DealContentRightsResult>("USP_BMS_GetDealContentsRights", param);
            return lstUSPBMSGetDealContentRights;
        }
    }
}
