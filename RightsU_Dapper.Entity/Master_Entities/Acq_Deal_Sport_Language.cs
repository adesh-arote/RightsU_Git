namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Sport_Language")]
    public partial class Acq_Deal_Sport_Language
    {
       // public State EntityState { get; set; }
       [PrimaryKey]
        public int? Acq_Deal_Sport_Language_Code { get; set; }
        public Nullable<int> Acq_Deal_Sport_Code { get; set; }
        public string Language_Type { get; set; }
        public Nullable<int> Language_Code { get; set; }
        public Nullable<int> Language_Group_Code { get; set; }
        public string Flag { get; set; }

       // public virtual Acq_Deal_Sport Acq_Deal_Sport { get; set; }
        public virtual Language Language { get; set; }
        public virtual Language_Group Language_Group { get; set; }
    }
}