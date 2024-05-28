using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Music_Album")]
    public partial class Music_Album
    {
        [PrimaryKey]
        public int Music_Album_Code { get; set; }
        public string Music_Album_Name { get; set; }

    }
}
