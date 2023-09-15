using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_LoadSheet_Export_CA.Entities
{
    public class USPAL_RecommendationExportToExcel_Show
    {
        public int AL_Recommendation_Code { get; set; }
        public int Title_Content_Code { get; set; }
        public string Title_Name { get; set; }
        public string YOR { get; set; }
        public string MPAARating { get; set; }
        public string Genre { get; set; }
        public string Studio { get; set; }
        public string Season { get; set; }
        public string Episode_Name { get; set; }
        public string Episode_Number { get; set; }
        public string Episode_Duration { get; set; }
        public string Episode_Synopsis { get; set; }
        public string Synopsis { get; set; }
        public string Title_Language { get; set; }
        public string Subtitles { get; set; }
        public string Duration { get; set; }
        public string Director { get; set; }
        public string Cast { get; set; }
        public string IMDB_Rating { get; set; }
        public string GeneralRemarks { get; set; }
    }
}
