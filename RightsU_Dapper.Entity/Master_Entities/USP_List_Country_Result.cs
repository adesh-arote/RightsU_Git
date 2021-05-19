
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Country")]
    public partial class USP_List_Country_Result
    {
        public int Country_Code { get; set; }
        public string Country_Name { get; set; }
        public string Theatrical_Territory { get; set; }
        public string Language_Names { get; set; }
        public string Base_Country { get; set; }
        public string Status { get; set; }
        public string Is_Theatrical_Territory { get; set; }
        public string Is_Active { get; set; }
        public string Disable_Message { get; set; }
        public string Last_Updated_Time { get; set; }
    }
}


