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
    
    public partial class MHPlayListSong
    {
    	public State EntityState { get; set; }    public long MHPlayListSongCode { get; set; }
    	    public Nullable<int> MHPlayListCode { get; set; }
    	    public Nullable<int> MusicTitleCode { get; set; }
    
        public virtual MHPlayList MHPlayList { get; set; }
        public virtual Music_Title Music_Title { get; set; }
    }
}
