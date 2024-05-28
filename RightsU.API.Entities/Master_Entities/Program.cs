using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using RightsU.API.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Program")]
    public partial class Program
    {
        [PrimaryKey]
        //[Column("Program_Code")]
        [JsonProperty(PropertyName = "program_id")]
        public int? Program_Code { get; set; }

        //[Column("Program_Name")]
        [JsonProperty(PropertyName = "program_name")]
        public string Program_Name { get; set; }

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

        [ForeignKeyReference(typeof(Deal_Type))]
        [JsonProperty(PropertyName = "deal_type_id")]
        public Nullable<int> Deal_Type_Code { get; set; }
                
        [ManyToOne]        
        [SimpleSaveIgnore]
        [Column("Deal_Type_Code")]
        public virtual Deal_Type deal_type { get; set; }

        [ForeignKeyReference(typeof(Genres))]
        [JsonProperty(PropertyName = "genres_id")]
        public Nullable<int> Genres_Code { get; set; }
                
        [ManyToOne]        
        [SimpleSaveIgnore]
        [Column("Genres_Code")]
        public virtual Genres Genres { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }        
    }
    
}
