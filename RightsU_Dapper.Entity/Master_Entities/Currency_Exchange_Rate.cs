
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Currency_Exchange_Rate")]
    public partial class Currency_Exchange_Rate
    {
        [PrimaryKey]
        public int? Currency_Exchange_Rate_Code { get; set; }
        [ForeignKeyReference(typeof(Currency))]
        public Nullable<int> Currency_Code { get; set; }
        public System.DateTime Effective_Start_Date { get; set; }
        public Nullable<System.DateTime> System_End_Date { get; set; }
        public Nullable<decimal> Exchange_Rate { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string _Dummy_Guid { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
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
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Currency Currency { get; set; }
    }
}

