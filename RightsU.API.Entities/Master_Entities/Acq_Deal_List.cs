using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{    
    [Table("USP_List_Acq")]
    public class Acq_Deal_List
    {        
        [JsonProperty(PropertyName = "acq_deal_id")]
        public int Acq_Deal_Code { get; set; }
        [JsonProperty(PropertyName = "agreement_no ")]
        public string Agreement_No { get; set; }
        [JsonProperty(PropertyName = "version")]
        public string version { get; set; }
        [JsonProperty(PropertyName = "deal_type_id")]
        public int Deal_Type_Code { get; set; }
        [JsonProperty(PropertyName = "deal_type_name")]
        public string DealTypeName { get; set; }
        [JsonProperty(PropertyName = "content_type")]
        public string contentType { get; set; }
        [JsonProperty(PropertyName = "vendor_name")]
        public string VendorName { get; set; }
        [JsonIgnore]
        public DateTime DealSignedDate { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "agreement_date")]
        public string agreement_date { get; set; }
        [JsonProperty(PropertyName = "deal_description")]
        public string DealDesc { get; set; }
        [JsonProperty(PropertyName = "remarks")]
        public string Remarks { get; set; }
        [JsonProperty(PropertyName = "deal_titles")]
        public string DealTitles { get; set; }
        [JsonProperty(PropertyName = "right_period")]
        public string RightPeriod { get; set; }
        [JsonProperty(PropertyName = "country_details")]
        public string CountryDetails { get; set; }
        [JsonProperty(PropertyName = "zero_workflow")]
        public string IsZeroWorkFlow { get; set; }
        [JsonProperty(PropertyName = "deal_workflow_status")]
        public string dealWorkFlowStatus { get; set; }
        [JsonProperty(PropertyName = "final_deal_workflow_status")]
        public string Final_Deal_Workflow_Status { get; set; }
        [JsonProperty(PropertyName = "status")]
        public string status { get; set; }
        [JsonProperty(PropertyName = "is_active")]
        public string isActive { get; set; }
        [JsonProperty(PropertyName = "buttons_visibility")]
        public string Show_Hide_Buttons { get; set; }
        [JsonProperty(PropertyName = "at_status")]
        public string AT_Status { get; set; }
        [JsonProperty(PropertyName = "deal_title_count")]
        public int Cnt_DealTitles { get; set; }
        [JsonProperty(PropertyName = "previous_version")]
        [Column("Previous Version")]        
        public string Previous_Version { get; set; }

    }
}
