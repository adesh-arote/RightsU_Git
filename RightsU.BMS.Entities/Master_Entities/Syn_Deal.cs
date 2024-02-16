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
    [Table("Syn_Deal")]
    public partial class Syn_Deal
    {        
        public Syn_Deal()
        {            
            this.SynDealTitles = new HashSet<Syn_Deal_Movie>();            
        }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_id")]
        public int? Syn_Deal_Code { get; set; }

        [JsonProperty(PropertyName = "deal_type_id")]
        public Nullable<int> Deal_Type_Code { get; set; }

        [ForeignKeyReference(typeof(Business_Unit))]
        [JsonProperty(PropertyName = "business_unit_id")]
        public Nullable<int> Business_Unit_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Business_Unit_Code")]
        //public virtual Business_Unit business_unit { get; set; }

        [JsonProperty(PropertyName = "agreement_no")]
        public string Agreement_No { get; set; }

        [JsonProperty(PropertyName = "version_no")]
        public string Version { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "agreement_date")]
        public string agreement_date { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Agreement_Date { get; set; }

        [JsonProperty(PropertyName = "deal_description")]
        public string Deal_Description { get; set; }

        [JsonProperty(PropertyName = "year_type")]
        public string Year_Type { get; set; }

        [JsonProperty(PropertyName = "customer_type")]
        public Nullable<int> Customer_Type { get; set; }

        [ForeignKeyReference(typeof(Vendor))]
        [JsonProperty(PropertyName = "vendor_id")]
        public Nullable<int> Vendor_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Vendor_Code")]
        //public virtual Vendor licensee { get; set; }

        [ForeignKeyReference(typeof(Vendor_Contacts))]
        [JsonProperty(PropertyName = "vendor_contact_id")]
        public Nullable<int> Vendor_Contact_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Vendor_Contact_Code")]
        //public virtual Vendor contact { get; set; }

        [JsonProperty(PropertyName = "sales_agent_id")]
        public Nullable<int> Sales_Agent_Code { get; set; }

        [JsonProperty(PropertyName = "sales_agent_contact_id")]
        public Nullable<int> Sales_Agent_Contact_Code { get; set; }

        [ForeignKeyReference(typeof(Currency))]
        [JsonProperty(PropertyName = "currency_id")]
        public Nullable<int> Currency_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Currency_Code")]
        //public virtual Currency Currency { get; set; }

        [JsonProperty(PropertyName = "exchange_rate")]
        public Nullable<decimal> Exchange_Rate { get; set; }

        [JsonProperty(PropertyName = "ref_no")]
        public string Ref_No { get; set; }

        [ForeignKeyReference(typeof(Category))]
        [JsonProperty(PropertyName = "category_id")]
        public Nullable<int> Category_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Category_Code")]
        //public virtual Category category { get; set; }

        [ForeignKeyReference(typeof(Deal_Tag))]
        [JsonProperty(PropertyName = "deal_tag_id")]
        public Nullable<int> Deal_Tag_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Deal_Tag_Code")]
        //public virtual Deal_Tag deal_tag { get; set; }

        [JsonProperty(PropertyName = "remarks")]
        public string Remarks { get; set; }

        [JsonProperty(PropertyName = "right_remarks")]
        public string Rights_Remarks { get; set; }

        [ForeignKeyReference(typeof(Deal_Segment))]
        [JsonProperty(PropertyName = "deal_segment_id")]
        public Nullable<int> Deal_Segment_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Deal_Segment_Code")]
        //public virtual Deal_Segment deal_segment { get; set; }

        [ForeignKeyReference(typeof(Revenue_Vertical))]
        [JsonProperty(PropertyName = "revenue_vertical_id")]
        public Nullable<int> Revenue_Vertical_Code { get; set; }

        //[SimpleSaveIgnore]
        //[ManyToOne]
        //[Column("Revenue_Vertical_Code")]
        //public virtual Revenue_Vertical revenue_vertical { get; set; }

        [JsonProperty(PropertyName = "material_remarks")]
        public string Material_Remarks { get; set; }

        [JsonProperty(PropertyName = "payment_terms_conditions")]
        public string Payment_Terms_Conditions { get; set; }


        [OneToMany]
        public virtual ICollection<Syn_Deal_Movie> SynDealTitles { get; set; }

        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }


        //Pending Columns
        [JsonIgnore]
        public string Other_Deal { get; set; }
        [JsonIgnore]
        public Nullable<double> Total_Sale { get; set; }
        [JsonIgnore]
        public string Attach_Workflow { get; set; }
        [JsonIgnore]
        public string Deal_Workflow_Status { get; set; }
        [JsonIgnore]
        public Nullable<int> Work_Flow_Code { get; set; }
        [JsonIgnore]
        public string Is_Completed { get; set; }
        [JsonIgnore]
        public Nullable<int> Parent_Syn_Deal_Code { get; set; }
        [JsonIgnore]
        public string Is_Migrated { get; set; }
        [JsonIgnore]
        public string Ref_BMS_Code { get; set; }
        [JsonIgnore]
        public string Status { get; set; }
        [JsonIgnore]
        public string Payment_Remarks { get; set; }
        [JsonIgnore]
        public string Is_Active { get; set; }
        [JsonIgnore]
        public string Deal_Complete_Flag { get; set; }
        [JsonIgnore]
        public Nullable<int> Entity_Code { get; set; }
        [JsonIgnore]
        public Nullable<int> Role_Code { get; set; }
    }
}
