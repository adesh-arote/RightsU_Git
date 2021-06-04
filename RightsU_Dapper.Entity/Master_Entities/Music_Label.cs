
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Music_Label")]
    public partial class Music_Label
    {
        public Music_Label()
        {
            this.Music_Title_Label = new HashSet<Music_Title_Label>();
            this.Title = new HashSet<Title>();
            this.Music_Deal = new HashSet<Music_Deal>();
        }
        [PrimaryKey]
        public int? Music_Label_Code { get; set; }
        public string Music_Label_Name { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Label> Music_Title_Label { get; set; }
        [OneToMany]
        public virtual ICollection<Title> Title { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
        //public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }
    }
}


