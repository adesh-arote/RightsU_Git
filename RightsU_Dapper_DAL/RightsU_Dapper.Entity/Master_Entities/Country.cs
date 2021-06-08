﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Country")]

    public partial class Country
    {
        public Country()
        {
            //this.Acq_Deal_Rights_Blackout_Territory = new HashSet<Acq_Deal_Rights_Blackout_Territory>();
            //this.Acq_Deal_Rights_Holdback_Territory = new HashSet<Acq_Deal_Rights_Holdback_Territory>();
            //this.Acq_Deal_Pushback_Territory = new HashSet<Acq_Deal_Pushback_Territory>();
            //this.Acq_Deal_Rights_Territory = new HashSet<Acq_Deal_Rights_Territory>();
            //this.Channel_Territory = new HashSet<Channel_Territory>();
            //this.Country_Language = new HashSet<Country_Language>();
            //this.Syn_Deal_Rights_Blackout_Territory = new HashSet<Syn_Deal_Rights_Blackout_Territory>();
            //this.Syn_Deal_Rights_Holdback_Territory = new HashSet<Syn_Deal_Rights_Holdback_Territory>();
            //this.Syn_Deal_Rights_Territory = new HashSet<Syn_Deal_Rights_Territory>();
            //this.Territory_Details = new HashSet<Territory_Details>();
            //this.Title_Country = new HashSet<Title_Country>();
            this.Vendor_Country = new HashSet<Vendor_Country>();
            //this.Avail_Acq = new HashSet<Avail_Acq>();
            //this.IPR_REP = new HashSet<IPR_REP>();
            //this.Music_Deal_Country = new HashSet<Music_Deal_Country>();
            //this.Report_Territory_Country = new HashSet<Report_Territory_Country>();
            //this.Title_Alternate_Country = new HashSet<Title_Alternate_Country>();

        }
        [PrimaryKey]
        public int? Country_Code { get; set; }
        public string Country_Name { get; set; }
        public string Is_Domestic_Territory { get; set; }
        public string Is_Theatrical_Territory { get; set; }
        public string Is_Ref_Acq { get; set; }
        public string Is_Ref_Syn { get; set; }
        public Nullable<int> Parent_Country_Code { get; set; }
        public string Applicable_For_Asrun_Schedule { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public int Base_Country_Count { get; set; }

        //public virtual ICollection<Acq_Deal_Rights_Blackout_Territory> Acq_Deal_Rights_Blackout_Territory { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Holdback_Territory> Acq_Deal_Rights_Holdback_Territory { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Territory> Acq_Deal_Rights_Territory { get; set; }
        //public virtual ICollection<Channel_Territory> Channel_Territory { get; set; }
        //public virtual ICollection<Country_Language> Country_Language { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Blackout_Territory> Syn_Deal_Rights_Blackout_Territory { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Holdback_Territory> Syn_Deal_Rights_Holdback_Territory { get; set; }
        //public virtual ICollection<Syn_Deal_Rights_Territory> Syn_Deal_Rights_Territory { get; set; }
        //public virtual ICollection<Territory_Details> Territory_Details { get; set; }
        //public virtual ICollection<Title_Country> Title_Country { get; set; }
        [OneToMany]
        public virtual ICollection<Vendor_Country> Vendor_Country { get; set; }
        //public virtual ICollection<Acq_Deal_Pushback_Territory> Acq_Deal_Pushback_Territory { get; set; }
        //public virtual ICollection<Avail_Acq> Avail_Acq { get; set; }
        //public virtual ICollection<IPR_REP> IPR_REP { get; set; }
        //public virtual ICollection<Music_Deal_Country> Music_Deal_Country { get; set; }
        //public virtual ICollection<Report_Territory_Country> Report_Territory_Country { get; set; }
        //public virtual ICollection<Title_Alternate_Country> Title_Alternate_Country { get; set; }

    }
}