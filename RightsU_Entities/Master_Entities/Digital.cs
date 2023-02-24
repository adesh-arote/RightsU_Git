namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Digital
    {
        public Digital()
        {
            this.Digital_Config = new HashSet<Digital_Config>();
        }

        public State EntityState { get; set; }
        public int Digital_Code { get; set; }
        public string Digital_Name { get; set; }
        public string Is_Active { get; set; }

        public virtual ICollection<Digital_Config> Digital_Config { get; set; }
    }
}
