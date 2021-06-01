using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;

    [Table("Music_Title")]
    public partial class Music_Title
    {
        public Music_Title()
        {
            this.Music_Title_Label = new HashSet<Music_Title_Label>();
            this.Music_Title_Talent = new HashSet<Music_Title_Talent>();
            this.Acq_Deal_Movie_Music = new HashSet<Acq_Deal_Movie_Music>();
            this.Content_Music_Link = new HashSet<Content_Music_Link>();
            this.Music_Title_Language = new HashSet<Music_Title_Language>();
            this.Music_Title_Theme = new HashSet<Music_Title_Theme>();
            this.MHPlayListSongs = new HashSet<MHPlayListSong>();
            this.MHRequestDetails = new HashSet<MHRequestDetail>();
            this.MHCueSheetSongs = new HashSet<MHCueSheetSong>();
        }

        [PrimaryKey]
        public int? Music_Title_Code { get; set; }
        public string Music_Title_Name { get; set; }
        public Nullable<decimal> Duration_In_Min { get; set; }
        public string Movie_Album { get; set; }
        public Nullable<int> Release_Year { get; set; }
        public Nullable<int> Language_Code { get; set; }
        public Nullable<int> Music_Type_Code { get; set; }
        public string Image_Path { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<int> Music_Version_Code { get; set; }
        public Nullable<int> Genres_Code { get; set; }
        public Nullable<int> Music_Album_Code { get; set; }
        public string Music_Tag { get; set; }
        public string Public_Domain { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Language Language { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Label> Music_Title_Label { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Type Music_Type { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Talent> Music_Title_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Movie_Music> Acq_Deal_Movie_Music { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Type Music_Type1 { get; set; }
        [OneToMany]
        public virtual ICollection<Content_Music_Link> Content_Music_Link { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Language> Music_Title_Language { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Theme> Music_Title_Theme { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Album Music_Album { get; set; }
        [OneToMany]
        public virtual ICollection<MHPlayListSong> MHPlayListSongs { get; set; }
        [OneToMany]
        public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }
        [OneToMany]
        public virtual ICollection<MHCueSheetSong> MHCueSheetSongs { get; set; }
    }
}
