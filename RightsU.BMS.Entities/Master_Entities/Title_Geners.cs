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
        [Column("Title_Geners_Code")]
        public int? title_genres_id { get; set; }

        [ForeignKeyReference(typeof(Title))]
        [Column("Title_Code")]
        public Nullable<int> title_id { get; set; }

        [ForeignKeyReference(typeof(Genres))]
        [Column("Genres_Code")]
        public Nullable<int> genres_id { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Genres genres { get; set; }
        
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
    }
}
