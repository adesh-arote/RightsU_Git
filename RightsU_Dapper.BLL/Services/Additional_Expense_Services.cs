using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Additional_Expense_Services
    {
        Addtional_Expense_Repository objAddtional_Expense_Repository = new Addtional_Expense_Repository();
        public Additional_Expense_Services()
        {
            this.objAddtional_Expense_Repository = new Addtional_Expense_Repository();
        }
        public Additional_Expense GetByID(int? ID, Type[] RelationList = null)
        {
            return objAddtional_Expense_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Additional_Expense> GetAll(Type[] additionalTypes = null)
        {
            return objAddtional_Expense_Repository.GetAll();
        }
        public void AddEntity(Additional_Expense obj)
        {
            objAddtional_Expense_Repository.Add(obj);
        }
        public void UpdateEntity(Additional_Expense obj)
        {
            objAddtional_Expense_Repository.Update(obj);
        }
        public void DeleteEntity(Additional_Expense obj)
        {
            objAddtional_Expense_Repository.Delete(obj);
        }
        public IEnumerable<Additional_Expense> SearchFor(object param)
        {
            return objAddtional_Expense_Repository.SearchFor(param);
        }
    }
}

