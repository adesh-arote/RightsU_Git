//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace RightsU_Dapper.Entity
//{
//    using System;
//    using System.Collections.Generic;
//    using Dapper.SimpleLoad;
//    using Dapper.SimpleSave;

//    [Table("Music_Deal_Vendor")]
//    public partial class Music_Deal_Vendor
//    {
//        [PrimaryKey]
//        public int? Music_Deal_Vendor_Code { get; set; }
//        [ForeignKeyReference(typeof(Music_Deal))]
//        public Nullable<int> Music_Deal_Code { get; set; }
//        [ForeignKeyReference(typeof(Vendor))]
//        public Nullable<int> Vendor_Code { get; set; }
//        [SimpleSaveIgnore]
//        [SimpleLoadIgnore]
//        public virtual Music_Deal Music_Deal { get; set; }
//        [SimpleSaveIgnore]
//        [SimpleLoadIgnore]
//        public virtual Vendor Vendor { get; set; }
//    }
//}
