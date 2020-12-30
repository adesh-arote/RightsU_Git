using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Genres")]
    public partial class Genre
    {
        //public Genre()
        //{
        //    this.Channels = new HashSet<Channel>();
        //    this.Programs = new HashSet<Program>();
        //    this.Title_Alternate_Genres = new HashSet<Title_Alternate_Genres>();
        //    this.Title_Geners = new HashSet<Title_Geners>();
        //}
        [PrimaryKey]
        public int Genres_Code { get; set; }
        public string Genres_Name { get; set; }
        //public Nullable<System.DateTime> Inserted_On { get; set; }
        //public Nullable<int> Inserted_By { get; set; }
        //public Nullable<System.DateTime> Lock_Time { get; set; }
        //public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        //public Nullable<int> Last_Action_By { get; set; }
       // public string Is_Active { get; set; }
        //public Nullable<int> Ref_Genres_Key { get; set; }

        //public virtual ICollection<Channel> Channels { get; set; }
        //public virtual ICollection<Program> Programs { get; set; }
        //public virtual ICollection<Title_Alternate_Genres> Title_Alternate_Genres { get; set; }
        //public virtual ICollection<Title_Geners> Title_Geners { get; set; }
    }
}
