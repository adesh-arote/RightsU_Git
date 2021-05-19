
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Platform_Group_Details")]
    public partial class Platform_Group_Details
    {
        [PrimaryKey]
        public int? Platform_Group_Details_Code { get; set; }
        [ForeignKeyReference(typeof(Platform))]
        public Nullable<int> Platform_Code { get; set; }
        [ForeignKeyReference(typeof(Platform_Group))]
        public Nullable<int> Platform_Group_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Platform Platform { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Platform_Group Platform_Group { get; set; }
    }
}


