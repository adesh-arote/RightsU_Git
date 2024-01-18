using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Vendor")]
    public partial class Vendor
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "vendor_id")]
        public int? Vendor_Code { get; set; }

        [JsonProperty(PropertyName = "vendor_name")]
        public string Vendor_Name { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "address")]
        public string Address { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "phone_no")]
        public string Phone_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "fax_no")]
        public string Fax_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "st_no")]
        public string ST_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "vat_no")]
        public string VAT_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "tin_no")]
        public string TIN_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "pan_no")]
        public string PAN_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]        
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "cst_no")]
        public string CST_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "cin_no")]
        public string CIN_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "gst_no")]
        public string GST_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "short_id")]
        public string Short_Code { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "party_category_id")]
        public Nullable<int> Party_Category_Code { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "party_type")]
        public string Party_Type { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "party_Id")]
        public string Party_Id { get; set; }        
    }
}
