//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_SchedulerService
{
    using System;
    
    public partial class USP_Acq_Rights_Model_Result
    {
        public int C_id { get; set; }
        public Nullable<int> assetId { get; set; }
        public string channelId { get; set; }
        public string rightsStartDate { get; set; }
        public string rightsEndDate { get; set; }
        public Nullable<int> availableRun { get; set; }
        public int consumptionRun { get; set; }
        public string runType { get; set; }
        public string rightsRuleName { get; set; }
        public Nullable<int> duration { get; set; }
        public Nullable<int> repeatPerRightsRule { get; set; }
        public Nullable<int> timeLag { get; set; }
        public int deleteFlag { get; set; }
    }
}
