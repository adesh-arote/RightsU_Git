
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Music_Type")]
    public partial class Music_Type
    {
        public Music_Type()
        {
            this.Music_Title = new HashSet<Music_Title>();
        }
        [PrimaryKey]
        public int? Music_Type_Code { get; set; }
        public string Music_Type_Name { get; set; }
        public string Is_Active { get; set; }
        public string Type { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title> Music_Title { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title> Music_Title1 { get; set; }
    }
}


