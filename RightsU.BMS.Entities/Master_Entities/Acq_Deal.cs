using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Acq_Deal")]
    public partial class Acq_Deal
    {
        public Acq_Deal()
        {                     
            this.Licensors = new HashSet<Acq_Deal_Licensor>();
            this.DealTitles = new HashSet<Acq_Deal_Movie>();            
        }

        [JsonIgnore]        
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_id")]
        public int? Acq_Deal_Code { get; set; }

        [JsonProperty(PropertyName = "agreement_no")]
        public string Agreement_No { get; set; }

        [JsonProperty(PropertyName = "version_no")]
        public string Version { get; set; }

        [JsonProperty(PropertyName = "agreement_date")]
        public string Agreement_Date { get; set; }

        [JsonProperty(PropertyName = "deal_description")]
        public string Deal_Desc { get; set; }

        [ForeignKeyReference(typeof(Deal_Tag))]
        [JsonProperty(PropertyName = "deal_tag_id")]
        public Nullable<int> Deal_Tag_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]        
        [Column("Deal_Tag_Code")]
        public virtual Deal_Tag deal_tag { get; set; }

        [JsonProperty(PropertyName = "master_sub_deal_type")]
        public string Is_Master_Deal { get; set; }

        [ForeignKeyReference(typeof(Role))]
        [JsonProperty(PropertyName = "role_id")]
        public Nullable<int> Role_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]        
        [Column("Role_Code")]
        public virtual Role role { get; set; }

        [ForeignKeyReference(typeof(Deal_Type))]
        [JsonProperty(PropertyName = "deal_type_id")]
        public Nullable<int> Deal_Type_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]        
        [Column("Deal_Type_Code")]        
        public virtual Deal_Type deal_type { get; set; }

        [ForeignKeyReference(typeof(Entity))]
        [JsonProperty(PropertyName = "entity_id")]
        public Nullable<int> Entity_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]        
        [Column("Entity_Code")]
        public virtual Entity entity { get; set; }

        [ForeignKeyReference(typeof(Vendor))]
        [JsonProperty(PropertyName = "primary_vendor_id")]
        public Nullable<int> Vendor_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]        
        [Column("Vendor_Code")]
        public virtual Vendor primary_vendor { get; set; }

        [JsonProperty(PropertyName = "master_deal_id")]
        public Nullable<int> Parent_Deal_Code { get; set; }

        [JsonProperty(PropertyName = "master_deal_link_title_id")]
        public Nullable<int> Master_Deal_Movie_Code_ToLink { get; set; }

        [JsonProperty(PropertyName = "year_definition")]
        public string Year_Type { get; set; }

        [ForeignKeyReference(typeof(Currency))]
        [JsonProperty(PropertyName = "currency_id")]
        public Nullable<int> Currency_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]        
        [Column("Currency_Code")]
        public virtual Currency Currency { get; set; }

        [JsonProperty(PropertyName = "exchange_rate")]
        public Nullable<decimal> Exchange_Rate { get; set; }

        [ForeignKeyReference(typeof(Business_Unit))]
        [JsonProperty(PropertyName = "business_unit_id")]
        public Nullable<int> Business_Unit_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Business_Unit_Code")]
        public virtual Business_Unit business_unit { get; set; }

        [ForeignKeyReference(typeof(Category))]
        [JsonProperty(PropertyName = "category_id")]
        public Nullable<int> Category_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]        
        [Column("Category_Code")]
        public virtual Category category { get; set; }

        [JsonProperty(PropertyName = "reference_no")]
        public string Ref_No { get; set; }
             
        [ForeignKeyReference(typeof(Vendor_Contacts))]
        [JsonProperty(PropertyName = "vendor_contact_id")]
        public Nullable<int> Vendor_Contacts_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Vendor_Contacts_Code")]
        public virtual Vendor_Contacts vendor_contact { get; set; }

        [JsonProperty(PropertyName = "remarks")]
        public string Remarks { get; set; }

        [JsonProperty(PropertyName = "right_remarks")]
        public string Rights_Remarks { get; set; }

        [JsonProperty(PropertyName = "workflow_status")]
        public string Deal_Workflow_Status { get; set; }

        [JsonProperty(PropertyName = "ref_system_id")]
        public string Ref_BMS_Code { get; set; }
                
        [OneToMany]
        public virtual ICollection<Acq_Deal_Licensor> Licensors { get; set; }
                
        [OneToMany]
        public virtual ICollection<Acq_Deal_Movie> DealTitles { get; set; }

        [JsonProperty(PropertyName = "inserted_on")]
        public string Inserted_On { get; set; }

        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonProperty(PropertyName = "updated_on")]
        public string Last_Updated_Time { get; set; }

        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }
    }
}
