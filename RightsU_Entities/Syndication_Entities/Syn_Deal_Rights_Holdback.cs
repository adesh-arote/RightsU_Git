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
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public partial class Syn_Deal_Rights_Holdback
    {
        public Syn_Deal_Rights_Holdback()
        {
            this.Syn_Deal_Rights_Holdback_Subtitling = new HashSet<Syn_Deal_Rights_Holdback_Subtitling>();
            this.Syn_Deal_Rights_Holdback_Dubbing = new HashSet<Syn_Deal_Rights_Holdback_Dubbing>();
            this.Syn_Deal_Rights_Holdback_Platform = new HashSet<Syn_Deal_Rights_Holdback_Platform>();
            this.Syn_Deal_Rights_Holdback_Territory = new HashSet<Syn_Deal_Rights_Holdback_Territory>();
        }

        public State EntityState { get; set; }
        public int Syn_Deal_Rights_Holdback_Code { get; set; }
        public int Syn_Deal_Rights_Code { get; set; }
        public string Holdback_Type { get; set; }
        public Nullable<int> HB_Run_After_Release_No { get; set; }
        public string HB_Run_After_Release_Units { get; set; }
        public Nullable<int> Holdback_On_Platform_Code { get; set; }
        public Nullable<System.DateTime> Holdback_Release_Date { get; set; }
        public string Holdback_Comment { get; set; }
        public string Is_Original_Language { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public Nullable<int> Acq_Deal_Rights_Holdback_Code { get; set; }


        public string strPlatformCount
        {
            get { return getPlatformCount(); }
        }

        public string strPlatformCodes
        {
            get { return getPlatformCodes(); }
        }

        public string strCountryCodes
        {
            get { return getCountryCodes(); }
        }

        public string strSubtitlingCodes
        {
            get { return getSubtitlingCodes(); }
        }

        public string strDubbingCodes
        {
            get { return getDubbingCodes(); }
        }


        public virtual Syn_Deal_Rights Syn_Deal_Rights { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Subtitling> Syn_Deal_Rights_Holdback_Subtitling { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Dubbing> Syn_Deal_Rights_Holdback_Dubbing { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Platform> Syn_Deal_Rights_Holdback_Platform { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Holdback_Territory> Syn_Deal_Rights_Holdback_Territory { get; set; }


        private string getPlatformCodes()
        {
            return string.Join(",", this.Syn_Deal_Rights_Holdback_Platform.Where(t => t.EntityState != State.Deleted).Select(t => t.Platform_Code));
        }

        private string getCountryCodes()
        {
            return string.Join(",", this.Syn_Deal_Rights_Holdback_Territory.Where(t => t.EntityState != State.Deleted).Select(t => t.Country_Code));
        }

        private string getSubtitlingCodes()
        {
            return string.Join(",", this.Syn_Deal_Rights_Holdback_Subtitling.Where(t => t.EntityState != State.Deleted).Select(t => t.Language_Code));
        }

        private string getDubbingCodes()
        {
            return string.Join(",", this.Syn_Deal_Rights_Holdback_Dubbing.Where(t => t.EntityState != State.Deleted).Select(t => t.Language_Code));
        }

        private string getPlatformCount()
        {
            return Convert.ToString(this.Syn_Deal_Rights_Holdback_Platform.Where(t => t.EntityState != State.Deleted).Count());
        }
        public string _DummyProp { get; set; }
        public string strDummyProp
        {
            get
            {
                if (string.IsNullOrEmpty(_DummyProp))
                    _DummyProp = GetDummyNo();
                return _DummyProp;
            }
        }
        private string GetDummyNo()
        {
            return Guid.NewGuid().ToString();
        }
    }
}
