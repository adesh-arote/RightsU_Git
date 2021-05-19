namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Rights_Promoter")]
    public partial class Acq_Deal_Rights_Promoter
    {
        public Acq_Deal_Rights_Promoter()
        {
            this.Acq_Deal_Rights_Promoter_Group = new HashSet<Acq_Deal_Rights_Promoter_Group>();
            this.Acq_Deal_Rights_Promoter_Remarks = new HashSet<Acq_Deal_Rights_Promoter_Remarks>();
        }
        [PrimaryKey]
        public int? Acq_Deal_Rights_Promoter_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal_Rights))]
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }
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

        public virtual Acq_Deal_Rights Acq_Deal_Rights { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Promoter_Group> Acq_Deal_Rights_Promoter_Group { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Rights_Promoter_Remarks> Acq_Deal_Rights_Promoter_Remarks { get; set; }
    }
}