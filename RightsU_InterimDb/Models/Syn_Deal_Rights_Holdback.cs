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
    
    public partial class Syn_Deal_Rights_Holdback
    {
        public Syn_Deal_Rights_Holdback()
        {
            this.Syn_Deal_Rights_Holdback_Platform = new HashSet<Syn_Deal_Rights_Holdback_Platform>();
            this.Syn_Deal_Rights_Holdback_Territory = new HashSet<Syn_Deal_Rights_Holdback_Territory>();
            this.Syn_Deal_Rights_Holdback_Dubbing = new HashSet<Syn_Deal_Rights_Holdback_Dubbing>();
            this.Syn_Deal_Rights_Holdback_Subtitling = new HashSet<Syn_Deal_Rights_Holdback_Subtitling>();
        }
    
    	public State EntityState { get; set; }    public int Syn_Deal_Rights_Holdback_Code { get; set; }
    	    public int Syn_Deal_Rights_Code { get; set; }
    	    public string Holdback_Type { get; set; }
    	    public Nullable<int> HB_Run_After_Release_No { get; set; }
    	    public string HB_Run_After_Release_Units { get; set; }
    	    public Nullable<int> Holdback_On_Platform_Code { get; set; }
    	    public Nullable<System.DateTime> Holdback_Release_Date { get; set; }
    	    public string Holdback_Comment { get; set; }
    	    public string Is_Original_Language { get; set; }
    	    public Nullable<int> Acq_Deal_Rights_Holdback_Code { get; set; }
    
        public virtual Syn_Deal_Rights Syn_Deal_Rights { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Platform> Syn_Deal_Rights_Holdback_Platform { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Territory> Syn_Deal_Rights_Holdback_Territory { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Dubbing> Syn_Deal_Rights_Holdback_Dubbing { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Subtitling> Syn_Deal_Rights_Holdback_Subtitling { get; set; }
    }
}
