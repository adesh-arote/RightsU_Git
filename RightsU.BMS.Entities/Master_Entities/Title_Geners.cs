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
    [Dapper.SimpleSave.Table("Title_Geners")]
    public partial class Title_Geners
    {
        [PrimaryKey]
        //[Column("Title_Geners_Code")]
        [JsonProperty(PropertyName = "title_genres_id")]
        public int? Title_Geners_Code { get; set; }

        [ForeignKeyReference(typeof(Title))]
        //[Column("Title_Code")]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [ForeignKeyReference(typeof(Genres))]
        //[Column("Genres_Code")]
        [JsonProperty(PropertyName = "genres_id")]
        public Nullable<int> Genres_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Genres genres { get; set; }
        
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
    }
}
