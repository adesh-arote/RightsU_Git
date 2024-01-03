﻿using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Genres")]
    public partial class Genre
    {        
        public Genre()
        {
            this.Title_Geners = new HashSet<Title_Geners>();
            //this.Channels = new HashSet<Channel>();
            //this.Programs = new HashSet<Program>();            
        }

        [PrimaryKey]
        public int Genres_Code { get; set; }
        public string Genres_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
                
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual ICollection<Title_Geners> Title_Geners { get; set; }
        //[SimpleSaveIgnore]
        //[SimpleLoadIgnore]
        //public virtual ICollection<Channel> Channels { get; set; }
        //[SimpleSaveIgnore]
        //[SimpleLoadIgnore]
        //public virtual ICollection<Program> Programs { get; set; }        
    }
}
