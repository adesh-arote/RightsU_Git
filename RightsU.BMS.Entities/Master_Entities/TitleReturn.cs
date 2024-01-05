using Newtonsoft.Json;
using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class TitleReturn : ListReturn
    {
        public TitleReturn()
        {
            content = new List<title>();
            paging = new paging();
        }

        /// <summary>
        /// Title Details
        /// </summary>
        public override object content { get; set; }
    }

    public class title_List
    {
        public title_List()
        {
            //StarCast = new List<string>();
        }
        /// <summary>
        /// This is Title Code ,Example:RUBMSA11
        /// </summary>
        public int id { get; set; }
        public string Name { get; set; }
        public string Language { get; set; }
        public string OriginalName { get; set; }
        public string OriginalLanguage { get; set; }
        public string ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        public string Program { get; set; }
        [JsonIgnore]
        public string Country1 { get; set; }
        public List<string> Country
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Country1))
                {
                    foreach (var item in Country1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public string StarCast1 { get; set; }
        public List<string> StarCast {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(StarCast1))
                {
                    foreach (var item in StarCast1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public string Producer1 { get; set; }
        public List<string> Producer
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Producer1))
                {
                    foreach (var item in Producer1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public string Director1 { get; set; }
        public List<string> Director
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Director1))
                {
                    foreach (var item in Director1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public Int32 Deal_Type_Code { get; set; }
        public string AssetType { get; set; }
        public string Synopsis { get; set; }
        [JsonIgnore]
        public string Genre1 { get; set; }
        public List<string> Genre
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Genre1))
                {
                    foreach (var item in Genre1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
    }

    public class title
    {
        public title()
        {
            MetaData = new List<TitleMetadata>();
            Country = new List<TitleCountry>();
            TitleTalent = new List<TitleTalent>();
            Genre = new List<TitleGenre>();
        }
        /// <summary>
        /// This is Title Code ,Example:RUBMSA11
        /// </summary>
        public int id { get; set; }
        public string Name { get; set; }
        public TitleGeneric TitleLanguage { get; set; }
        public string OriginalName { get; set; }
        public TitleGeneric OriginalLanguage { get; set; }
        public int ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        public TitleGeneric Program { get; set; }
        public List<TitleCountry> Country { get; set; }
        public List<TitleTalent> TitleTalent { get; set; }                
        public TitleGeneric AssetType { get; set; }
        public string Synopsis { get; set; }
        public List<TitleGenre> Genre { get; set; }

        public List<TitleMetadata> MetaData { get; set; }
    }

    public class TitleGeneric
    {
        public int id { get; set; }
        public string Name { get; set; }
    }

    public class TitleCountry
    {
        public int id { get; set; }
        public int CountryId { get; set; }
        public string Name { get; set; }
    }
    public class TitleTalent
    {
        public int id { get; set; }        
        public string Name { get; set; }
        public string Role { get; set; }
        public int TalentId { get; set; }
        public int RoleId { get; set; }
    }

    public class TitleGenre
    {
        public int id { get; set; }        
        public string Name { get; set; }
        public int GenreId { get; set; }
    }

    public class TitleMetadata
    {
        public TitleMetadata()
        {
            Value = new List<TitleMetadataValue>();
        }

        public string Key { get; set; }
        public List<TitleMetadataValue> Value { get; set; }
    }

    public class TitleMetadataValue
    {
        public int id { get; set; }
        public int ColumnId { get; set; }
        public string Key { get; set; }
        public object Value { get; set; }
    }

    public class TitleMetadataDetail
    {
        public int id { get; set; }
        public string Name { get; set; }
        public int ColumnValueId { get; set; }        
    }
}
