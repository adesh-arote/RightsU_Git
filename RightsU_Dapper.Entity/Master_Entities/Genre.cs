
namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("Genres")]
    public partial class Genre
    {
        public Genre()
        {
            this.Channels = new HashSet<Channel>();
            this.Title_Geners = new HashSet<Title_Geners>();
            this.Programs = new HashSet<Program>();
            this.Title_Alternate_Genres = new HashSet<Title_Alternate_Genres>();
        }
        [PrimaryKey]
        public int? Genres_Code { get; set; }
        public string Genres_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Channel> Channels { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Geners> Title_Geners { get; set; }
        [OneToMany]
        public virtual ICollection<Program> Programs { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Alternate_Genres> Title_Alternate_Genres { get; set; }
    }
}
