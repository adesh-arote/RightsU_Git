
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Error_Code_Master")]
    public partial class Error_Code_Master
    {
        [PrimaryKey]
        public int? Error_Code { get; set; }
        //[ForeignKeyReference(typeof(Upload_Error))]
        public string Upload_Error_Code { get; set; }
        public string Error_Description { get; set; }
        public string Error_For { get; set; }
    }
}


