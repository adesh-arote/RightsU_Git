namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title")]
    public partial class Title
    {
        public Title()
        {
            //this.Acq_Deal_Ancillary_Title = new HashSet<Acq_Deal_Ancillary_Title>();
            this.Acq_Deal_Movie = new HashSet<Acq_Deal_Movie>();
            //this.Acq_Deal_Rights_Title = new HashSet<Acq_Deal_Rights_Title>();
            //this.Acq_Deal_Run_Title = new HashSet<Acq_Deal_Run_Title>();
            //this.Syn_Deal_Ancillary_Title = new HashSet<Syn_Deal_Ancillary_Title>();
            //this.Syn_Deal_Movie = new HashSet<Syn_Deal_Movie>();
            //this.Syn_Deal_Rights_Title = new HashSet<Syn_Deal_Rights_Title>();
            this.Title_Audio_Details_Singers = new HashSet<Title_Audio_Details_Singers>();
            //this.Title_Audio_Details = new HashSet<Title_Audio_Details>();
            //this.Title_Country = new HashSet<Title_Country>();
            this.Title_Geners = new HashSet<Title_Geners>();
            this.Title_Talent = new HashSet<Title_Talent>();
            //this.Acq_Deal_Cost_Title = new HashSet<Acq_Deal_Cost_Title>();
            //this.Syn_Deal_Revenue_Title = new HashSet<Syn_Deal_Revenue_Title>();
            //this.Acq_Deal_Pushback_Title = new HashSet<Acq_Deal_Pushback_Title>();
            this.Acq_Deal_Material = new HashSet<Acq_Deal_Material>();
            this.Syn_Deal_Material = new HashSet<Syn_Deal_Material>();
            this.Acq_Deal_Attachment = new HashSet<Acq_Deal_Attachment>();
            this.Syn_Deal_Attachment = new HashSet<Syn_Deal_Attachment>();
            //this.Acq_Deal_Sport_Title = new HashSet<Acq_Deal_Sport_Title>();
            //this.Avail_Acq = new HashSet<Avail_Acq>();
            //this.Acq_Deal_Sport_Ancillary_Title = new HashSet<Acq_Deal_Sport_Ancillary_Title>();
            //this.Acq_Deal_Sport_Monetisation_Ancillary_Title = new HashSet<Acq_Deal_Sport_Monetisation_Ancillary_Title>();
            //this.Acq_Deal_Sport_Sales_Ancillary_Title = new HashSet<Acq_Deal_Sport_Sales_Ancillary_Title>();
            //this.Syn_Deal_Run = new HashSet<Syn_Deal_Run>();
            //this.Acq_Deal_Budget = new HashSet<Acq_Deal_Budget>();
            //this.Acq_Deal_Movie_Music_Link = new HashSet<Acq_Deal_Movie_Music_Link>();
            //this.Title_Release = new HashSet<Title_Release>();
            this.Title_Content = new HashSet<Title_Content>();
           //this.Music_Deal_LinkShow = new HashSet<Music_Deal_LinkShow>();
            this.Title_Alternate = new HashSet<Title_Alternate>();
            //this.Provisional_Deal_Title = new HashSet<Provisional_Deal_Title>();
            //this.MHPlayLists = new HashSet<MHPlayList>();
            //this.MHRequests = new HashSet<MHRequest>();
            //this.MHRequestDetails = new HashSet<MHRequestDetail>();
            //this.MHCueSheetSongs = new HashSet<MHCueSheetSong>();
            this.Title_Milestone = new HashSet<Title_Milestone>();
        }
        [PrimaryKey]
        public int? Title_Code { get; set; }
        public string Original_Title { get; set; }
        public string Title_Name { get; set; }
        public string Title_Code_Id { get; set; }
        public string Synopsis { get; set; }
        public Nullable<int> Original_Language_Code { get; set; }
        public Nullable<int> Title_Language_Code { get; set; }
        public Nullable<int> Year_Of_Production { get; set; }
        public Nullable<decimal> Duration_In_Min { get; set; }
        public Nullable<int> Deal_Type_Code { get; set; }
        public Nullable<int> Grade_Code { get; set; }
        public Nullable<int> Reference_Key { get; set; }
        public string Reference_Flag { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string Title_Image { get; set; }
        public Nullable<int> Music_Label_Code { get; set; }

        public Nullable<int> Program_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Music_Label Music_Label { get; set; }
       // public virtual ICollection<Acq_Deal_Ancillary_Title> Acq_Deal_Ancillary_Title { get; set; }
       [OneToMany]
        public virtual ICollection<Acq_Deal_Movie> Acq_Deal_Movie { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Title> Acq_Deal_Rights_Title { get; set; }
        //public virtual ICollection<Acq_Deal_Run_Title> Acq_Deal_Run_Title { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Deal_Type Deal_Type { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Grade_Master Grade_Master { get; set; }
        //public virtual ICollection<Syn_Deal_Ancillary_Title> Syn_Deal_Ancillary_Title { get; set; }
        //public virtual ICollection<Syn_Deal_Movie> Syn_Deal_Movie { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Title> Syn_Deal_Rights_Title { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Audio_Details_Singers> Title_Audio_Details_Singers { get; set; }
        //public virtual ICollection<Title_Audio_Details> Title_Audio_Details { get; set; }
        //public virtual ICollection<Title_Country> Title_Country { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Geners> Title_Geners { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Talent> Title_Talent { get; set; }
        //public virtual ICollection<Acq_Deal_Cost_Title> Acq_Deal_Cost_Title { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Title> Syn_Deal_Revenue_Title { get; set; }
        //public virtual ICollection<Acq_Deal_Pushback_Title> Acq_Deal_Pushback_Title { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Material> Acq_Deal_Material { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Material> Syn_Deal_Material { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Attachment> Acq_Deal_Attachment { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Attachment> Syn_Deal_Attachment { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Language Title_Languages { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Language Original_Languages { get; set; }
        //public virtual ICollection<Acq_Deal_Sport_Title> Acq_Deal_Sport_Title { get; set; }
        //public virtual ICollection<Avail_Acq> Avail_Acq { get; set; }
        //public virtual ICollection<Acq_Deal_Sport_Ancillary_Title> Acq_Deal_Sport_Ancillary_Title { get; set; }
        //public virtual ICollection<Acq_Deal_Sport_Monetisation_Ancillary_Title> Acq_Deal_Sport_Monetisation_Ancillary_Title { get; set; }
        //public virtual ICollection<Acq_Deal_Sport_Sales_Ancillary_Title> Acq_Deal_Sport_Sales_Ancillary_Title { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Run> Syn_Deal_Run { get; set; }
        //public virtual ICollection<Acq_Deal_Budget> Acq_Deal_Budget { get; set; }
        //public virtual ICollection<Acq_Deal_Movie_Music_Link> Acq_Deal_Movie_Music_Link { get; set; }
        //public virtual ICollection<Title_Release> Title_Release { get; set; }
        public virtual ICollection<Title_Content> Title_Content { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Program Program { get; set; }
        //public virtual ICollection<Music_Deal_LinkShow> Music_Deal_LinkShow { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Alternate> Title_Alternate { get; set; }
        //public virtual ICollection<Provisional_Deal_Title> Provisional_Deal_Title { get; set; }
        //public virtual ICollection<MHPlayList> MHPlayLists { get; set; }
        //public virtual ICollection<MHRequest> MHRequests { get; set; }
        //public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }
        //public virtual ICollection<MHCueSheetSong> MHCueSheetSongs { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Milestone> Title_Milestone { get; set; }
    }
}
