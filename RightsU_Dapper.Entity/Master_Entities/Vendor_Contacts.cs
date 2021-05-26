using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
   
    using System;
    using System.Collections.Generic;
    using RightsU_Entities;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("Vendor_Contacts")]
    public partial class Vendor_Contacts
    {
        public Vendor_Contacts()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
        }
        [PrimaryKey]
        public int? Vendor_Contacts_Code { get; set; }
        [ForeignKeyReference(typeof(Vendor))]
        public Nullable<int> Vendor_Code { get; set; }
        public string Contact_Name { get; set; }
        public string Phone_No { get; set; }
        public string Email { get; set; }
        public string Department { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string _Dummy_Guid { get; set; }
        public string Dummy_Guid
        {
            get
            {
                if (string.IsNullOrEmpty(_Dummy_Guid))
                    _Dummy_Guid = GetDummy_Guid();
                return _Dummy_Guid;
            }
        }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }
        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Vendor Vendor { get; set; }
    }
}
