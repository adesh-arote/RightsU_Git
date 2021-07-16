using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
   using RightsU_Entities;

    [Table("Channel_Category")]
    public partial class Channel_Category
    {
        public Channel_Category()
        {
            this.Channels = new HashSet<Channel>();
            this.Music_Deal = new HashSet<Music_Deal>();
            this.Channel_Category_Details = new HashSet<Channel_Category_Details>();
        }
        [PrimaryKey]
        public int? Channel_Category_Code { get; set; }
        public string Channel_Category_Name { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Type { get; set; }

        [OneToMany]
        public virtual ICollection<Channel> Channels { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Channel_Category_Details> Channel_Category_Details { get; set; }
    }
}
