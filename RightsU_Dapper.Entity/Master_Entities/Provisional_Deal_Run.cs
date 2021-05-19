
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal")]
    public partial class Provisional_Deal_Run
    {
        public Provisional_Deal_Run()
        {
            //this.Provisional_Deal_Run_Channel = new HashSet<Provisional_Deal_Run_Channel>();
        }
        [PrimaryKey]
        public int? Provisional_Deal_Run_Code { get; set; }
        public Nullable<int> Provisional_Deal_Title_Code { get; set; }
        public Nullable<int> No_Of_Runs { get; set; }
        public Nullable<int> Right_Rule_Code { get; set; }
        public Nullable<System.TimeSpan> Simulcast_Time_lag { get; set; }
        public Nullable<int> Prime_Runs { get; set; }
        public Nullable<int> Off_Prime_Runs { get; set; }
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
        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }
        public string Run_Type { get; set; }
       // public virtual Provisional_Deal_Title Provisional_Deal_Title { get; set; }
        public virtual Right_Rule Right_Rule { get; set; }

        //public virtual ICollection<Provisional_Deal_Run_Channel> Provisional_Deal_Run_Channel { get; set; }
    }
}


