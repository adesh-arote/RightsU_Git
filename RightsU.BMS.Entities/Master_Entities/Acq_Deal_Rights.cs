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

    [Table("Acq_Deal_Rights")]
    public partial class Acq_Deal_Rights
    {
        public Acq_Deal_Rights()
        {
            this.Acq_Deal_Rights_Title = new HashSet<Acq_Deal_Rights_Title>();
            this.Acq_Deal_Rights_Territory = new HashSet<Acq_Deal_Rights_Territory>();
            this.Acq_Deal_Rights_Platform = new HashSet<Acq_Deal_Rights_Platform>();
            this.Acq_Deal_Rights_Subtitling = new HashSet<Acq_Deal_Rights_Subtitling>();
            this.Acq_Deal_Rights_Dubbing = new HashSet<Acq_Deal_Rights_Dubbing>();
        }

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_rights_id")]
        public int Acq_Deal_Rights_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal))]
        [JsonProperty(PropertyName = "deal_id")]
        public int Acq_Deal_Code { get; set; }

        [JsonProperty(PropertyName = "exclusive")]
        public string Is_Exclusive { get; set; }

        [JsonProperty(PropertyName = "title_language_right")]
        public string Is_Title_Language_Right { get; set; }

        [JsonProperty(PropertyName = "sub_license")]
        public string Is_Sub_License { get; set; }

        [JsonProperty(PropertyName = "sub_license_id")]
        [ForeignKeyReference(typeof(Sub_License))]
        public Nullable<int> Sub_License_Code { get; set; }

        [ForeignKeyReference(typeof(Sub_License))]
        [ManyToOne]
        [SimpleSaveIgnore]
        public virtual Sub_License sub_license { get; set; }

        [JsonProperty(PropertyName = "theatrical_right")]
        public string Is_Theatrical_Right { get; set; }

        [JsonProperty(PropertyName = "right_type")]
        public string Right_Type { get; set; }

        [JsonProperty(PropertyName = "tentative")]
        public string Is_Tentative { get; set; }

        [JsonProperty(PropertyName = "right_start_date")]
        public Nullable<System.DateTime> Right_Start_Date { get; set; }

        [JsonProperty(PropertyName = "right_end_date")]
        public Nullable<System.DateTime> Right_End_Date { get; set; }

        [JsonProperty(PropertyName = "milestone_type_id")]
        [ForeignKeyReference(typeof(Milestone_Type))]
        public Nullable<int> Milestone_Type_Code { get; set; }

        [ForeignKeyReference(typeof(Milestone_Type))]
        [ManyToOne]
        [SimpleSaveIgnore]
        public virtual Milestone_Type milestone_type { get; set; }

        [JsonProperty(PropertyName = "milestone_unit")]
        public Nullable<int> Milestone_No_Of_Unit { get; set; }

        [JsonProperty(PropertyName = "milestone_unit_type")]
        public Nullable<int> Milestone_Unit_Type { get; set; }

        [JsonProperty(PropertyName = "rofr_id")]
        public string Is_ROFR { get; set; }

        [JsonProperty(PropertyName = "rofr_date")]
        public Nullable<System.DateTime> ROFR_Date { get; set; }

        [JsonProperty(PropertyName = "restriction_remarks")]
        public string Restriction_Remarks { get; set; }

        [JsonProperty(PropertyName = "under_production")]
        public string Is_Under_Production { get; set; }


        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Title> Acq_Deal_Rights_Title { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Territory> Acq_Deal_Rights_Territory { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Platform> Acq_Deal_Rights_Platform { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Subtitling> Acq_Deal_Rights_Subtitling { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Dubbing> Acq_Deal_Rights_Dubbing { get; set; }
    }
}
