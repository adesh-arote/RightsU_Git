
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Acq")]
    public partial class USP_Validate_Episode_Result
    {
        public string TitleName { get; set; }
        public string EpisodeNo { get; set; }
    }
}


