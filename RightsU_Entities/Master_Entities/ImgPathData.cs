using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class ImgPathData
    {
        public State EntityState { get; set; }
        public int Id { get; set; }
        public string ImgPath { get; set; }
        public string ImgData { get; set; }
    }
}
