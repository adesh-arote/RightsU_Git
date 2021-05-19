namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Language_Group_Details")]
    public partial class Language_Group_Details
    {
        [PrimaryKey]
        public int? Language_Group_Details_Code { get; set; }
       [ForeignKeyReference(typeof(Language_Group))]
        public Nullable<int> Language_Group_Code { get; set; }
        [ForeignKeyReference(typeof(Language))]
        public Nullable<int> Language_Code { get; set; }

    }
}
