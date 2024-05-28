using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_DAL
{
    public class DatabaseFactory : Disposable, IDatabaseFactory
    {
        private RightsU_NeoEntities dataContext;
        public RightsU_NeoEntities Get(string conStr)
        {
            return dataContext ?? (dataContext = new RightsU_NeoEntities(conStr));
        }
        protected override void DisposeCore()
        {
            if (dataContext != null)
                dataContext.Dispose();
        }
    }
}
