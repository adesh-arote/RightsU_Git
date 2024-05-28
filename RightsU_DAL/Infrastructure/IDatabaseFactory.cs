using System;

namespace RightsU_DAL
{
    public interface IDatabaseFactory : IDisposable
    {
        RightsU_NeoEntities Get(string conStr);
    }
}
