
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Rights_Promoter")]
    public partial class Syn_Deal_Rights_Promoter
    {
        public Syn_Deal_Rights_Promoter()
        {
            this.Syn_Deal_Rights_Promoter_Group = new HashSet<Syn_Deal_Rights_Promoter_Group>();
            this.Syn_Deal_Rights_Promoter_Remarks = new HashSet<Syn_Deal_Rights_Promoter_Remarks>();
        }
        [PrimaryKey]
        public int Syn_Deal_Rights_Promoter_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal_Rights))]
        public Nullable<int> Syn_Deal_Rights_Code { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        private string _DummyProp = "";
        public string strDummyProp
        {
            get
            {
                if (_DummyProp == "")
                    _DummyProp = GetDummyNo();
                return _DummyProp;
            }
        }

        private string GetDummyNo()
        {
            return Guid.NewGuid().ToString();
        }
        public string TotalCount { get; set; }

        public virtual Syn_Deal_Rights Syn_Deal_Rights { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Promoter_Group> Syn_Deal_Rights_Promoter_Group { get; set; }
        public virtual ICollection<Syn_Deal_Rights_Promoter_Remarks> Syn_Deal_Rights_Promoter_Remarks { get; set; }
    }
}


