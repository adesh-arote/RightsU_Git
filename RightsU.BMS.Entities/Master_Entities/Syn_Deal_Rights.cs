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

#pragma warning disable 1591

    [Table("Syn_Deal_Rights")]
    public partial class Syn_Deal_Rights
    {
        public Syn_Deal_Rights()
        {
            this.Titles = new HashSet<Syn_Deal_Rights_Title>();
            this.Region = new HashSet<Syn_Deal_Rights_Territory>();
            this.Platform = new HashSet<Syn_Deal_Rights_Platform>();
            this.Subtitling = new HashSet<Syn_Deal_Rights_Subtitling>();
            this.Dubbing = new HashSet<Syn_Deal_Rights_Dubbing>();
        }

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_rights_id")]
        public int? Syn_Deal_Rights_Code { get; set; }

        //[ForeignKeyReference(typeof(Syn_Deal))]
        [JsonProperty(PropertyName = "syn_deal_id")]
        public int Syn_Deal_Code { get; set; }

        [JsonProperty(PropertyName = "exclusive")]
        public string Is_Exclusive { get; set; }

        [JsonProperty(PropertyName = "title_language_right")]
        public string Is_Title_Language_Right { get; set; }

        [JsonProperty(PropertyName = "sub_license_flag")]
        public string Is_Sub_License { get; set; }

        [JsonProperty(PropertyName = "sub_license_id")]
        [ForeignKeyReference(typeof(Sub_License))]
        public Nullable<int> Sub_License_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Sub_License_Code")]
        public virtual Sub_License sub_license { get; set; }

        [JsonProperty(PropertyName = "theatrical_right")]
        public string Is_Theatrical_Right { get; set; }

        [JsonProperty(PropertyName = "right_type")]
        public string Right_Type { get; set; }

        [JsonProperty(PropertyName = "tentative")]
        public string Is_Tentative { get; set; }

        //[JsonProperty(PropertyName = "right_start_date")]
        [JsonIgnore]
        public Nullable<System.DateTime> Right_Start_Date { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "right_start_date")]
        public string right_start_date_str { get; set; }

        //[JsonProperty(PropertyName = "right_end_date")]
        [JsonIgnore]
        public Nullable<System.DateTime> Right_End_Date { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "right_end_date")]
        public string right_end_date_str { get; set; }

        [JsonProperty(PropertyName = "milestone_type_id")]
        [ForeignKeyReference(typeof(Milestone_Type))]
        public Nullable<int> Milestone_Type_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Milestone_Type_Code")]
        public virtual Milestone_Type milestone_type { get; set; }

        [JsonProperty(PropertyName = "milestone_unit")]
        public Nullable<int> Milestone_No_Of_Unit { get; set; }

        [JsonProperty(PropertyName = "milestone_unit_type")]
        public Nullable<int> Milestone_Unit_Type { get; set; }

        public string Is_ROFR { get; set; }

        [JsonProperty(PropertyName = "rofr_id")]
        public Nullable<int> ROFR_Code { get; set; }

        //[JsonProperty(PropertyName = "rofr_date")]
        [JsonIgnore]
        public Nullable<System.DateTime> ROFR_Date { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "rofr_date")]
        public string rofr_date_str { get; set; }

        [JsonProperty(PropertyName = "restriction_remarks")]
        public string Restriction_Remarks { get; set; }

        [JsonProperty(PropertyName = "coexclusive_remarks")]
        public string CoExclusive_Remarks { get; set; }


        [OneToMany]
        public virtual ICollection<Syn_Deal_Rights_Title> Titles { get; set; }

        [OneToMany]
        public virtual ICollection<Syn_Deal_Rights_Territory> Region { get; set; }

        [OneToMany]
        public virtual ICollection<Syn_Deal_Rights_Platform> Platform { get; set; }

        [OneToMany]
        public virtual ICollection<Syn_Deal_Rights_Subtitling> Subtitling { get; set; }

        [OneToMany]
        public virtual ICollection<Syn_Deal_Rights_Dubbing> Dubbing { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public string inserted_on { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public string updated_on { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }

        //Pending columns

        [JsonIgnore]
        //[JsonProperty(PropertyName = "term")]
        public string Term { get; set; }

        [JsonIgnore]
        //[JsonProperty(PropertyName = "effective_start_date")]
        public Nullable<System.DateTime> Effective_Start_Date { get; set; }

        [JsonIgnore]
        //[JsonProperty(PropertyName = "actual_right_start_date")]
        public Nullable<System.DateTime> Actual_Right_Start_Date { get; set; }

        [JsonIgnore]
        //[JsonProperty(PropertyName = "actual_right_end_date")]
        public Nullable<System.DateTime> Actual_Right_End_Date { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "right_status")]
        public string Right_Status { get; set; }

        //public string Is_ROFR { get; set; }

        [JsonIgnore]
        //[JsonProperty(PropertyName = "is_Verified")]
        public string Is_Verified { get; set; }

        [JsonIgnore]
        //[JsonProperty(PropertyName = "original_right_type")]
        public string Original_Right_Type { get; set; }

        [JsonIgnore]
        //[JsonProperty(PropertyName = "promoter_flag")]
        public string Promoter_Flag { get; set; }

        //[JsonIgnore]
        //[JsonProperty(PropertyName = "actual_right_end_date")]
        //public string Is_Under_Production { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_pushback")]
        public string Is_Pushback { get; set; }


    }
}
