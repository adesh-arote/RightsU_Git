using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.InputClasses
{
    public class TitleInput
    {
        public TitleInput()
        {
            TitleLanguage = new TitleGeneric();
            OriginalLanguage = new TitleGeneric();
            Program = new TitleGeneric();
            Country = new List<TitleCountry>();
            TitleTalent = new List<TitleTalent>();
            AssetType = new TitleGeneric();
            Genre = new List<TitleGenre>();
            MetaData = new List<ExtendedColumns>();
        }
        
        public Int32 id { get; set; }
        public string Name { get; set; }
        [JsonIgnore]
        public string Language { get; set; }
        public TitleGeneric TitleLanguage { get; set; }
        public string OriginalName { get; set; }
        [JsonIgnore]
        public string OriginalLanguage1 { get; set; }
        public TitleGeneric OriginalLanguage { get; set; }
        public int ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        [JsonIgnore]
        public string Program1 { get; set; }
        public TitleGeneric Program { get; set; }
        [JsonIgnore]
        public string Country1 { get; set; }
        public List<TitleCountry> Country { get; set; }
        [JsonIgnore]
        public string TitleTalent1 { get; set; }
        public List<TitleTalent> TitleTalent { get; set; }
        [JsonIgnore]
        public string AssetType1 { get; set; }
        public TitleGeneric AssetType { get; set; }
        public string Synopsis { get; set; }
        [JsonIgnore]
        public string Genre1 { get; set; }
        public List<TitleGenre> Genre { get; set; }
        public List<ExtendedColumns> MetaData { get; set; }
        
        
    }

    public class TitleGeneric
    {
        public int id { get; set; }
        public string Name { get; set; }
    }

    public class TitleTalent
    {
        public Int32 id { get; set; }
        public string Name { get; set; }
        public string Role { get; set; }
        public Int32 TalentId { get; set; }
        public Int32 RoleId { get; set; }
    }

    public class TitleCountry
    {
        public Int32 id { get; set; }
        public Int32 CountryId { get; set; }
        public string Name { get; set; }
    }

    public class TitleGenre
    {
        public Int32 id { get; set; }
        public string Name { get; set; }
        public Int32 GenreId { get; set; }
    }

    public class ExtendedColumns
    {
        public Int32 id { get; set; }
        public Int32 ColumnId { get; set; }
        public string Key { get; set; }
        public object Value { get; set; }
        public Int32 Row_No { get; set; }
    }

    public class ExtendedColumnDetails
    {
        public Int32 id { get; set; }
        public string Name { get; set; }
        public Int32 ColumnValueId { get; set; }
    }
}
