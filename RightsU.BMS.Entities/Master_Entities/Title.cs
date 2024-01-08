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
    [Table("Title")]
    public partial class Title
    {        
        public Title()
        {
            this.title_country = new HashSet<Title_Country>();
            this.title_genres = new HashSet<Title_Geners>();
            this.title_talent = new HashSet<Title_Talent>();
            this.MetaData = new HashSet<Map_Extended_Columns>();
        }

        [PrimaryKey]
        [Column("Title_Code")]
        public int? title_id { get; set; }

        [Column("Title_Name")]
        public string title_name { get; set; }

        //[ForeignKeyReference(typeof(Language))]
        [Column("Title_Language_Code")]        
        public Nullable<int> title_language_id { get; set; }

        [ForeignKeyReference(typeof(Language))]
        [ManyToOne]
        [Column("Title_Language_Code")]
        public virtual Language title_language { get; set; }

        [Column("Original_Title")]
        public string original_title_name { get; set; }

        //[ForeignKeyReference(typeof(Language))]
        [Column("Original_Language_Code")]
        public Nullable<int> original_language_id { get; set; }

        [ForeignKeyReference(typeof(Language))]
        [ManyToOne]
        [Column("Original_Language_Code")]
        public virtual Language original_language { get; set; }

        [ForeignKeyReference(typeof(Deal_Type))]
        [Column("Deal_Type_Code")]
        public Nullable<int> deal_type_id { get; set; }

        [ForeignKeyReference(typeof(Deal_Type))]
        [ManyToOne]
        [Column("Deal_Type_Code")]
        public virtual Deal_Type deal_type { get; set; }

        [Column("Year_Of_Production")]
        public Nullable<int> year_of_production { get; set; }

        [Column("Duration_In_Min")]
        public Nullable<decimal> duration_in_min { get; set; }

        [Column("Synopsis")]
        public string synopsis { get; set; }

        [ForeignKeyReference(typeof(Program))]
        [Column("Program_Code")]
        public Nullable<int> program_id { get; set; }

        [ForeignKeyReference(typeof(Program))]
        [ManyToOne]
        [Column("Program_Code")]
        public virtual Program Program { get; set; }

        [ManyToMany]        
        public virtual ICollection<Title_Country> title_country { get; set; }

        [ManyToMany]        
        public virtual ICollection<Title_Talent> title_talent { get; set; }

        [ManyToMany]        
        public virtual ICollection<Title_Geners> title_genres { get; set; }

        [JsonIgnore]
        public string Title_Code_Id { get; set; }
        [JsonIgnore]
        public Nullable<int> Grade_Code { get; set; }
        [JsonIgnore]
        public Nullable<int> Reference_Key { get; set; }
        [JsonIgnore]
        public string Reference_Flag { get; set; }
        [JsonIgnore]
        public string Is_Active { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public string Title_Image { get; set; }
        [JsonIgnore]
        public Nullable<int> Music_Label_Code { get; set; }        
        [JsonIgnore]
        public Nullable<int> Original_Title_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual ICollection<Map_Extended_Columns> MetaData { get; set; }












    }
}
