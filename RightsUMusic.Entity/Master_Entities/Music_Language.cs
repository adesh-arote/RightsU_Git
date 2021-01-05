using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Music_Language")]
    public partial class Music_Language
    {
        [PrimaryKey]
        public int Music_Language_Code { get; set; }
        public string Language_Name { get; set; }
    }
}
