namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Role")]
    public partial class Role
    {
        public Role()
        {
            this.Talent_Role = new HashSet<Talent_Role>();
            this.Title_Talent = new HashSet<Title_Talent>();
            this.Vendor_Role = new HashSet<Vendor_Role>();
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Music_Title_Talent = new HashSet<Music_Title_Talent>();
            this.Music_Album_Talent = new HashSet<Music_Album_Talent>();
            this.Title_Alternate_Talent = new HashSet<Title_Alternate_Talent>();

        }

       // public State EntityState { get; set; }
       [PrimaryKey]
        public int? Role_Code { get; set; }
        public string Role_Name { get; set; }
        public string Role_Type { get; set; }
        public string Is_Rate_Card { get; set; }
        public Nullable<System.DateTime> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Deal_Type_Code { get; set; }

        //public virtual Deal_Type Deal_Type { get; set; }
        [OneToMany]
        public virtual ICollection<Talent_Role> Talent_Role { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Talent> Title_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Vendor_Role> Vendor_Role { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Talent> Music_Title_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Album_Talent> Music_Album_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Alternate_Talent> Title_Alternate_Talent { get; set; }

    }
}