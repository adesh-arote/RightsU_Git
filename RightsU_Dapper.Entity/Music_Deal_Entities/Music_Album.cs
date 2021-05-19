namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Music_Album")]
    public partial class Music_Album
    {
        public Music_Album()
        {
            this.Music_Album_Talent = new HashSet<Music_Album_Talent>();
            //this.Music_Title = new HashSet<Music_Title>();
            //this.MHRequestDetails = new HashSet<MHRequestDetail>();
        }
        [PrimaryKey]
        public int? Music_Album_Code { get; set; }
        public string Music_Album_Name { get; set; }
        public string Album_Type { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Album_Talent> Music_Album_Talent { get; set; }
        //public virtual ICollection<Music_Title> Music_Title { get; set; }
        //public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }
    }
}
