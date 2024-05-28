using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHRequestDetails")]
    public partial class MHRequestDetail
    {
        //public MHRequestDetail()
        //{
        //    this.Title = new HashSet<Title>();
        //}

        [PrimaryKey]
        public long? MHRequestDetailsCode { get; set; }
        [ForeignKeyReference(typeof(MHRequest))]
        public Nullable<long> MHRequestCode { get; set; }
        public string TitleName { get; set; }
        public Nullable<int> LanguageCode { get; set; }
        public string MusicTrackName { get; set; }
        public string MusicLabelName { get; set; }
        public string MovieAlbum { get; set; }
        public string CreateMap { get; set; }
        public Nullable<int> ActionUserCode { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> TitleCode { get; set; }
        public Nullable<int> MusicTitleCode { get; set; }
        public Nullable<int> MovieAlbumCode { get; set; }
        public string IsValid { get; set; }
        public string Remarks { get; set; }
        public Nullable<int> MusicLabelCode { get; set; }
        public string Singers { get; set; }
        public string StarCasts { get; set; }
        //public virtual MHRequest MHRequest { get; set; }

        //[OneToMany]
        //public virtual ICollection<Title> Title { get; set; }

    }
}
