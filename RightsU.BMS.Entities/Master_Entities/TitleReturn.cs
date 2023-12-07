using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class TitleReturn
    {
        public TitleReturn()
        {
            assets = new List<title>();
            paging = new paging();
        }
        /// <summary>
        /// Paging Details
        /// </summary>
        [Required]
        public paging paging { get; set; }
        /// <summary>
        /// Title Details
        /// </summary>
        public List<title> assets { get; set; }
    }
    
    public class paging
    {
        /// <summary>
        /// The page number
        /// </summary>
        public int page { get; set; }
        /// <summary>
        /// The number of records per page
        /// </summary>
        public int size { get; set; }
        /// <summary>
        /// The overall number of records, only accurate up to 10,000
        /// </summary>
        public Int64 total { get; set; }        
    }

    public class title
    {
        public title()
        {
            MetaData = new Dictionary<string, Dictionary<string, string>>();
        }
        /// <summary>
        /// This is Title Code ,Example:RUBMSA11
        /// </summary>
        public int Id { get; set; }
        public string Name { get; set; }
        public string Language { get; set; }
        public string OriginalName { get; set; }
        public string OriginalLanguage { get; set; }
        public string ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        public string Program { get; set; }
        public string Country { get; set; }        
        public string StarCast { get; set; }
        public string Producer { get; set; }
        public string Director { get; set; }
        [JsonIgnore]
        public Int32 Deal_Type_Code { get; set; }        
        public string AssetType { get; set; }
        public string Synopsis { get; set; }
        public string Genre { get; set; }

        public Dictionary<string,Dictionary<string,string>> MetaData { get; set; }
    }
}
