using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RightsU_Plus.Models
{
    public class CriteriaFilters
    {
        public string Titles { get; set; }
        public string EpisodeFrom { get; set; }
        public string EpisodeTo { get; set; }
        public string PeriodAvailable { get; set; }
        public string Exclusivity { get; set; }
        public string TitleLanguage { get; set; }
        public string Subtitling { get; set; }
        public string Dubbing { get; set; }
        public string IFTACluster { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedOn { get; set; }
        public string Region_Territory { get; set; }
        public string Region_Countries { get; set; }
        public string Region_MustHave { get; set; }
        public string Region_ExactMatch { get; set; }
        public string Platform_Group { get; set; }
        public string Platform_Platforms { get; set; }
        public string Platform_MustHave { get; set; }
        public string Platform_ExactMatch { get; set; }
        public string Subtitling_Group { get; set; }
        public string Subtitling_Languages { get; set; }
        public string Subtitling_MustHave { get; set; }
        public string Subtitling_ExactMatch { get; set; }
        public string Dubbing_Group { get; set; }
        public string Dubbing_Languages { get; set; }
        public string Dubbing_MustHave { get; set; }
        public string Dubbing_ExactMatch { get; set; }
    }
}