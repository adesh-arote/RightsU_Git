using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    public enum State
    {
        Unchanged,
        Added,
        Modified,
        Deleted
    }
    public enum Order
    {
        Asc = 1,
        Desc = 2
    }
    public enum SortColumn
    {
        CreatedDate = 1,
        UpdatedDate = 2,
        TitleName = 3
    }
}
