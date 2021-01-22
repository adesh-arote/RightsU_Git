//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_InterimDb.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Music_Title
    {
        public Music_Title()
        {
            this.Acq_Deal_Movie_Music = new HashSet<Acq_Deal_Movie_Music>();
            this.Content_Music_Link = new HashSet<Content_Music_Link>();
            this.MHCueSheetSongs = new HashSet<MHCueSheetSong>();
            this.MHPlayListSongs = new HashSet<MHPlayListSong>();
            this.MHRequestDetails = new HashSet<MHRequestDetail>();
            this.Music_Title_Label = new HashSet<Music_Title_Label>();
            this.Music_Title_Language = new HashSet<Music_Title_Language>();
            this.Music_Title_Talent = new HashSet<Music_Title_Talent>();
            this.Music_Title_Theme = new HashSet<Music_Title_Theme>();
        }
    
    	public State EntityState { get; set; }    public int Music_Title_Code { get; set; }
    	    public string Music_Title_Name { get; set; }
    	    public Nullable<decimal> Duration_In_Min { get; set; }
    	    public string Movie_Album { get; set; }
    	    public Nullable<int> Release_Year { get; set; }
    	    public Nullable<int> Language_Code { get; set; }
    	    public Nullable<int> Music_Type_Code { get; set; }
    	    public string Image_Path { get; set; }
    	    public Nullable<int> Music_Version_Code { get; set; }
    	    public string Is_Active { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public Nullable<int> Genres_Code { get; set; }
    	    public Nullable<int> Music_Album_Code { get; set; }
    	    public string Music_Tag { get; set; }
    	    public string Public_Domain { get; set; }
    
        public virtual ICollection<Acq_Deal_Movie_Music> Acq_Deal_Movie_Music { get; set; }
        public virtual ICollection<Content_Music_Link> Content_Music_Link { get; set; }
        public virtual Language Language { get; set; }
        public virtual ICollection<MHCueSheetSong> MHCueSheetSongs { get; set; }
        public virtual ICollection<MHPlayListSong> MHPlayListSongs { get; set; }
        public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }
        public virtual Music_Album Music_Album { get; set; }
        public virtual ICollection<Music_Title_Label> Music_Title_Label { get; set; }
        public virtual ICollection<Music_Title_Language> Music_Title_Language { get; set; }
        public virtual Music_Type Music_Type { get; set; }
        public virtual Music_Type Music_Type1 { get; set; }
        public virtual ICollection<Music_Title_Talent> Music_Title_Talent { get; set; }
        public virtual ICollection<Music_Title_Theme> Music_Title_Theme { get; set; }
    }
}
