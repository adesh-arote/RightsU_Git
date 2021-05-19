
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Country_Language")]
    public partial class Country_Language
    {
        //public State EntityState { get; set; }
        public int Country_Language_Code { get; set; }
        public Nullable<int> Country_Code { get; set; }
        public Nullable<int> Language_Code { get; set; }

        //public virtual Country Country { get; set; }
        //public virtual Language Language { get; set; }
    }
}


