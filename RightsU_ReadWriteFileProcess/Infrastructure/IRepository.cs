using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_ReadWriteFileProcess.Infrastructure
{
    interface IRepository<T>
    {
        T Get(int Id);
        IEnumerable<T> GetAll();
        void Add(T entity);
        void Delete(T entity);
        void Update(T entity);
        IEnumerable<T> SearchFor(object param);
    }
}
