using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("Royalty_Recoupment_Details")]
    public partial class Royalty_Recoupment_Details
    {
        [PrimaryKey]
        public int? Royalty_Recoupment_Details_Code { get; set; }
        [ForeignKeyReference(typeof(Royalty_Recoupment))]
        public Nullable<int> Royalty_Recoupment_Code { get; set; }
        public string Recoupment_Type { get; set; }
        public Nullable<int> Recoupment_Type_Code { get; set; }
        public string Add_Subtract { get; set; }
        public Nullable<int> Position { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public string Recoupment_Type_Name { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Royalty_Recoupment Royalty_Recoupment { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public string _Dummy_Guid { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public string Dummy_Guid
        {
            get
            {
                if (string.IsNullOrEmpty(_Dummy_Guid))
                    _Dummy_Guid = GetDummy_Guid();
                return _Dummy_Guid;
            }
        }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }
    }
}
