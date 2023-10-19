using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class BMSAssetRepositories:MainRepository<AssetsResult>   
    {
        public IEnumerable<AssetsResult> GetAssets(string since)
        {
            var param = new DynamicParameters();
            param.Add("@since", since);            
            IEnumerable<AssetsResult> lstUSPBMSGetAssets = base.ExecuteSQLProcedure<AssetsResult>("USP_BMS_GetAssets", param);
            return lstUSPBMSGetAssets;
        }
    }
}
