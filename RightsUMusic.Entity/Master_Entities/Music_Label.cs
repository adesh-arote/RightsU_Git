using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Music_Label")]
    public partial class Music_Label
    {
        [PrimaryKey]
        public int Music_Label_Code { get; set; }
        public string Music_Label_Name { get; set; }
      //  public char Is_Active { get; set; }
        //public int Inserted_By { get; set; }
        //public Nullable<System.DateTime> Inserted_On{ get; set; }
        //public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        //public int Last_Action_By { get; set; }
        //public Nullable<System.DateTime> Lock_Time { get; set; }
    }
}
