using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public class Title_List
    {
        public Title_List()
        {
        }

        public int Acq_Deal_Movie_Code { get; set; }
        public int Title_Code { get; set; }
        public int Episode_From { get; set; }
        public int Episode_To { get; set; }
    }
}
