using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHPlayList")]
    public partial class MHPlayList
    {
        public MHPlayList()
        {
            this.MHPlayListSong = new HashSet<MHPlayListSong>();
        }
        [PrimaryKey]
        public int? MHPlayListCode { get; set; }
        public string PlaylistName { get; set; }
        public int TitleCode { get; set; }
        public int VendorCode { get; set; }
        public string IsActive { get; set; }

        [OneToMany]
        public virtual ICollection<MHPlayListSong> MHPlayListSong { get; set; }
    }
}
