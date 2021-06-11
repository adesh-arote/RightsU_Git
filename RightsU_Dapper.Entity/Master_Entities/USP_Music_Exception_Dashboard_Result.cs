
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal")]
    public partial class USP_Music_Exception_Dashboard_Result
{
    public string MusicLabel { get; set; }
    public Nullable<int> OpenCount { get; set; }
    public Nullable<int> InProcessCount { get; set; }
    public Nullable<int> ClosedCount { get; set; }
}
}


