﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AL_Material_Tracking
    {
        public AL_Material_Tracking()
        {
            this.AL_Material_Tracking_OEM = new HashSet<AL_Material_Tracking_OEM>();
        }

        public State EntityState { get; set; }
        public int AL_Material_Tracking_Code { get; set; }
        public Nullable<int> AL_Load_Sheet_Code { get; set; }
        public Nullable<int> AL_Booking_Sheet_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public Nullable<int> AL_Lab_Code { get; set; }
        public string PO_Number { get; set; }
        public string PO_Status { get; set; }
        public string Poster { get; set; }
        public string Still { get; set; }
        public string Trailer { get; set; }
        public string Embedded_Subs { get; set; }
        public string Edited_Poster { get; set; }
        public string Edited_Still { get; set; }
        public string Master_In_House { get; set; }
        public string Status { get; set; }

        public virtual AL_Booking_Sheet AL_Booking_Sheet { get; set; }
        public virtual AL_Lab AL_Lab { get; set; }
        public virtual AL_Load_Sheet AL_Load_Sheet { get; set; }
        public virtual ICollection<AL_Material_Tracking_OEM> AL_Material_Tracking_OEM { get; set; }
        public virtual Title Title { get; set; }
        public virtual Title_Content Title_Content { get; set; }
        public virtual Vendor Vendor { get; set; }
    }
}
