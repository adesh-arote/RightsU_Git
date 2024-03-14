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
    [Table("Genres")]
    public partial class Genres
    {
        [PrimaryKey]
        //[Column("Genres_Code")]
        [JsonProperty(PropertyName = "genres_id")]
        public int? Genres_Code { get; set; }

        //[Column("Genres_Name")]
        [JsonProperty(PropertyName = "genres_name")]
        public string Genres_Name { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        //[Column("Is_Active")]
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

    }

}
