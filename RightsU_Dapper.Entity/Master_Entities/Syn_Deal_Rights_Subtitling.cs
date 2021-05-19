
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Rights_Subtitling")]
    public partial class Syn_Deal_Rights_Subtitling
    {
       // public State EntityState { get; set; }
       [PrimaryKey]
        public int? Syn_Deal_Rights_Subtitling_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal_Rights))]
        public Nullable<int> Syn_Deal_Rights_Code { get; set; }
        public string Language_Type { get; set; }
        public Nullable<int> Language_Code { get; set; }
        public Nullable<int> Language_Group_Code { get; set; }

        public virtual Language Language { get; set; }
        public virtual Language_Group Language_Group { get; set; }
       // public virtual Syn_Deal_Rights Syn_Deal_Rights { get; set; }
    }
}


