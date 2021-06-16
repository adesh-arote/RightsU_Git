using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
namespace RightsU_Dapper.Entity
{
    [Table("Deal_Tag")]
    public partial class Deal_Tag
    {
        public Deal_Tag()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
            this.Music_Deal = new HashSet<Music_Deal>();
        }
        [PrimaryKey]
        public int? Deal_Tag_Code { get; set; }
        public string Deal_Tag_Description { get; set; }
        public string Deal_Flag { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
    }
}
