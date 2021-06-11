
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Music_Override_Reason")]
    public partial class Music_Override_Reason
    {
        [PrimaryKey]
        public int? Music_Override_Reason_Code { get; set; }
        public string Music_Override_Reason_Name { get; set; }
    }
}


