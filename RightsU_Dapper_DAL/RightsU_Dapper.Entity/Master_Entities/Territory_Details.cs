using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;


    [Table("Territory_Details")]
    public partial class Territory_Details
    {
        [PrimaryKey]
        public int? Territory_Details_Code { get; set; }
        [ForeignKeyReference(typeof(Country))]
        public int Country_Code { get; set; }
        [ForeignKeyReference(typeof(Territory))]
        public int Territory_Code { get; set; }
        public string Is_Ref_Acq { get; set; }
        public string Is_Ref_Syn { get; set; }
        //[SimpleLoadIgnore]
        //[SimpleSaveIgnore]
        //public virtual Country Country { get; set; }
        //[SimpleLoadIgnore]
        //[SimpleSaveIgnore]
        //public virtual Territory Territory { get; set; }
    }
}
