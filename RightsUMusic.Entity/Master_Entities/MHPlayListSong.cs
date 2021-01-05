using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHPlayListSong")]
    public partial class MHPlayListSong
    {
        [PrimaryKey]
        public int? MHPlayListSongCode { get; set; }
        [ForeignKeyReference(typeof(MHPlayList))]
        public int MHPlayListCode { get; set; }
        public int MusicTitleCode { get; set; }
    }
}
