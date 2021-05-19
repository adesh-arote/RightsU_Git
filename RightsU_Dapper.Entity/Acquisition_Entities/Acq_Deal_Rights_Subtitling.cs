namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Rights_Subtitling")]
    public partial class Acq_Deal_Rights_Subtitling
    {
        //public State EntityState { get; set; }
        [PrimaryKey]
        public int? Acq_Deal_Rights_Subtitling_Code { get; set; }
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }
        public string Language_Type { get; set; }
        public Nullable<int> Language_Code { get; set; }
        public Nullable<int> Language_Group_Code { get; set; }

        //public virtual Acq_Deal_Rights Acq_Deal_Rights { get; set; }
        //public virtual Language Language { get; set; }
        public virtual Language_Group Language_Group { get; set; }
    }
}