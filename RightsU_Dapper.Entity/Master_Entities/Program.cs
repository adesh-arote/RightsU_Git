
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Program")]
    public partial class Program
    {
        public Program()
        {
            this.Titles = new HashSet<Title>();
        }
        [PrimaryKey]
        public int? Program_Code { get; set; }
        public string Program_Name { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<int> Deal_Type_Code { get; set; }
        public Nullable<int> Genres_Code { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Title> Titles { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Deal_Type Deal_Type { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Genres Genre { get; set; }
    }
}


