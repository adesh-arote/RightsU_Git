using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.FrameworkClasses
{
    public abstract class ListReturn
    {
        public ListReturn()
        {
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
        public abstract object assets { get; set; }
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
}
