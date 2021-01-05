using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Channel")]
    public partial class Channel
    {
        [PrimaryKey]
        public int Channel_Code { get; set; }
        public string Channel_Name { get; set; }

    }
}
