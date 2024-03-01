using Dapper;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.DAL.Repository
{
    public class BMSDealContentRepositories : MainRepository<DealContentResult>
    {
        public IEnumerable<DealContentResult> GetDealContent(string since, string AssetId,string DealId)
        {
            var param = new DynamicParameters();
            param.Add("@since", since);
            param.Add("@AssetId", AssetId);
            param.Add("@DealId", DealId);
            IEnumerable<DealContentResult> lstUSPBMSGetDealContent = base.ExecuteSQLProcedure<DealContentResult>("USP_BMS_GetDealContents", param);
            return lstUSPBMSGetDealContent;
        }
    }
}
