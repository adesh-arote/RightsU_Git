
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Grade_Master")]
    public partial class Grade_Master
    {
        public Grade_Master()
        {
            this.Titles = new HashSet<Title>();
        }
        [PrimaryKey]
        public int? Grade_Code { get; set; }
        public string Grade_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Title> Titles { get; set; }
    }
}

