using Dapper.Contrib.Extensions;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
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
        public int? Title_Country_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        [ForeignKeyReference(typeof(Country))]
        public Nullable<int> Country_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Country Country { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Title Title { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
    }
}
