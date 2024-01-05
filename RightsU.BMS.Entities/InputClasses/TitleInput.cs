using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.InputClasses
{
    public class TitleInput
    {
        public Int32 id { get; set; }
        public string Name { get; set; }
        public Int32 TitleLanguageId { get; set; }
        public string OriginalName { get; set; }
        public Int32 OriginalLanguageId { get; set; }
        public string ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        public Int32 Program { get; set; }
        public List<Country> Country { get; set; }
        public List<TitleTalent> TitleTalent { get; set; }        
        public Int32 AssetTypeId { get; set; }
        public string Synopsis { get; set; }
        public List<TitleGenre> TitleGenre { get; set; }
        public List<Metadata> MetaData { get; set; }
        
        
    }

    public class TitleTalent
    {
        public Int32 id { get; set; }
        public Int32 TalentId { get; set; }
        public Int32 RoleId { get; set; }
    }

    public class Country
    {
        public Int32 id { get; set; }
        public Int32 CountryId { get; set; }
    }

    public class TitleGenre
    {
        public Int32 id { get; set; }
        public Int32 GenreId { get; set; }
    }

    public class Metadata
    {
        public Int32 id { get; set; }
        public Int32 Key { get; set; }
        public Int32 Row_No { get; set; }
        public object Value { get; set; }
    }

    public class ExtendedColumnDetails
    {
        public Int32 id { get; set; }
        public Int32 ColumnValueId { get; set; }
    }
}
