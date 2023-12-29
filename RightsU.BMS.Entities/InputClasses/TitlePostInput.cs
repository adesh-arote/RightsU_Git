using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.InputClasses
{
    public class TitlePostInput
    {
        public Int32 id { get; set; }
        public string Name { get; set; }
        public Int32 TitleLanguageId { get; set; }
        public string OriginalName { get; set; }
        public Int32 OriginalLanguageId { get; set; }
        public string ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        public Int32 Program { get; set; }
        public List<Int32> Country { get; set; }
        public List<TitleTalent> TitleTalent { get; set; }        
        public Int32 AssetTypeId { get; set; }
        public string Synopsis { get; set; }
        public List<Int32> TitleGenre { get; set; }
        public Dictionary<Int32,List<string>> MetaData { get; set; }
        
        
    }

    public class TitleTalent
    {
        public int TalentId { get; set; }
        public int RoleId { get; set; }
    }
}
