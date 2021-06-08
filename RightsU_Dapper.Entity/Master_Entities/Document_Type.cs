
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Document_Type")]
    public partial class Document_Type
    {
        public Document_Type()
        {
            this.Acq_Deal_Attachment = new HashSet<Acq_Deal_Attachment>();
            this.Syn_Deal_Attachment = new HashSet<Syn_Deal_Attachment>();
        }
        [PrimaryKey]
        public int? Document_Type_Code { get; set; }
        public string Document_Type_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Attachment> Acq_Deal_Attachment { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Attachment> Syn_Deal_Attachment { get; set; }
    }
}

