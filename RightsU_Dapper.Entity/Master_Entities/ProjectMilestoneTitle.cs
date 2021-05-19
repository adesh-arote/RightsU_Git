
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("ProjectMilestoneTitle")]
    public partial class ProjectMilestoneTitle
    {
        [PrimaryKey]
        public int? ProjectMilestoneTitleCode { get; set; }
        [ForeignKeyReference(typeof(ProjectMilestone))]
        public Nullable<int> ProjectMilestoneCode { get; set; }
        public string ProspectTitleName { get; set; }
        public string _Dummy_Guid { get; set; }
        public string Dummy_Guid
        {
            get
            {
                if (string.IsNullOrEmpty(_Dummy_Guid))
                    _Dummy_Guid = GetDummy_Guid();
                return _Dummy_Guid;
            }
        }
        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }

        //public virtual ProjectMilestone ProjectMilestone { get; set; }
    }
}


