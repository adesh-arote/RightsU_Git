using Dapper;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.DAL.Infrastructure
{
    public class MainRepository<T> : ProcRepository
    {
        private readonly DBConnection dbConnection;
        public MainRepository()
        {
            this.dbConnection = new DBConnection();
        }
        public void AddEntity(T Obj)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                connection.Create(Obj);
                connection.Close();
            }
        }
        public void UpdateEntity(T oldObj, T newObj)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                connection.Update(oldObj, newObj);
                connection.Close();
            }
        }
        public void DeleteEntity(T Obj)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                connection.Delete(Obj);
                connection.Close();
            }
        }
        public void DeleteAllEntity(IEnumerable<T> List)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                connection.DeleteAll(List);
                connection.Close();
            }
        }
        public T1 GetById<T1>(object param, Type[] additionalTypes = null)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = (dynamic)null;
                if (additionalTypes == null)                list = connection.AutoQuery<T1>(param).FirstOrDefault();
                else                 list = connection.AutoQuery<T1>(additionalTypes, param).FirstOrDefault();

                connection.Close();
                return list;
            }
        }
        public T1 GetById<T1, T2>(object param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                T1 obj = connection.AutoQuery<T1, T2>(param).FirstOrDefault();
                connection.Close();
                return obj;
            }
        }
        public T1 GetById<T1, T2, T3>(object param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                T1 obj = connection.AutoQuery<T1, T2, T3>(param).FirstOrDefault();
                connection.Close();
                return obj;
            }
        }
        public T1 GetById<T1, T2, T3, T4>(object param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                T1 obj = connection.AutoQuery<T1, T2, T3, T4>(param).FirstOrDefault();
                connection.Close();
                return obj;
            }
        }
        public IEnumerable<T> GetAll<T1>(Type[] additionalTypes = null)        {            using (var connection = dbConnection.Connection())            {                connection.Open();                var list = (dynamic)null;                if (additionalTypes == null)                    list = connection.AutoQuery<T1>(null).ToList();
                else                    list = connection.AutoQuery<T1>(additionalTypes, null).ToList();                connection.Close();                return (IEnumerable<T>)list;            }        }
        public IEnumerable<T> GetAll<T1, T2>()
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = connection.AutoQuery<T1, T2>(null).ToList();
                connection.Close();
                return (IEnumerable<T>)list;
            }
        }
        public IEnumerable<T> GetAll<T1, T2, T3>()
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = connection.AutoQuery<T1, T2, T3>(null).ToList();
                connection.Close();
                return (IEnumerable<T>)list;
            }
        }
        public IEnumerable<T> GetAll<T1, T2, T3, T4>()
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = connection.AutoQuery<T1, T2, T3, T4>(null).ToList();
                connection.Close();
                return (IEnumerable<T>)list;
            }
        }
        public IEnumerable<T1> SearchForEntity<T1>(object param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = connection.AutoQuery<T1>(param).ToList();
                connection.Close();
                return (IEnumerable<T1>)list;
            }
        }
        public IEnumerable<T1> SearchForEntity<T1, T2>(object param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = connection.AutoQuery<T1, T2>(param).ToList();
                connection.Close();
                return (IEnumerable<T1>)list;
            }
        }
        public IEnumerable<T1> SearchForEntity<T1, T2, T3>(object param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = connection.AutoQuery<T1, T2, T3>(param).ToList();
                connection.Close();
                return (IEnumerable<T1>)list;
            }
        }
        public IEnumerable<T1> SearchForEntity<T1, T2, T3, T4>(object param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                var list = connection.AutoQuery<T1, T2, T3, T4>(param).ToList();
                connection.Close();
                return (IEnumerable<T1>)list;
            }
        }
    }
}
