using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHMusicSongType")]
    public partial class MHMusicSongType
    {
        [PrimaryKey]
        public int MHMusicSongTypeCode { get; set; }
        public string SongType { get; set; }
    }
}
