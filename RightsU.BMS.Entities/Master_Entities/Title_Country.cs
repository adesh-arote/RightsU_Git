using Dapper.Contrib.Extensions;
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
    [Dapper.SimpleSave.Table("Title_Country")]
    public partial class Title_Country
    {
        [PrimaryKey]
        //[Column("Title_Country_Code")]
        [JsonProperty(PropertyName = "title_country_id")]
        public int? Title_Country_Code { get; set; }

        [ForeignKeyReference(typeof(Title))]
        //[Column("Title_Code")]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [ForeignKeyReference(typeof(Country))]
        //[Column("Country_Code")]
        [JsonProperty(PropertyName = "country_id")]
        public Nullable<int> Country_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Country country { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
    }
}
