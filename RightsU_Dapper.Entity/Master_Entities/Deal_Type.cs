
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Deal_Type")]
    public partial class Deal_Type
    {
        public Deal_Type()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Roles = new HashSet<Role>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
            this.Titles = new HashSet<Title>();
            this.Music_Deal = new HashSet<Music_Deal>();
            this.Programs = new HashSet<Program>();
            this.Title_Alternate = new HashSet<Title_Alternate>();
            //this.Provisional_Deal = new HashSet<Provisional_Deal>();
            //this.Music_Deal_DealType = new HashSet<Music_Deal_DealType>();
        }
        [PrimaryKey]
        public int? Deal_Type_Code { get; set; }
        public string Deal_Type_Name { get; set; }
        public string Is_Default { get; set; }
        public string Is_Grid_Required { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Is_Master_Deal { get; set; }
        public Nullable<int> Parent_Code { get; set; }
        public string Deal_Or_Title { get; set; }
        public Nullable<int> Deal_Title_Mapping_Code { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Role> Roles { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Title> Titles { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Program> Programs { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Alternate> Title_Alternate { get; set; }
        //public virtual ICollection<Provisional_Deal> Provisional_Deal { get; set; }
        //public virtual ICollection<Music_Deal_DealType> Music_Deal_DealType { get; set; }
    }
}