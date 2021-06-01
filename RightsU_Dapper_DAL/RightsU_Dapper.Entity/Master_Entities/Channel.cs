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
    using RightsU_Entities;

    [Table("Channel")]
    public partial class Channel
    {
        public Channel()
        {
            this.Acq_Deal_Run = new HashSet<Acq_Deal_Run>();
            this.BVException_Channel = new HashSet<BVException_Channel>();
            this.Channel_Entity = new HashSet<Channel_Entity>();
            this.Channel_Territory = new HashSet<Channel_Territory>();
            this.RunDatas = new HashSet<RunData>();
            this.Channel_Region_Mapping = new HashSet<Channel_Region_Mapping>();
            this.IPR_Opp_Channel = new HashSet<IPR_Opp_Channel>();
            this.IPR_Rep_Channel = new HashSet<IPR_Rep_Channel>();
            this.Music_Deal_Channel = new HashSet<Music_Deal_Channel>();
            this.Provisional_Deal_Run_Channel = new HashSet<Provisional_Deal_Run_Channel>();
            this.Channel_Category_Details = new HashSet<Channel_Category_Details>();
            this.MHRequests = new HashSet<MHRequest>();
        }
        [PrimaryKey]
        public int? Channel_Code { get; set; }
        public string Channel_Name { get; set; }
        public string Channel_Id { get; set; }
        [ForeignKeyReference(typeof(Genre))]
        public Nullable<int> Genres_Code { get; set; }
        [ForeignKeyReference(typeof(Entity))]
        public Nullable<int> Entity_Code { get; set; }
        public string Entity_Type { get; set; }
        public string Schedule_Source_FilePath { get; set; }
        public Nullable<int> BV_Channel_Code { get; set; }
        public string AsRun_Source_FilePath { get; set; }
        public string HouseID_Prefix { get; set; }
        public Nullable<int> HouseID_Digits_AfterPrefix { get; set; }
        public string HouseIdRange_From { get; set; }
        public string HouseIdRange_To { get; set; }
        public string OffsetTime_Schedule { get; set; }
        public string OffsetTime_AsRun { get; set; }
        public string Schedule_Source_FilePath_Pkg { get; set; }
        public string IsUseForAsRun { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Order_For_schedule { get; set; }
        public Nullable<int> Channel_Group { get; set; }
        public Nullable<int> Channel_Format_Code { get; set; }
        public string Is_Parent_Child { get; set; }
        public Nullable<int> Parent_Channel_Code { get; set; }
        [ForeignKeyReference(typeof(Channel_Category))]
        public Nullable<int> Channel_Category_Code { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Run> Acq_Deal_Run { get; set; }
        [OneToMany]
        public virtual ICollection<BVException_Channel> BVException_Channel { get; set; }
        [OneToMany]
        public virtual ICollection<Channel_Entity> Channel_Entity { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Genre Genre { get; set; }
        [OneToMany]
        public virtual ICollection<Channel_Territory> Channel_Territory { get; set; }
        [OneToMany]
        public virtual ICollection<RunData> RunDatas { get; set; }
        [OneToMany]
        public virtual ICollection<Channel_Region_Mapping> Channel_Region_Mapping { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_Opp_Channel> IPR_Opp_Channel { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_Rep_Channel> IPR_Rep_Channel { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal_Channel> Music_Deal_Channel { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel_Category Channel_Category { get; set; }
        [OneToMany]
        public virtual ICollection<Provisional_Deal_Run_Channel> Provisional_Deal_Run_Channel { get; set; }
        [OneToMany]
        public virtual ICollection<Channel_Category_Details> Channel_Category_Details { get; set; }
        [OneToMany]
        public virtual ICollection<MHRequest> MHRequests { get; set; }
    }
}
