using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class GenreReturn : ListReturn
    {
        public GenreReturn()
        {
            content = new List<Genres>();
            paging = new paging();
        }

        /// <summary>
        /// Program Details
        /// </summary>
        public override object content { get; set; }
    }
    public class Genre_List
    {
        public Genre_List()
        {
            //StarCast = new List<string>();
        }
        /// <summary>
        /// This is Genre Code ,Example:RUBMSA11
        /// </summary>
        public int id { get; set; }
        public string GenreName { get; set; }
        public string IsActive { get; set; }
    }
}
