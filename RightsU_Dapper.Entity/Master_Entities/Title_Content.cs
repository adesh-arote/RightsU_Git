
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Title_Content")]
    public partial class Title_Content
    {
        public Title_Content()
        {
            //this.Content_Music_Link = new HashSet<Content_Music_Link>();
            //this.Content_Status_History = new HashSet<Content_Status_History>();
            //this.Title_Content_Version = new HashSet<Title_Content_Version>();
            this.Title_Content_Mapping = new HashSet<Title_Content_Mapping>();
            //this.MHCueSheetSongs = new HashSet<MHCueSheetSong>();
        }

        //public State EntityState { get; set; }
        [PrimaryKey]
        public int? Title_Content_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Episode_No { get; set; }
        public Nullable<decimal> Duration { get; set; }
        public string Ref_BMS_Content_Code { get; set; }
        public string Episode_Title { get; set; }
        public string Content_Status { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public string Synopsis { get; set; }

        //public virtual ICollection<Content_Music_Link> Content_Music_Link { get; set; }
        //public virtual ICollection<Content_Status_History> Content_Status_History { get; set; }
        public virtual Title Title { get; set; }
        //public virtual ICollection<Title_Content_Version> Title_Content_Version { get; set; }
        public virtual ICollection<Title_Content_Mapping> Title_Content_Mapping { get; set; }
        //public virtual ICollection<MHCueSheetSong> MHCueSheetSongs { get; set; }
    }
}

