
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Email_Config_Detail_Alert")]
    public partial class Email_Config_Detail_Alert
    {   
        [PrimaryKey]
        public int? Email_Config_Detail_Alert_Code { get; set; }
        [ForeignKeyReference(typeof(Email_Config_Detail))]
        public Nullable<int> Email_Config_Detail_Code { get; set; }
        public Nullable<int> Mail_Alert_Days { get; set; }
        public string Allow_Less_Than { get; set; }

        public virtual Email_Config_Detail Email_Config_Detail { get; set; }
    }
}



