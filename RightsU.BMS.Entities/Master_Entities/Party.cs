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
    public partial class Party
    {        
        public Party()
        {
            this.party_role = new HashSet<Vendor_Role>();
            this.party_country = new HashSet<Vendor_Country>();
            this.party_contact = new HashSet<Vendor_Contacts>();
        }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "party_id")]
        public int? Vendor_Code { get; set; }

        [JsonProperty(PropertyName = "party_name")]
        public string Vendor_Name { get; set; }
                
        [ForeignKeyReference(typeof(Party_Category))]
        [JsonProperty(PropertyName = "party_category_id")]
        public Nullable<int> Party_Category_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Party_Category_Code")]
        public virtual Party_Category party_category { get; set; }

        [JsonProperty(PropertyName = "address")]
        public string Address { get; set; }
                
        [JsonProperty(PropertyName = "phone_no")]
        public string Phone_No { get; set; }
                
        [JsonProperty(PropertyName = "short_id")]
        public string Short_Code { get; set; }

        [JsonProperty(PropertyName = "fax_no")]
        public string Fax_No { get; set; }

        [JsonProperty(PropertyName = "gst_no")]
        public string GST_No { get; set; }
                
        [JsonProperty(PropertyName = "st_no")]
        public string ST_No { get; set; }

        [JsonProperty(PropertyName = "vat_no")]
        public string VAT_No { get; set; }

        [JsonProperty(PropertyName = "tin_no")]
        public string TIN_No { get; set; }

        [JsonProperty(PropertyName = "pan_no")]
        public string PAN_No { get; set; }

        [JsonProperty(PropertyName = "cst_no")]
        public string CST_No { get; set; }

        [JsonProperty(PropertyName = "cin_no")]
        public string CIN_No { get; set; }

        [ForeignKeyReference(typeof(Party_Group))]
        [JsonProperty(PropertyName = "party_group_id")]
        public Nullable<int> Party_Group_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Party_Group_Code")]
        public virtual Party_Group party_group { get; set; }

        [OneToMany]
        public virtual ICollection<Vendor_Role> party_role { get; set; }

        [OneToMany]
        public virtual ICollection<Vendor_Country> party_country { get; set; }
        
        [OneToMany]
        public virtual ICollection<Vendor_Contacts> party_contact { get; set; }

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
                
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
        
        [JsonIgnore]
        [JsonProperty(PropertyName = "party_type")]
        public string Party_Type { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        [JsonIgnore]
        [JsonProperty(PropertyName = "party_Id")]
        public string Party_Id { get; set; }

        
    }
}
