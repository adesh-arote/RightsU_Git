//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    
    public partial class Language_Group
    {
        public Language_Group()
        {
            this.Acq_Deal_Rights_Dubbing = new HashSet<Acq_Deal_Rights_Dubbing>();
            this.Acq_Deal_Pushback_Dubbing = new HashSet<Acq_Deal_Pushback_Dubbing>();
            this.Acq_Deal_Pushback_Subtitling = new HashSet<Acq_Deal_Pushback_Subtitling>();
            this.Acq_Deal_Rights_Subtitling = new HashSet<Acq_Deal_Rights_Subtitling>();
            this.Language_Group_Details = new HashSet<Language_Group_Details>();
            this.Syn_Deal_Rights_Dubbing = new HashSet<Syn_Deal_Rights_Dubbing>();
            this.Syn_Deal_Rights_Subtitling = new HashSet<Syn_Deal_Rights_Subtitling>();
            this.Acq_Deal_Sport_Language = new HashSet<Acq_Deal_Sport_Language>();
        }
        [JsonIgnore]
        public State EntityState { get; set; }
        public int Language_Group_Code { get; set; }
        public string Language_Group_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Rights_Dubbing> Acq_Deal_Rights_Dubbing { get; set; }
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Pushback_Dubbing> Acq_Deal_Pushback_Dubbing { get; set; }
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Pushback_Subtitling> Acq_Deal_Pushback_Subtitling { get; set; }
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Rights_Subtitling> Acq_Deal_Rights_Subtitling { get; set; }
        public virtual ICollection<Language_Group_Details> Language_Group_Details { get; set; }
        [JsonIgnore]
        public virtual ICollection<Syn_Deal_Rights_Dubbing> Syn_Deal_Rights_Dubbing { get; set; }
        [JsonIgnore]
        public virtual ICollection<Syn_Deal_Rights_Subtitling> Syn_Deal_Rights_Subtitling { get; set; }
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Sport_Language> Acq_Deal_Sport_Language { get; set; }
    }
}
