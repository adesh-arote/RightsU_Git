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
    
    public partial class Language
    {
        public Language()
        {
            this.Acq_Deal_Rights_Dubbing = new HashSet<Acq_Deal_Rights_Dubbing>();
            this.Acq_Deal_Rights_Subtitling = new HashSet<Acq_Deal_Rights_Subtitling>();
            this.Country_Language = new HashSet<Country_Language>();
            this.Language_Group_Details = new HashSet<Language_Group_Details>();
            this.Syn_Deal_Rights_Dubbing = new HashSet<Syn_Deal_Rights_Dubbing>();
            this.Syn_Deal_Rights_Subtitling = new HashSet<Syn_Deal_Rights_Subtitling>();
            this.Acq_Deal_Pushback_Dubbing = new HashSet<Acq_Deal_Pushback_Dubbing>();
            this.Acq_Deal_Pushback_Subtitling = new HashSet<Acq_Deal_Pushback_Subtitling>();
            this.Acq_Deal_Rights_Blackout_Dubbing = new HashSet<Acq_Deal_Rights_Blackout_Dubbing>();
            this.Acq_Deal_Rights_Blackout_Subtitling = new HashSet<Acq_Deal_Rights_Blackout_Subtitling>();
            this.Acq_Deal_Rights_Holdback_Dubbing = new HashSet<Acq_Deal_Rights_Holdback_Dubbing>();
            this.Acq_Deal_Rights_Holdback_Subtitling = new HashSet<Acq_Deal_Rights_Holdback_Subtitling>();
            this.Syn_Deal_Rights_Blackout_Dubbing = new HashSet<Syn_Deal_Rights_Blackout_Dubbing>();
            this.Syn_Deal_Rights_Blackout_Subtitling = new HashSet<Syn_Deal_Rights_Blackout_Subtitling>();
            this.Syn_Deal_Rights_Holdback_Dubbing = new HashSet<Syn_Deal_Rights_Holdback_Dubbing>();
            this.Syn_Deal_Rights_Holdback_Subtitling = new HashSet<Syn_Deal_Rights_Holdback_Subtitling>();
            this.Title_Languages = new HashSet<Title>();
            this.Original_Languages = new HashSet<Title>();
            this.Acq_Deal_Sport_Language = new HashSet<Acq_Deal_Sport_Language>();
            this.Title_Alternate = new HashSet<Title_Alternate>();
            this.Title_Alternate1 = new HashSet<Title_Alternate>();
            this.MHRequestDetails = new HashSet<MHRequestDetail>();
            this.Music_Title = new HashSet<Music_Title>();
        }
    
    	public State EntityState { get; set; }    public int Language_Code { get; set; }
    	    public string Language_Name { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    	    public string Is_Active { get; set; }
    
        public virtual ICollection<Acq_Deal_Rights_Dubbing> Acq_Deal_Rights_Dubbing { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Subtitling> Acq_Deal_Rights_Subtitling { get; set; }
        public virtual ICollection<Country_Language> Country_Language { get; set; }
        public virtual ICollection<Language_Group_Details> Language_Group_Details { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Dubbing> Syn_Deal_Rights_Dubbing { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Subtitling> Syn_Deal_Rights_Subtitling { get; set; }
        public virtual ICollection<Acq_Deal_Pushback_Dubbing> Acq_Deal_Pushback_Dubbing { get; set; }
        public virtual ICollection<Acq_Deal_Pushback_Subtitling> Acq_Deal_Pushback_Subtitling { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Blackout_Dubbing> Acq_Deal_Rights_Blackout_Dubbing { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Blackout_Subtitling> Acq_Deal_Rights_Blackout_Subtitling { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Holdback_Dubbing> Acq_Deal_Rights_Holdback_Dubbing { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Holdback_Subtitling> Acq_Deal_Rights_Holdback_Subtitling { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Blackout_Dubbing> Syn_Deal_Rights_Blackout_Dubbing { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Blackout_Subtitling> Syn_Deal_Rights_Blackout_Subtitling { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Dubbing> Syn_Deal_Rights_Holdback_Dubbing { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Subtitling> Syn_Deal_Rights_Holdback_Subtitling { get; set; }
        public virtual ICollection<Title> Title_Languages { get; set; }
        public virtual ICollection<Title> Original_Languages { get; set; }
        public virtual ICollection<Acq_Deal_Sport_Language> Acq_Deal_Sport_Language { get; set; }
        public virtual ICollection<Title_Alternate> Title_Alternate { get; set; }
        public virtual ICollection<Title_Alternate> Title_Alternate1 { get; set; }
        public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }
        public virtual ICollection<Music_Title> Music_Title { get; set; }
    }
}
