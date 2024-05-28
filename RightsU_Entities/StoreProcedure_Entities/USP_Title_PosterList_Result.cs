using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class USP_Title_PosterList_Result
    {
        public int Title_Code { get; set; }
        public string Title_Name { get; set; }
        public string Title_Image { get; set; }
        public string Deal_Type_Name { get; set; }
        public string Language_Name { get; set; }
        public string Genres_Name { get; set; }
        public string Title_Poster { get; set; }
        public int Deal_Type_Code { get; set; }
    }
}
