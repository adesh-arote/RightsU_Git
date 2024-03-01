using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class AssignWorkFlowReturn : ListReturn
    {
        public AssignWorkFlowReturn()
        {
            content = new List<Workflow_Module>();
            paging = new paging();
        }

        /// <summary>
        /// AssignWorkFlow Details
        /// </summary>
        public override object content { get; set; }

    }

}
