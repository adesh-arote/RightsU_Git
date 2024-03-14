using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.FrameworkClasses
{
    public class GlobalParams
    {
        public const int BMS_GetAssets = 272;
        public const int BMS_GetDeals = 273;
        public const int BMS_GetDealContent = 274;
        public const int BMS_GetDealRights = 275;

        public const int ScheduleUpload_Txt = 280;
        public const int ScheduleUpload_Csv = 281;

        public const int Assets_List = 277;
        public const int Assets_GetById = 278;
        public const int Assets_Title_Post = 283;
        public const int Assets_Title_Put = 284;
        public const int Assets_Title_Active = 285;
        public const int Assets_Title_Deactive = 286;



        #region Audit Global Params

        public const int ModuleCodeForParty = 10;
        public const int ModuleCodeForCostType = 14;
        public const int ModuleCodeForTerritory = 59;

        public const int ModuleCodeForTitle = 27;

        #endregion
    }
}
