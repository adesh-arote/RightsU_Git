using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class AL_Vendor_Rule_Criteria
    {
        [System.ComponentModel.DataAnnotations.Schema.NotMapped]
        public string ExtendedColumnNames { get; set; }
        [System.ComponentModel.DataAnnotations.Schema.NotMapped]
        public string DataFieldNames { get; set; }
    }

    public partial class AL_Vendor_OEM
    {
        [System.ComponentModel.DataAnnotations.Schema.NotMapped]
        public string SelectedOEMName { get; set; }
    }

    public partial class AL_Vendor_Details
    {
        [System.ComponentModel.DataAnnotations.Schema.NotMapped]
        public string SelectedPartyType { get; set; }
    }
}

// Extra Property to display Dropdown Names
// Not mapped to Database