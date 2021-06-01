using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("BMS_Deal")]
    public partial class BMS_Deal
    {
        public BMS_Deal()
        {
            this.BMS_Deal_Content = new HashSet<BMS_Deal_Content>();
        }
        [PrimaryKey]
        public int? BMS_Deal_Code { get; set; }
        public Nullable<int> Acq_Deal_Code { get; set; }
        public Nullable<decimal> BMS_Deal_Ref_Key { get; set; }
        public string Is_Archived { get; set; }
        public Nullable<int> RU_Licensor_Code { get; set; }
        public Nullable<int> RU_Payee_Code { get; set; }
        public Nullable<int> RU_Currency_Code { get; set; }
        public Nullable<int> RU_Licensee_Code { get; set; }
        public Nullable<int> RU_Category_Code { get; set; }
        public Nullable<decimal> BMS_Licensor_Code { get; set; }
        public Nullable<decimal> BMS_Payee_Code { get; set; }
        public Nullable<decimal> BMS_Currency_Code { get; set; }
        public Nullable<decimal> BMS_Licensee_Code { get; set; }
        public Nullable<decimal> BMS_Category_Code { get; set; }
        public Nullable<decimal> License_Fees { get; set; }
        public string Description { get; set; }
        public string Contact { get; set; }
        public string Lic_Ref_No { get; set; }
        public string Revision { get; set; }
        public Nullable<System.DateTime> Start_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public Nullable<int> Status_SLUId { get; set; }
        public Nullable<int> Type_SLUId { get; set; }
        public Nullable<System.DateTime> Acquisition_Date { get; set; }
        public Nullable<System.DateTime> Request_Time { get; set; }
        public Nullable<System.DateTime> Response_Time { get; set; }
        public string Record_Status { get; set; }
        public string Error_Description { get; set; }
        [OneToMany]
        public virtual ICollection<BMS_Deal_Content> BMS_Deal_Content { get; set; }
    }
}
