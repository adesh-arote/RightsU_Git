using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{ 
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;
    using System;
    using System.Collections.Generic;

    [Table("Vendor")]
    public partial class Vendor
    {
        public Vendor()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Acq_Deal_Licensor = new HashSet<Acq_Deal_Licensor>();
            this.Material_Order = new HashSet<Material_Order>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
            this.Vendor_Contacts = new HashSet<Vendor_Contacts>();
            this.Vendor_Country = new HashSet<Vendor_Country>();
            this.Vendor_Role = new HashSet<Vendor_Role>();
            this.Acq_Deal_Cost_Commission = new HashSet<Acq_Deal_Cost_Commission>();
            this.Acq_Deal_Cost_Variable_Cost = new HashSet<Acq_Deal_Cost_Variable_Cost>();
            this.Syn_Deal_Revenue_Commission = new HashSet<Syn_Deal_Revenue_Commission>();
            this.Syn_Deal_Revenue_Variable_Cost = new HashSet<Syn_Deal_Revenue_Variable_Cost>();
            this.Music_Deal = new HashSet<Music_Deal>();
            this.Music_Deal_Vendor = new HashSet<Music_Deal_Vendor>();
            this.Provisional_Deal_Licensor = new HashSet<Provisional_Deal_Licensor>();
            this.MHPlayLists = new HashSet<MHPlayList>();
            this.MHRequests = new HashSet<MHRequest>();
            this.MHCueSheets = new HashSet<MHCueSheet>();

        }
        [PrimaryKey]
        public int? Vendor_Code { get; set; }
        public string Vendor_Name { get; set; }
        public string Address { get; set; }
        public string Phone_No { get; set; }
        public string Fax_No { get; set; }
        public string ST_No { get; set; }
        public string VAT_No { get; set; }
        public string TIN_No { get; set; }
        public string PAN_No { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Reference_Id_1 { get; set; }
        public string Reference_Id_2 { get; set; }
        public string Reference_Id_3 { get; set; }
        public string CST_No { get; set; }
        public string SAP_Vendor_Code { get; set; }
        public string Is_External { get; set; }
        public string CIN_No { get; set; }

        public string GST_No { get; set; }
        public string Is_BV_Push { get; set; }
        public string Short_Code { get; set; }
        public Nullable<int> Ref_Vendor_Key { get; set; }
        public string Record_Status { get; set; }
        public string Error_Description { get; set; }
        public Nullable<int> Party_Category_Code { get; set; }
        public string Party_Type { get; set; }
        public Nullable<int> Party_Group_Code { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]

        public virtual ICollection<Acq_Deal_Licensor> Acq_Deal_Licensor { get; set; }
        [OneToMany]

        public virtual ICollection<Material_Order> Material_Order { get; set; }
        [OneToMany]

        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        [OneToMany]

        public virtual ICollection<Vendor_Contacts> Vendor_Contacts { get; set; }
        [OneToMany]

        public virtual ICollection<Vendor_Country> Vendor_Country { get; set; }
        [OneToMany]

        public virtual ICollection<Vendor_Role> Vendor_Role { get; set; }
        [OneToMany]

        public virtual ICollection<Acq_Deal_Cost_Commission> Acq_Deal_Cost_Commission { get; set; }
        [OneToMany]

        public virtual ICollection<Acq_Deal_Cost_Variable_Cost> Acq_Deal_Cost_Variable_Cost { get; set; }
        [OneToMany]

        public virtual ICollection<Syn_Deal_Revenue_Commission> Syn_Deal_Revenue_Commission { get; set; }
        [OneToMany]

        public virtual ICollection<Syn_Deal_Revenue_Variable_Cost> Syn_Deal_Revenue_Variable_Cost { get; set; }
        [OneToMany]

        public virtual ICollection<Music_Deal> Music_Deal { get; set; }
        [OneToMany]

        public virtual ICollection<Music_Deal_Vendor> Music_Deal_Vendor { get; set; }
        [OneToMany]

        public virtual ICollection<Provisional_Deal_Licensor> Provisional_Deal_Licensor { get; set; }
        [OneToMany]

        public virtual ICollection<MHPlayList> MHPlayLists { get; set; }
        [OneToMany]

        public virtual ICollection<MHRequest> MHRequests { get; set; }
        [OneToMany]

        public virtual ICollection<MHCueSheet> MHCueSheets { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Party_Category Party_Category { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Party_Group Party_Group { get; set; }
    }
}
