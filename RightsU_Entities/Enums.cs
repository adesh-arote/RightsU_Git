using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public enum State
    {
        Unchanged,
        Added,
        Modified,
        Deleted
    }

    public enum ActionType
    {
        C,
        X,
        U,
        A,
        D,
    }
    public enum order
    {
        Asc = 1,
        Desc = 2
    }
    public enum sort
    {
        IntCode = 1,
        Version = 2
    }
}
