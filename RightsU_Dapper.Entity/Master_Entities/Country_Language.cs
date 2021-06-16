
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Country_Language")]
    public partial class Country_Language
    {
        [PrimaryKey]
        public int? Country_Language_Code { get; set; }
        [ForeignKeyReference(typeof(Country))]
        public Nullable<int> Country_Code { get; set; }
        [ForeignKeyReference(typeof(Language))]
        public Nullable<int> Language_Code { get; set; }
    }
}


