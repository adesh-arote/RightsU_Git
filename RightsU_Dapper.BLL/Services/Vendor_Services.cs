using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Vendor_Service
    {
        Vendor_Repository objVendor_Repository = new Vendor_Repository();
        public Vendor_Service()
        {
            this.objVendor_Repository = new Vendor_Repository();
        }
        public Vendor GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Vendor> GetAll(Type[] additionalTypes = null)
        {
            return objVendor_Repository.GetAll(additionalTypes);
        }
        public void AddEntity(Vendor obj)
        {
            objVendor_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor obj)
        {
            objVendor_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor obj)
        {
            objVendor_Repository.Delete(obj);
        }
        public IEnumerable<Vendor> SearchFor(object param)
        {
            return objVendor_Repository.SearchFor(param);
        }

    }
    public class Vendor_Country_Service
    {
        Vendor_Country_Repository objVendor_Country_Repository = new Vendor_Country_Repository();
        public Vendor_Country_Service()
        {
            this.objVendor_Country_Repository = new Vendor_Country_Repository();
        }
        public Vendor_Country GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Country_Repository.Get(ID, RelationList);
        }
        public void AddEntity(Vendor_Country obj)
        {
            objVendor_Country_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor_Country obj)
        {
            objVendor_Country_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor_Country obj)
        {
            objVendor_Country_Repository.Delete(obj);
        }
        public IEnumerable<Vendor_Country> SearchFor(object param)
        {
            return objVendor_Country_Repository.SearchFor(param);
        }
    }
    public class Vendor_Role_Service
    {
        Vendor_Role_Repository objVendor_Role_Repository = new Vendor_Role_Repository();
        public Vendor_Role_Service()
        {
            this.objVendor_Role_Repository = new Vendor_Role_Repository();
        }
        public Vendor_Role GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Role_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Vendor_Role> GetAll()
        {
            return objVendor_Role_Repository.GetAll();
        }
        public void AddEntity(Vendor_Role obj)
        {
            objVendor_Role_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor_Role obj)
        {
            objVendor_Role_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor_Role obj)
        {
            objVendor_Role_Repository.Delete(obj);
        }
        public IEnumerable<Vendor_Role> SearchFor(object param)
        {
            return objVendor_Role_Repository.SearchFor(param);
        }
    }
    public class Party_Category_Service
    {
        Party_Category_Repository objParty_Category_Repository = new Party_Category_Repository();
        public Party_Category_Service()
        {
            this.objParty_Category_Repository = new Party_Category_Repository();
        }
        public Party_Category GetByID(int? ID, Type[] RelationList = null)
        {
            return objParty_Category_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Party_Category> GetAll()
        {
            return objParty_Category_Repository.GetAll();
        }
    }
    public class Party_Group_Service
    {
        Party_Group_Repository objParty_Group_Repository = new Party_Group_Repository();
        public Party_Group_Service()
        {
            this.objParty_Group_Repository = new Party_Group_Repository();
        }
        public Party_Group GetByID(int? ID, Type[] RelationList = null)
        {
            return objParty_Group_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Party_Group> GetAll()
        {
            return objParty_Group_Repository.GetAll();
        }
        public void AddEntity(Party_Group obj)
        {
            objParty_Group_Repository.Add(obj);
        }
        public void UpdateEntity(Party_Group obj)
        {
            objParty_Group_Repository.Update(obj);
        }
        public void DeleteEntity(Party_Group obj)
        {
            objParty_Group_Repository.Delete(obj);
        }
        public IEnumerable<Party_Group> SearchFor(object param)
        {
            return objParty_Group_Repository.SearchFor(param);
        }
    }
    public class Country_Service
    {
        Country_Repository objParty_Country_Repository = new Country_Repository();
        public Country_Service()
        {
            this.objParty_Country_Repository = new Country_Repository();
        }
        public Country GetByID(int? ID, Type[] RelationList = null)
        {
            return objParty_Country_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Country> GetAll()
        {
            return objParty_Country_Repository.GetAll();
        }
        public void AddEntity(Country obj)
        {
            objParty_Country_Repository.Add(obj);
        }
        public void UpdateEntity(Country obj)
        {
            objParty_Country_Repository.Update(obj);
        }
        public void DeleteEntity(Country obj)
        {
            objParty_Country_Repository.Delete(obj);
        }
        public IEnumerable<Country> SearchFor(object param)
        {
            return objParty_Country_Repository.SearchFor(param);
        }
    }
    public class Vendor_Contacts_Service
    {
        Vendor_Contacts_Repository objVendor_Contacts_Repository = new Vendor_Contacts_Repository();
        public Vendor_Contacts_Service()
        {
            this.objVendor_Contacts_Repository = new Vendor_Contacts_Repository();
        }
        public Vendor_Contacts GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Contacts_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Vendor_Contacts> GetAll()
        {
            return objVendor_Contacts_Repository.GetAll();
        }
        public void AddEntity(Vendor_Contacts obj)
        {
            objVendor_Contacts_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor_Contacts obj)
        {
            objVendor_Contacts_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor_Contacts obj)
        {
            objVendor_Contacts_Repository.Delete(obj);
        }
        public IEnumerable<Vendor_Contacts> SearchFor(object param)
        {
            return objVendor_Contacts_Repository.SearchFor(param);
        }
    }
    public class Role_Service
    {
        Role_Repository objRole_Repository = new Role_Repository();
        public Role_Service()
        {
            this.objRole_Repository = new Role_Repository();
        }
        public Role GetByID(int? ID, Type[] RelationList = null)
        {
            return objRole_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Role> GetAll()
        {
            return objRole_Repository.GetAll();
        }
        public void AddEntity(Role obj)
        {
            objRole_Repository.Add(obj);
        }
        public void UpdateEntity(Role obj)
        {
            objRole_Repository.Update(obj);
        }
        public void DeleteEntity(Role obj)
        {
            objRole_Repository.Delete(obj);
        }
        public IEnumerable<Role> SearchFor(object param)
        {
            return objRole_Repository.SearchFor(param);
        }
    }
    public class USP_MODULE_RIGHTS_Service
    {
        USP_MODULE_RIGHTS_Repository objUSP_Repository = new USP_MODULE_RIGHTS_Repository();

        public USP_MODULE_RIGHTS_Service()
        {
            this.objUSP_Repository = new USP_MODULE_RIGHTS_Repository();
        }
        public string USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            return objUSP_Repository.USP_MODULE_RIGHTS(module_Code, security_Group_Code, users_Code);
        }
    }
}
