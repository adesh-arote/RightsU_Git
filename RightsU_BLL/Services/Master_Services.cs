using RightsU_DAL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace RightsU_BLL
{
    /// <summary>
    /// Add Master Service Classes Here
    /// </summary>
    public class Ancillary_Medium_Service
    {
        private readonly Ancillary_Medium_Repository objAD;
        public Ancillary_Medium_Service(string Connection_Str)
        {
            this.objAD = new Ancillary_Medium_Repository(Connection_Str);
        }
        public IQueryable<Ancillary_Medium> SearchFor(Expression<Func<Ancillary_Medium, bool>> predicate)
        {
            return objAD.SearchFor(predicate);
        }

        public Ancillary_Medium GetById(int id)
        {
            return objAD.GetById(id);
        }

        public void Save(Ancillary_Medium objD)
        {
            objAD.Save(objD);
        }

    }

    public class Ancillary_Type_Service
    {
        private readonly Ancillary_Type_Repository objAD;

        public Ancillary_Type_Service(string Connection_Str)
        {
            this.objAD = new Ancillary_Type_Repository(Connection_Str);
        }
        public IQueryable<Ancillary_Type> SearchFor(Expression<Func<Ancillary_Type, bool>> predicate)
        {
            return objAD.SearchFor(predicate);
        }

        public Ancillary_Type GetById(int id)
        {
            return objAD.GetById(id);
        }

        public void Save(Ancillary_Type objD)
        {
            objAD.Save(objD);
        }

    }

    public class Ancillary_Platform_Service
    {
        private readonly Ancillary_Platform_Repository objAD;

        public Ancillary_Platform_Service(string Connection_Str)
        {
            this.objAD = new Ancillary_Platform_Repository(Connection_Str);
        }
        public IQueryable<Ancillary_Platform> SearchFor(Expression<Func<Ancillary_Platform, bool>> predicate)
        {
            return objAD.SearchFor(predicate);
        }

        public Ancillary_Platform GetById(int id)
        {
            return objAD.GetById(id);
        }

        public void Save(Ancillary_Platform objD)
        {
            objAD.Save(objD);
        }

    }

    public class Ancillary_Platform_Medium_Service
    {
        private readonly Ancillary_Platform_Medium_Repository objAD;

        public Ancillary_Platform_Medium_Service(string Connection_Str)
        {
            this.objAD = new Ancillary_Platform_Medium_Repository(Connection_Str);
        }
        public IQueryable<Ancillary_Platform_Medium> SearchFor(Expression<Func<Ancillary_Platform_Medium, bool>> predicate)
        {
            return objAD.SearchFor(predicate);
        }

        public Ancillary_Platform_Medium GetById(int id)
        {
            return objAD.GetById(id);
        }

        public void Save(Ancillary_Platform_Medium objD)
        {
            objAD.Save(objD);
        }

    }

    public class Language_Service : BusinessLogic<Language>
    {
        private readonly Language_Repository objRepository;

        public Language_Service(string Connection_Str)
        {
            this.objRepository = new Language_Repository(Connection_Str);
        }
        public IQueryable<Language> SearchFor(Expression<Func<Language, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Language GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Language objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Language objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Language objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Language objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Language objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Language objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Language objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Language_Name == objToValidate.Language_Name && s.Language_Code != objToValidate.Language_Code).Count() > 0)
            {
                resultSet = "Language already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class Language_Group_Service : BusinessLogic<Language_Group>
    {
        private readonly Language_Group_Repository objRepository;

        public Language_Group_Service(string Connection_Str)
        {
            this.objRepository = new Language_Group_Repository(Connection_Str);
        }
        public IQueryable<Language_Group> SearchFor(Expression<Func<Language_Group, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Language_Group GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Language_Group objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Language_Group objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Language_Group objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Language_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Language_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Language_Group objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Language_Group objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Language_Group_Name == objToValidate.Language_Group_Name && s.Language_Group_Code != objToValidate.Language_Group_Code).Count() > 0)
            {
                resultSet = "language group already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Title_Service : BusinessLogic<Title>
    {
        private readonly Title_Repository objTitleR;

        public Title_Service(string Connection_Str)
        {
            this.objTitleR = new Title_Repository(Connection_Str);
        }

        public IQueryable<Title> SearchFor(Expression<Func<Title, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Title GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Title objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Title objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Title objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Country_Service : BusinessLogic<Country>
    {
        private readonly Country_Repository objRepository;

        public Country_Service(string Connection_Str)
        {
            this.objRepository = new Country_Repository(Connection_Str);
        }

        public IQueryable<Country> SearchFor(Expression<Func<Country, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Country GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Country objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Country objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Country objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Country objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Country objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Country objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Country objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Country_Name.Trim() == objToValidate.Country_Name.Trim() && s.Country_Code != objToValidate.Country_Code).Count() > 0)
            {
                resultSet = "Country already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class Title_Release_Service : BusinessLogic<Title_Release>
    {
        private readonly Title_Release_Repository objRepository;

        public Title_Release_Service(string Connection_Str)
        {
            this.objRepository = new Title_Release_Repository(Connection_Str);
        }
        public IQueryable<Title_Release> SearchFor(Expression<Func<Title_Release, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Release GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Delete(Title_Release obj, out dynamic resultSet)
        {
            return base.Delete(obj, objRepository, out resultSet);
        }

        public override bool Validate(Title_Release objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Release objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Release objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Title_Release_Platform_Service
    {
        private readonly Title_Release_Platform_Repository objTitle_Release_Platform;

        public Title_Release_Platform_Service(string Connection_Str)
        {
            this.objTitle_Release_Platform = new Title_Release_Platform_Repository(Connection_Str);
        }
        public IQueryable<Title_Release_Platforms> SearchFor(Expression<Func<Title_Release_Platforms, bool>> predicate)
        {
            return objTitle_Release_Platform.SearchFor(predicate);
        }

        public Title_Release_Platforms GetById(int id)
        {
            return objTitle_Release_Platform.GetById(id);
        }
    }

    public class Title_Release_Region_Service
    {
        private readonly Title_Release_Region_Repository objTitle_Release_Region;

        public Title_Release_Region_Service(string Connection_Str)
        {
            this.objTitle_Release_Region = new Title_Release_Region_Repository(Connection_Str);
        }

        public IQueryable<Title_Release_Region> SearchFor(Expression<Func<Title_Release_Region, bool>> predicate)
        {
            return objTitle_Release_Region.SearchFor(predicate);
        }

        public Title_Release_Region GetById(int id)
        {
            return objTitle_Release_Region.GetById(id);
        }
    }

    public class Territory_Service : BusinessLogic<Territory>
    {
        private readonly Territory_Repository objRepository;

        public Territory_Service(string Connection_Str)
        {
            this.objRepository = new Territory_Repository(Connection_Str);
        }
        public IQueryable<Territory> SearchFor(Expression<Func<Territory, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Territory GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Territory objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Territory objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Territory objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Territory objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Territory objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Territory objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Territory objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Territory_Name == objToValidate.Territory_Name && s.Territory_Code != objToValidate.Territory_Code).Count() > 0)
            {
                resultSet = "Territory already exists";
                return false;
            }
            resultSet = "";
            return true;
        }
    }

    public class Platform_Service
    {
        private readonly Platform_Repository objPlatform;

        public Platform_Service(string Connection_Str)
        {
            this.objPlatform = new Platform_Repository(Connection_Str);
        }
        public IQueryable<Platform> SearchFor(Expression<Func<Platform, bool>> predicate)
        {
            return objPlatform.SearchFor(predicate);
        }

        public Platform GetById(int id)
        {
            return objPlatform.GetById(id);
        }
    }

    public class Vendor_Service : BusinessLogic<Vendor>
    {
        private readonly Vendor_Repository objRepository;

        public Vendor_Service(string Connection_Str)
        {
            this.objRepository = new Vendor_Repository(Connection_Str);
        }
        public IQueryable<Vendor> SearchFor(Expression<Func<Vendor, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Vendor GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Vendor objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Vendor objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Vendor objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Vendor objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Vendor objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Vendor objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Vendor objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Vendor_Name == objToValidate.Vendor_Name && s.Vendor_Code != objToValidate.Vendor_Code).Count() > 0)
            {
                resultSet = "Party already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Channel_Service : BusinessLogic<Channel>
    {
        private readonly Channel_Repository objRepository;

        public Channel_Service(string Connection_Str)
        {
            this.objRepository = new Channel_Repository(Connection_Str);
        }

        public IQueryable<Channel> SearchFor(Expression<Func<Channel, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Channel GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Channel objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Channel objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Channel objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Channel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Channel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Channel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Channel objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Channel_Name == objToValidate.Channel_Name && s.Channel_Code != objToValidate.Channel_Code).Count() > 0)
            {
                resultSet = "Channel already exists";
                return false;
            }
            resultSet = "";
            return true;
        }
    }

    public class Currency_Service : BusinessLogic<Currency>
    {
        private readonly Currency_Repository objRepository;

        public Currency_Service(string Connection_Str)
        {
            this.objRepository = new Currency_Repository(Connection_Str);
        }
        public IQueryable<Currency> SearchFor(Expression<Func<Currency, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Currency GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Currency objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Currency objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Currency objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Currency objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Currency objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Currency objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Currency objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Currency_Name == objToValidate.Currency_Name && s.Currency_Code != objToValidate.Currency_Code).Count() > 0)
            {
                resultSet = "Currency already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Additional_Expense_Service : BusinessLogic<Additional_Expense>
    {
        private readonly Additional_Expense_Repository objRepository;

        public Additional_Expense_Service(string Connection_Str)
        {
            this.objRepository = new Additional_Expense_Repository(Connection_Str);
        }
        public IQueryable<Additional_Expense> SearchFor(Expression<Func<Additional_Expense, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Additional_Expense GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Additional_Expense objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Additional_Expense objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Additional_Expense objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Additional_Expense objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Additional_Expense objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Additional_Expense objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Additional_Expense objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Additional_Expense_Name.ToUpper() == objToValidate.Additional_Expense_Name.ToUpper() &&
                s.Additional_Expense_Code != objToValidate.Additional_Expense_Code).Count();
                if (duplicateRecordCount > 0)
                {
                    resultSet = "Additional expenses already exists";
                    return false;
                }
            }
            resultSet = "";
            return true;
        }
    }

    public class Cost_Type_Service : BusinessLogic<Cost_Type>
    {
        private readonly Cost_Type_Repository objRepository;

        public Cost_Type_Service(string Connection_Str)
        {
            this.objRepository = new Cost_Type_Repository(Connection_Str);
        }
        public IQueryable<Cost_Type> SearchFor(Expression<Func<Cost_Type, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Cost_Type GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Cost_Type objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Cost_Type objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Cost_Type objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Cost_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Cost_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Cost_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(Cost_Type objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Cost_Type_Name.ToUpper() == objToValidate.Cost_Type_Name.ToUpper() &&
                    s.Cost_Type_Code != objToValidate.Cost_Type_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Cost Type already exists";
                    return false;
                }
            }
            resultSet = "";
            return true;
        }
    }
    public class Payment_Terms_Service : BusinessLogic<Payment_Terms>
    {
        private readonly Payment_Terms_Repository objRepository;

        public Payment_Terms_Service(string Connection_Str)
        {
            this.objRepository = new Payment_Terms_Repository(Connection_Str);
        }
        public IQueryable<Payment_Terms> SearchFor(Expression<Func<Payment_Terms, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Payment_Terms GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Payment_Terms objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Payment_Terms objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Payment_Terms objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Payment_Terms objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Payment_Terms objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Payment_Terms objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(Payment_Terms objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Payment_Terms1.ToUpper() == objToValidate.Payment_Terms1.ToUpper() &&
                    s.Payment_Terms_Code != objToValidate.Payment_Terms_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Payment Terms already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }

    public class Milestone_Type_Service
    {
        private readonly Milestone_Type_Repository objMilestone_Type;

        public Milestone_Type_Service(string Connection_Str)
        {
            this.objMilestone_Type = new Milestone_Type_Repository(Connection_Str);
        }

        public IQueryable<Milestone_Type> SearchFor(Expression<Func<Milestone_Type, bool>> predicate)
        {
            return objMilestone_Type.SearchFor(predicate);
        }

        public Milestone_Type GetById(int id)
        {
            return objMilestone_Type.GetById(id);
        }
    }

    public class Users_Business_Unit_Service : BusinessLogic<Users_Business_Unit>
    {
        private readonly Users_Business_Unit_Repository objUsers_Business_Unit;

        public Users_Business_Unit_Service(string Connection_Str)
        {
            this.objUsers_Business_Unit = new Users_Business_Unit_Repository(Connection_Str);
        }


        public IQueryable<Users_Business_Unit> SearchFor(Expression<Func<Users_Business_Unit, bool>> predicate)
        {
            return objUsers_Business_Unit.SearchFor(predicate);
        }

        public Users_Business_Unit GetById(int id)
        {
            return objUsers_Business_Unit.GetById(id);
        }
        public bool Save(Users_Business_Unit objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objUsers_Business_Unit, out resultSet);
        }

        public override bool Validate(Users_Business_Unit objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Users_Business_Unit objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Users_Business_Unit objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }


    public class Deal_Type_Service
    {
        private readonly Deal_Type_Repository objDeal_Type;

        public Deal_Type_Service(string Connection_Str)
        {
            this.objDeal_Type = new Deal_Type_Repository(Connection_Str);
        }

        public IQueryable<Deal_Type> SearchFor(Expression<Func<Deal_Type, bool>> predicate)
        {
            return objDeal_Type.SearchFor(predicate);
        }

        public Deal_Type GetById(int id)
        {
            return objDeal_Type.GetById(id);
        }
    }

    public class Deal_Tag_Service
    {
        private readonly Deal_Tag_Repository objDeal_Tag;
        //public Deal_Tag_Service()
        //{
        //    this.objDeal_Tag = new Deal_Tag_Repository(DBConnection.Connection_Str);
        //}
        public Deal_Tag_Service(string Connection_Str)
        {
            this.objDeal_Tag = new Deal_Tag_Repository(Connection_Str);
        }

        public IQueryable<Deal_Tag> SearchFor(Expression<Func<Deal_Tag, bool>> predicate)
        {
            return objDeal_Tag.SearchFor(predicate);
        }

        public Deal_Tag GetById(int id)
        {
            return objDeal_Tag.GetById(id);
        }
    }

    public class Sub_License_Service
    {
        private readonly Sub_License_Repository objSub_License;

        public Sub_License_Service(string Connection_Str)
        {
            this.objSub_License = new Sub_License_Repository(Connection_Str);
        }

        public IQueryable<Sub_License> SearchFor(Expression<Func<Sub_License, bool>> predicate)
        {
            return objSub_License.SearchFor(predicate);
        }

        public Sub_License GetById(int id)
        {
            return objSub_License.GetById(id);
        }
    }

    public class Royalty_Recoupment_Service : BusinessLogic<Royalty_Recoupment>
    {
        private readonly Royalty_Recoupment_Repository objRepository;
        //public Royalty_Recoupment_Service()
        //{
        //    this.objRepository = new Royalty_Recoupment_Repository(DBConnection.Connection_Str);
        //}
        public Royalty_Recoupment_Service(string Connection_Str)
        {
            this.objRepository = new Royalty_Recoupment_Repository(Connection_Str);
        }
        public IQueryable<Royalty_Recoupment> SearchFor(Expression<Func<Royalty_Recoupment, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Royalty_Recoupment GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Royalty_Recoupment objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Royalty_Recoupment objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Royalty_Recoupment objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Royalty_Recoupment objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Royalty_Recoupment objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Royalty_Recoupment objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Royalty_Recoupment objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Royalty_Recoupment_Name.ToUpper() == objToValidate.Royalty_Recoupment_Name.ToUpper() &&
                    s.Royalty_Recoupment_Code != objToValidate.Royalty_Recoupment_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Royalty Recoupment already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }

    public class Business_Unit_Service : BusinessLogic<Business_Unit>
    {
        private readonly Business_Unit_Repository objBusiness_Unit_Repository;

        public Business_Unit_Service(string Connection_Str)
        {
            this.objBusiness_Unit_Repository = new Business_Unit_Repository(Connection_Str);
        }
        public IQueryable<Business_Unit> SearchFor(Expression<Func<Business_Unit, bool>> predicate)
        {
            return objBusiness_Unit_Repository.SearchFor(predicate);
        }

        public Business_Unit GetById(int id)
        {
            return objBusiness_Unit_Repository.GetById(id);
        }
        public bool Save(Business_Unit objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objBusiness_Unit_Repository, out resultSet);
        }
        public override bool Validate(Business_Unit objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Business_Unit objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Business_Unit objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Promoter_Group_Service
    {
        private readonly Promoter_Group_Repository objPromoter_Group;

        public Promoter_Group_Service(string Connection_Str)
        {
            this.objPromoter_Group = new Promoter_Group_Repository(Connection_Str);
        }
        public IQueryable<Promoter_Group> SearchFor(Expression<Func<Promoter_Group, bool>> predicate)
        {
            return objPromoter_Group.SearchFor(predicate);
        }

        public Promoter_Group GetById(int id)
        {
            return objPromoter_Group.GetById(id);
        }
    }
    public class Promoter_Remarks_Service : BusinessLogic<Promoter_Remarks>
    {
        private readonly Promoter_Remarks_Repository objPromoter_Remarks;

        public Promoter_Remarks_Service(string Connection_Str)
        {
            this.objPromoter_Remarks = new Promoter_Remarks_Repository(Connection_Str);
        }
        public IQueryable<Promoter_Remarks> SearchFor(Expression<Func<Promoter_Remarks, bool>> predicate)
        {
            return objPromoter_Remarks.SearchFor(predicate);
        }

        public Promoter_Remarks GetById(int id)
        {
            return objPromoter_Remarks.GetById(id);
        }
        public bool Save(Promoter_Remarks objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objPromoter_Remarks, out resultSet);
        }

        public bool Update(Promoter_Remarks objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objPromoter_Remarks, out resultSet);
        }

        public bool Delete(Promoter_Remarks objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objPromoter_Remarks, out resultSet);
        }

        public override bool Validate(Promoter_Remarks objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Promoter_Remarks objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Promoter_Remarks objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Promoter_Remarks objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Promoter_Remark_Desc.ToUpper() == objToValidate.Promoter_Remark_Desc.ToUpper() &&
                    s.Promoter_Remarks_Code != objToValidate.Promoter_Remarks_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Promoter Remark already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }
    public class Category_Service : BusinessLogic<Category>
    {
        private readonly Category_Repository objRepository;

        public Category_Service(string Connection_Str)
        {
            this.objRepository = new Category_Repository(Connection_Str);
        }
        public IQueryable<Category> SearchFor(Expression<Func<Category, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Category GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Category objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Category objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Category objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Category objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Category objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Category objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(Category objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Category_Name == objToValidate.Category_Name && s.Category_Code != objToValidate.Category_Code).Count() > 0)
            {
                resultSet = "Category already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Entity_Service : BusinessLogic<Entity>
    {
        private readonly Entity_Repository objEntityRepository;

        public Entity_Service(string Connection_Str)
        {
            this.objEntityRepository = new Entity_Repository(Connection_Str);
        }

        public IQueryable<Entity> SearchFor(Expression<Func<Entity, bool>> predicate)
        {
            return objEntityRepository.SearchFor(predicate);
        }

        public Entity GetById(int id)
        {
            return objEntityRepository.GetById(id);
        }
        public bool Save(Entity objEntity, out dynamic resultSet)
        {
            return base.Save(objEntity, objEntityRepository, out resultSet);
        }
        public override bool Validate(Entity objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Entity objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Entity objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Territory_Details_Service
    {
        private readonly Territory_Details_Repository objTerritory_Details;

        public Territory_Details_Service(string Connection_Str)
        {
            this.objTerritory_Details = new Territory_Details_Repository(Connection_Str);
        }
        public IQueryable<Territory_Details> SearchFor(Expression<Func<Territory_Details, bool>> predicate)
        {
            return objTerritory_Details.SearchFor(predicate);
        }

        public Territory_Details GetById(int id)
        {
            return objTerritory_Details.GetById(id);
        }
    }

    public class Vendor_Contacts_Service : BusinessLogic<Vendor_Contacts>
    {
        private readonly Vendor_Contacts_Repository objRepository;

        public Vendor_Contacts_Service(string Connection_Str)
        {
            this.objRepository = new Vendor_Contacts_Repository(Connection_Str);
        }
        public IQueryable<Vendor_Contacts> SearchFor(Expression<Func<Vendor_Contacts, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Vendor_Contacts GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Vendor_Contacts objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Vendor_Contacts objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Vendor_Contacts objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Vendor_Contacts objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Vendor_Contacts objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Vendor_Contacts objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Right_Rule_Service : BusinessLogic<Right_Rule>
    {
        private readonly Right_Rule_Repository objRepository;

        public Right_Rule_Service(string Connection_Str)
        {
            this.objRepository = new Right_Rule_Repository(Connection_Str);
        }
        public IQueryable<Right_Rule> SearchFor(Expression<Func<Right_Rule, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Right_Rule GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Right_Rule objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Right_Rule objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Right_Rule objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Right_Rule objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Right_Rule objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Right_Rule objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Right_Rule objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Right_Rule_Name == objToValidate.Right_Rule_Name && s.Right_Rule_Code != objToValidate.Right_Rule_Code).Count() > 0)
            {
                resultSet = "Right Rule already exists";
                return false;
            }
            resultSet = "";
            return true;
        }
    }

    public class Material_Medium_Service : BusinessLogic<Material_Medium>
    {
        private readonly Material_Medium_Repository objRepository;

        public Material_Medium_Service(string Connection_Str)
        {
            this.objRepository = new Material_Medium_Repository(Connection_Str);
        }
        public IQueryable<Material_Medium> SearchFor(Expression<Func<Material_Medium, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Material_Medium GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Material_Medium objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Material_Medium objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Material_Medium objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Material_Medium objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Material_Medium objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Material_Medium objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Material_Medium objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Material_Medium_Name.ToUpper() == objToValidate.Material_Medium_Name.ToUpper() &&
                    s.Material_Medium_Code != objToValidate.Material_Medium_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Material Medium already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }

    public class Material_Type_Service : BusinessLogic<Material_Type>
    {
        private readonly Material_Type_Repository objRepository;

        public Material_Type_Service(string Connection_Str)
        {
            this.objRepository = new Material_Type_Repository(Connection_Str);
        }
        public IQueryable<Material_Type> SearchFor(Expression<Func<Material_Type, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Material_Type GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Material_Type objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Material_Type objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Material_Type objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Material_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Material_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Material_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Material_Type objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Material_Type_Name.ToUpper() == objToValidate.Material_Type_Name.ToUpper() &&
                    s.Material_Type_Code != objToValidate.Material_Type_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Material Type already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }

    public class Role_Service
    {
        private readonly Role_Repository objRole;

        public Role_Service(string Connection_Str)
        {
            this.objRole = new Role_Repository(Connection_Str);
        }
        public IQueryable<Role> SearchFor(Expression<Func<Role, bool>> predicate)
        {
            return objRole.SearchFor(predicate);
        }

        public Role GetById(int id)
        {
            return objRole.GetById(id);
        }
    }

    public class System_Parameter_New_Service : BusinessLogic<System_Parameter_New>
    {
        private readonly System_Parameter_New_Repository objRepository;

        public System_Parameter_New_Service(string Connection_Str)
        {
            this.objRepository = new System_Parameter_New_Repository(Connection_Str);
        }
        public IQueryable<System_Parameter_New> SearchFor(Expression<Func<System_Parameter_New, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public System_Parameter_New GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(System_Parameter_New objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(System_Parameter_New objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(System_Parameter_New objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(System_Parameter_New objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(System_Parameter_New objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(System_Parameter_New objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Document_Type_Service : BusinessLogic<Document_Type>
    {
        private readonly Document_Type_Repository objRepository;

        public Document_Type_Service(string Connection_Str)
        {
            this.objRepository = new Document_Type_Repository(Connection_Str);
        }
        public IQueryable<Document_Type> SearchFor(Expression<Func<Document_Type, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Document_Type GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Document_Type objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Document_Type objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Document_Type objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Document_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Document_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Document_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(Document_Type objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Document_Type_Name.ToUpper() == objToValidate.Document_Type_Name.ToUpper() &&
                    s.Document_Type_Code != objToValidate.Document_Type_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Document Type already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }

    public class Module_Status_History_Type_Service : BusinessLogic<Module_Status_History>
    {
        private readonly Module_Status_History_Type_Repository objAD;

        public Module_Status_History_Type_Service(string Connection_Str)
        {
            this.objAD = new Module_Status_History_Type_Repository(Connection_Str);
        }
        public IQueryable<Module_Status_History> SearchFor(Expression<Func<Module_Status_History, bool>> predicate)
        {
            return objAD.SearchFor(predicate);
        }

        public Module_Status_History GetById(int id)
        {
            return objAD.GetById(id);
        }

        public bool Save(Module_Status_History objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objAD, out resultSet);
        }

        public bool Update(Module_Status_History objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objAD, out resultSet);
        }

        public bool Delete(Module_Status_History objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objAD, out resultSet);
        }

        public override bool Validate(Module_Status_History objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Module_Status_History objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Module_Status_History objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class User_Service : BusinessLogic<User>
    {
        private readonly User_Repository objRepository;

        public User_Service(string Connection_Str)
        {
            this.objRepository = new User_Repository(Connection_Str);
        }
        public IQueryable<User> SearchFor(Expression<Func<User, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public User GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public void Save(User objD)
        {
            objRepository.Save(objD);
        }

        public bool Save(User objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(User objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(User objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(User objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(User objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(User objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(User objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Login_Name.ToUpper() == objToValidate.Login_Name.ToUpper() &&
                    s.Users_Code != objToValidate.Users_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Login name already exists";
                    return false;
                }
                if (objToValidate.Validate_Email)
                {
                    duplicateRecordCount = 0;
                    duplicateRecordCount = SearchFor(s => s.Email_Id.ToUpper() == objToValidate.Email_Id.ToUpper() &&
                        s.Users_Code != objToValidate.Users_Code).Count();

                    if (duplicateRecordCount > 0)
                    {
                        resultSet = "Email Id already exists";
                        return false;
                    }
                }
            }

            resultSet = "";
            return true;
        }
    }

    public class Monetisation_Type_Service
    {
        private readonly Monetisation_Type_Repository objMonetisation_Type;

        public Monetisation_Type_Service(string Connection_Str)
        {
            this.objMonetisation_Type = new Monetisation_Type_Repository(Connection_Str);
        }
        public IQueryable<Monetisation_Type> SearchFor(Expression<Func<Monetisation_Type, bool>> predicate)
        {
            return objMonetisation_Type.SearchFor(predicate);
        }

        public Monetisation_Type GetById(int id)
        {
            return objMonetisation_Type.GetById(id);
        }
    }

    public class Module_Workflow_Detail_Service
    {
        private readonly Module_Workflow_Detail_Repository objModule_Workflow_Detail;

        public Module_Workflow_Detail_Service(string Connection_Str)
        {
            this.objModule_Workflow_Detail = new Module_Workflow_Detail_Repository(Connection_Str);
        }
        public IQueryable<Module_Workflow_Detail> SearchFor(Expression<Func<Module_Workflow_Detail, bool>> predicate)
        {
            return objModule_Workflow_Detail.SearchFor(predicate);
        }

        public Module_Workflow_Detail GetById(int id)
        {
            return objModule_Workflow_Detail.GetById(id);
        }
    }

    public class Sponsor_Service
    {
        private readonly Sponsor_Repository objSponsor;

        public Sponsor_Service(string Connection_Str)
        {
            this.objSponsor = new Sponsor_Repository(Connection_Str);
        }
        public IQueryable<Sponsor> SearchFor(Expression<Func<Sponsor, bool>> predicate)
        {
            return objSponsor.SearchFor(predicate);
        }

        public Sponsor GetById(int id)
        {
            return objSponsor.GetById(id);
        }

        public void Save(Sponsor objD)
        {
            objSponsor.Save(objD);
        }

        public void Delete(Sponsor objD)
        {
            objSponsor.Delete(objD);
        }

    }

    public class Sport_Ancillary_Broadcast_Service
    {
        private readonly Sport_Ancillary_Broadcast_Repository objSport_Ancillary_Broadcast;

        public Sport_Ancillary_Broadcast_Service(string Connection_Str)
        {
            this.objSport_Ancillary_Broadcast = new Sport_Ancillary_Broadcast_Repository(Connection_Str);
        }
        public IQueryable<Sport_Ancillary_Broadcast> SearchFor(Expression<Func<Sport_Ancillary_Broadcast, bool>> predicate)
        {
            return objSport_Ancillary_Broadcast.SearchFor(predicate);
        }

        public Sport_Ancillary_Broadcast GetById(int id)
        {
            return objSport_Ancillary_Broadcast.GetById(id);
        }
    }

    public class Sport_Ancillary_Config_Service
    {
        private readonly Sport_Ancillary_Config_Repository objSport_Ancillary_Config;

        public Sport_Ancillary_Config_Service(string Connection_Str)
        {
            this.objSport_Ancillary_Config = new Sport_Ancillary_Config_Repository(Connection_Str);
        }
        public IQueryable<Sport_Ancillary_Config> SearchFor(Expression<Func<Sport_Ancillary_Config, bool>> predicate)
        {
            return objSport_Ancillary_Config.SearchFor(predicate);
        }

        public Sport_Ancillary_Config GetById(int id)
        {
            return objSport_Ancillary_Config.GetById(id);
        }
    }

    public class Sport_Ancillary_Periodicity_Service
    {
        private readonly Sport_Ancillary_Periodicity_Repository objSport_Ancillary_Periodicity;

        public Sport_Ancillary_Periodicity_Service(string Connection_Str)
        {
            this.objSport_Ancillary_Periodicity = new Sport_Ancillary_Periodicity_Repository(Connection_Str);
        }
        public IQueryable<Sport_Ancillary_Periodicity> SearchFor(Expression<Func<Sport_Ancillary_Periodicity, bool>> predicate)
        {
            return objSport_Ancillary_Periodicity.SearchFor(predicate);
        }

        public Sport_Ancillary_Periodicity GetById(int id)
        {
            return objSport_Ancillary_Periodicity.GetById(id);
        }
    }

    public class Sport_Ancillary_Source_Service
    {
        private readonly Sport_Ancillary_Source_Repository objSport_Ancillary_Source;

        public Sport_Ancillary_Source_Service(string Connection_Str)
        {
            this.objSport_Ancillary_Source = new Sport_Ancillary_Source_Repository(Connection_Str);
        }
        public IQueryable<Sport_Ancillary_Source> SearchFor(Expression<Func<Sport_Ancillary_Source, bool>> predicate)
        {
            return objSport_Ancillary_Source.SearchFor(predicate);
        }

        public Sport_Ancillary_Source GetById(int id)
        {
            return objSport_Ancillary_Source.GetById(id);
        }



    }

    public class Sport_Ancillary_Type_Service
    {
        private readonly Sport_Ancillary_Type_Repository objSport_Ancillary_Type;

        public Sport_Ancillary_Type_Service(string Connection_Str)
        {
            this.objSport_Ancillary_Type = new Sport_Ancillary_Type_Repository(Connection_Str);
        }
        public IQueryable<Sport_Ancillary_Type> SearchFor(Expression<Func<Sport_Ancillary_Type, bool>> predicate)
        {
            return objSport_Ancillary_Type.SearchFor(predicate);
        }

        public Sport_Ancillary_Type GetById(int id)
        {
            return objSport_Ancillary_Type.GetById(id);
        }
    }

    public class Broadcast_Mode_Service : BusinessLogic<Broadcast_Mode>
    {
        private readonly Broadcast_Mode_Repository objBroadcast_Mode_Repository;

        public Broadcast_Mode_Service(string Connection_Str)
        {
            this.objBroadcast_Mode_Repository = new Broadcast_Mode_Repository(Connection_Str);
        }
        public IQueryable<Broadcast_Mode> SearchFor(Expression<Func<Broadcast_Mode, bool>> predicate)
        {
            return objBroadcast_Mode_Repository.SearchFor(predicate);
        }

        public Broadcast_Mode GetById(int id)
        {
            return objBroadcast_Mode_Repository.GetById(id);
        }

        public override bool Validate(Broadcast_Mode objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Broadcast_Mode objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Broadcast_Mode objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class BV_HouseId_Data_Service
    {
        private readonly BV_HouseId_Data_Repository objAD;

        public BV_HouseId_Data_Service(string Connection_Str)
        {
            this.objAD = new BV_HouseId_Data_Repository(Connection_Str);
        }
        public IQueryable<BV_HouseId_Data> SearchFor(Expression<Func<BV_HouseId_Data, bool>> predicate)
        {
            return objAD.SearchFor(predicate);
        }

        public BV_HouseId_Data GetById(int id)
        {
            return objAD.GetById(id);
        }

        public void Save(BV_HouseId_Data objD)
        {
            objAD.Update(objD);
        }

    }

    public class SAP_WBS_Service : BusinessLogic<SAP_WBS>
    {
        private readonly SAP_WBS_Repository objSAP_WBS_Repository;

        public SAP_WBS_Service(string Connection_Str)
        {
            this.objSAP_WBS_Repository = new SAP_WBS_Repository(Connection_Str);
        }
        public IQueryable<SAP_WBS> SearchFor(Expression<Func<SAP_WBS, bool>> predicate)
        {
            return objSAP_WBS_Repository.SearchFor(predicate);
        }

        public SAP_WBS GetById(int id)
        {
            return objSAP_WBS_Repository.GetById(id);
        }

        public override bool Validate(SAP_WBS objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(SAP_WBS objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(SAP_WBS objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class SAP_Export_Service : BusinessLogic<SAP_Export>
    {
        private readonly SAP_Export_Repository objSAP_Export_Repository;

        public SAP_Export_Service(string Connection_Str)
        {
            this.objSAP_Export_Repository = new SAP_Export_Repository(Connection_Str);
        }
        public IQueryable<SAP_Export> SearchFor(Expression<Func<SAP_Export, bool>> predicate)
        {
            return objSAP_Export_Repository.SearchFor(predicate);
        }

        public SAP_Export GetById(int id)
        {
            return objSAP_Export_Repository.GetById(id);
        }
        public bool Save(SAP_Export objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objSAP_Export_Repository, out resultSet);
        }
        public override bool Validate(SAP_Export objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(SAP_Export objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(SAP_Export objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Users_Password_Detail_Service : BusinessLogic<Users_Password_Detail>
    {
        private readonly Users_Password_Detail_Repository objUsers_Password_Detail_Repository;

        public Users_Password_Detail_Service(string Connection_Str)
        {
            this.objUsers_Password_Detail_Repository = new Users_Password_Detail_Repository(Connection_Str);
        }
        public IQueryable<Users_Password_Detail> SearchFor(Expression<Func<Users_Password_Detail, bool>> predicate)
        {
            return objUsers_Password_Detail_Repository.SearchFor(predicate);
        }

        public Users_Password_Detail GetById(int id)
        {
            return objUsers_Password_Detail_Repository.GetById(id);
        }

        public bool Save(Users_Password_Detail objUPD, out dynamic resultSet)
        {
            return base.Save(objUPD, objUsers_Password_Detail_Repository, out resultSet);
        }

        public bool Delete(Users_Password_Detail objUPD, out dynamic resultSet)
        {
            return base.Delete(objUPD, objUsers_Password_Detail_Repository, out resultSet);
        }

        public override bool Validate(Users_Password_Detail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Users_Password_Detail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Users_Password_Detail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Talent_Service : BusinessLogic<Talent>
    {
        private readonly Talent_Repository objTalent;

        public Talent_Service(string Connection_Str)
        {
            this.objTalent = new Talent_Repository(Connection_Str);
        }
        public IQueryable<Talent> SearchFor(Expression<Func<Talent, bool>> predicate)
        {
            return objTalent.SearchFor(predicate);
        }

        public Talent GetById(int id)
        {
            return objTalent.GetById(id);
        }

        public bool Save(Talent objUPD, out dynamic resultSet)
        {
            return base.Save(objUPD, objTalent, out resultSet);
        }

        public bool Delete(Talent objUPD, out dynamic resultSet)
        {
            return base.Delete(objUPD, objTalent, out resultSet);
        }

        public override bool Validate(Talent objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Talent objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Talent objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Talent objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            {
                resultSet = "Talent already exists";
                return false;
            }
            resultSet = "";
            return true;
        }
    }
    public class Talent_Role_Service : BusinessLogic<Talent_Role>
    {
        private readonly Talent_Role_Repository objTalent_Role;

        public Talent_Role_Service(string Connection_Str)
        {
            this.objTalent_Role = new Talent_Role_Repository(Connection_Str);
        }
        public IQueryable<Talent_Role> SearchFor(Expression<Func<Talent_Role, bool>> predicate)
        {
            return objTalent_Role.SearchFor(predicate);
        }

        public Talent_Role GetById(int id)
        {
            return objTalent_Role.GetById(id);
        }

        public bool Save(Talent_Role objUPD, out dynamic resultSet)
        {
            return base.Save(objUPD, objTalent_Role, out resultSet);
        }

        public bool Delete(Talent_Role objUPD, out dynamic resultSet)
        {
            return base.Delete(objUPD, objTalent_Role, out resultSet);
        }

        public override bool Validate(Talent_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Talent_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Talent_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Genre_Service : BusinessLogic<Genre>
    {
        private readonly Genre_Repository objRepository;

        public Genre_Service(string Connection_Str)
        {
            this.objRepository = new Genre_Repository(Connection_Str);
        }
        public IQueryable<Genre> SearchFor(Expression<Func<Genre, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Genre GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Genre objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Genre objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Genre objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Genre objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Genre objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Genre objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Genre objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Genres_Name == objToValidate.Genres_Name && s.Genres_Code != objToValidate.Genres_Code).Count() > 0)
            {
                resultSet = "Genres already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }
    public class Deal_Description_Service : BusinessLogic<Deal_Description>
    {
        private readonly Deal_Description_Repository objRepository;

        public Deal_Description_Service(string Connection_Str)
        {
            this.objRepository = new Deal_Description_Repository(Connection_Str);
        }
        public IQueryable<Deal_Description> SearchFor(Expression<Func<Deal_Description, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Deal_Description GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Deal_Description objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Deal_Description objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Deal_Description objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Deal_Description objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Deal_Description objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Deal_Description objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Deal_Description objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Deal_Desc_Name == objToValidate.Deal_Desc_Name && s.Deal_Desc_Code != objToValidate.Deal_Desc_Code && s.Type == objToValidate.Type).Count() > 0)
            {
                resultSet = "Deal Description already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Title_Objection_Type_Service : BusinessLogic<Title_Objection_Type>
    {
        private readonly Objection_Type_Repository objRepository;

        public Title_Objection_Type_Service(string Connection_Str)
        {
            this.objRepository = new Objection_Type_Repository(Connection_Str);
        }
        public IQueryable<Title_Objection_Type> SearchFor(Expression<Func<Title_Objection_Type, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Objection_Type GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Objection_Type objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Objection_Type objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Objection_Type objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Objection_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Title_Objection_Type objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Title_Objection_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Title_Objection_Type objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Objection_Type_Name == objToValidate.Objection_Type_Name && s.Objection_Type_Code != objToValidate.Objection_Type_Code).Count() > 0)
            {
                resultSet = "Title Objection Type already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }
    public class Grade_Master_Service : BusinessLogic<Grade_Master>
    {
        private readonly Grade_Master_Repository objRepository;

        public Grade_Master_Service(string Connection_Str)
        {
            this.objRepository = new Grade_Master_Repository(Connection_Str);
        }
        public IQueryable<Grade_Master> SearchFor(Expression<Func<Grade_Master, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Grade_Master GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Grade_Master objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Grade_Master objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Grade_Master objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Grade_Master objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Grade_Master objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Grade_Master objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Grade_Master objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Grade_Name.ToUpper() == objToValidate.Grade_Name.ToUpper() &&
                    s.Grade_Code != objToValidate.Grade_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Grade already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }
    public class Extended_Columns_Service : BusinessLogic<Extended_Columns>
    {
        private readonly Extended_Columns_Repository objRepository;
        private readonly Extended_Columns_Value_Repository extended_Columns_Value_Repository;

        public Extended_Columns_Service(string Connection_Str)
        {
            this.objRepository = new Extended_Columns_Repository(Connection_Str);
            this.extended_Columns_Value_Repository = new Extended_Columns_Value_Repository(Connection_Str);
        }
        public IQueryable<Extended_Columns> SearchFor(Expression<Func<Extended_Columns, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }
        public Extended_Columns GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(Extended_Columns objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Extended_Columns objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }
        public bool Delete(Extended_Columns objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }
        public override bool Validate(Extended_Columns objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Extended_Columns objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        public override bool ValidateDelete(Extended_Columns objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(Extended_Columns objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Columns_Name == objToValidate.Columns_Name && s.Columns_Code != objToValidate.Columns_Code).Count() > 0)
            {
                resultSet = "Extended Column already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }
    public class Extended_Columns_Value_Service : BusinessLogic<Extended_Columns_Value>
    {
        private readonly Extended_Columns_Value_Repository objExtCol;

        public Extended_Columns_Value_Service(string Connection_Str)
        {
            this.objExtCol = new Extended_Columns_Value_Repository(Connection_Str);
        }
        public IQueryable<Extended_Columns_Value> SearchFor(Expression<Func<Extended_Columns_Value, bool>> predicate)
        {
            return objExtCol.SearchFor(predicate);
        }
        public Extended_Columns_Value GetById(int id)
        {
            return objExtCol.GetById(id);
        }
        public bool Save(Extended_Columns_Value objUPD, out dynamic resultSet)
        {
            return base.Save(objUPD, objExtCol, out resultSet);
        }
        public bool Update(Extended_Columns_Value objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objExtCol, out resultSet);
        }
        public bool Delete(Extended_Columns_Value objUPD, out dynamic resultSet)
        {
            return base.Delete(objUPD, objExtCol, out resultSet);
        }

        public override bool Validate(Extended_Columns_Value objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Extended_Columns_Value objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateDelete(Extended_Columns_Value objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Map_Extended_Columns_Service : BusinessLogic<Map_Extended_Columns>
    {
        private readonly Map_Extended_Columns_Repository objExtCol;

        public Map_Extended_Columns_Service(string Connection_Str)
        {
            this.objExtCol = new Map_Extended_Columns_Repository(Connection_Str);
        }
        public IQueryable<Map_Extended_Columns> SearchFor(Expression<Func<Map_Extended_Columns, bool>> predicate)
        {
            return objExtCol.SearchFor(predicate);
        }

        public Map_Extended_Columns GetById(int id)
        {
            return objExtCol.GetById(id);
        }

        public bool Save(Map_Extended_Columns objUPD, out dynamic resultSet)
        {
            return base.Save(objUPD, objExtCol, out resultSet);
        }

        public bool Delete(Map_Extended_Columns objUPD, out dynamic resultSet)
        {
            return base.Delete(objUPD, objExtCol, out resultSet);
        }

        public override bool Validate(Map_Extended_Columns objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Map_Extended_Columns objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Map_Extended_Columns objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class ROFR_Service
    {
        private readonly ROFR_Repository objROFR;

        public ROFR_Service(string Connection_Str)
        {
            this.objROFR = new ROFR_Repository(Connection_Str);
        }
        public IQueryable<ROFR> SearchFor(Expression<Func<ROFR, bool>> predicate)
        {
            return objROFR.SearchFor(predicate);
        }

        public ROFR GetById(int id)
        {
            return objROFR.GetById(id);
        }
    }
    public class Channel_Cluster_Service : BusinessLogic<Channel_Cluster>
    {
        private readonly Channel_Cluster_Repository objRepository;

        public Channel_Cluster_Service(string Connection_Str)
        {
            this.objRepository = new Channel_Cluster_Repository(Connection_Str);
        }
        public IQueryable<Channel_Cluster> SearchFor(Expression<Func<Channel_Cluster, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Channel_Cluster GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public override bool Validate(Channel_Cluster objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(Channel_Cluster objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Channel_Cluster objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class WBS_Type_Service : BusinessLogic<WBS_Type>
    {
        private readonly WBS_Type_Repository objRepository;

        public WBS_Type_Service(string Connection_Str)
        {
            this.objRepository = new WBS_Type_Repository(Connection_Str);
        }
        public IQueryable<WBS_Type> SearchFor(Expression<Func<WBS_Type, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public WBS_Type GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public override bool Validate(WBS_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        public override bool ValidateUpdate(WBS_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(WBS_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Platform_Group_Service : BusinessLogic<Platform_Group>
    {
        private readonly Platform_Group_Repository objRepository;

        public Platform_Group_Service(string Connection_Str)
        {
            this.objRepository = new Platform_Group_Repository(Connection_Str);
        }
        public IQueryable<Platform_Group> SearchFor(Expression<Func<Platform_Group, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Platform_Group GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Platform_Group objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public override bool Validate(Platform_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Platform_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Platform_Group objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Platform_Group objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Platform_Group_Name.ToUpper() == objToValidate.Platform_Group_Name.ToUpper().Trim() && s.Platform_Group_Code != objToValidate.Platform_Group_Code).Count() > 0)
            {
                resultSet = "Platform group already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Platform_Group_Details_Service : BusinessLogic<Platform_Group_Details>
    {
        private readonly Platform_Group_Details_Repository objRepository;

        public Platform_Group_Details_Service(string Connection_Str)
        {
            this.objRepository = new Platform_Group_Details_Repository(Connection_Str);
        }
        public IQueryable<Platform_Group_Details> SearchFor(Expression<Func<Platform_Group_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Platform_Group_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Platform_Group_Details objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public override bool Validate(Platform_Group_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Platform_Group_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Platform_Group_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Channel_Region_Service
    {
        private readonly Channel_Region_Repository objCR;


        public Channel_Region_Service(string Connection_Str)
        {
            this.objCR = new Channel_Region_Repository(Connection_Str);
        }
        public IQueryable<Channel_Region> SearchFor(Expression<Func<Channel_Region, bool>> predicate)
        {
            return objCR.SearchFor(predicate);
        }

        public Channel_Region GetById(int id)
        {
            return objCR.GetById(id);
        }

        public void Save(Channel_Region objD)
        {
            objCR.Save(objD);
        }
    }

    public class Channel_Region_Mapping_Service
    {
        private readonly Channel_Region_Mapping_Repository objCRM;

        public Channel_Region_Mapping_Service(string Connection_Str)
        {
            this.objCRM = new Channel_Region_Mapping_Repository(Connection_Str);
        }
        public IQueryable<Channel_Region_Mapping> SearchFor(Expression<Func<Channel_Region_Mapping, bool>> predicate)
        {
            return objCRM.SearchFor(predicate);
        }

        public Channel_Region_Mapping GetById(int id)
        {
            return objCRM.GetById(id);
        }

        public void Save(Channel_Region_Mapping objD)
        {
            objCRM.Save(objD);
        }
    }


    public class Music_Label_Service : BusinessLogic<Music_Label>
    {
        private readonly Music_Label_Repository objRepository;

        public Music_Label_Service(string Connection_Str)
        {
            this.objRepository = new Music_Label_Repository(Connection_Str);
        }
        public IQueryable<Music_Label> SearchFor(Expression<Func<Music_Label, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Label GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Music_Label objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Music_Label objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Music_Label objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Music_Label objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Music_Label objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Music_Label objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Music_Label objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Music_Label_Name.ToUpper() == objToValidate.Music_Label_Name.ToUpper() &&
                    s.Music_Label_Code != objToValidate.Music_Label_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Music label already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }



    public class Music_Title_Service : BusinessLogic<Music_Title>
    {
        private readonly Music_Title_Repository objRepository;


        public Music_Title_Service(string Connection_Str)
        {
            this.objRepository = new Music_Title_Repository(Connection_Str);
        }
        public IQueryable<Music_Title> SearchFor(Expression<Func<Music_Title, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Title GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Title objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Title_Label_Service : BusinessLogic<Music_Title_Label>
    {
        private readonly Music_Title_Label_Repository objRepository;

        public Music_Title_Label_Service(string Connection_Str)
        {
            this.objRepository = new Music_Title_Label_Repository(Connection_Str);
        }
        public IQueryable<Music_Title_Label> SearchFor(Expression<Func<Music_Title_Label, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Title_Label GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Title_Label objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Title_Label objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Title_Label objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Title_Label objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Title_Language_Service : BusinessLogic<Music_Title_Language>
    {
        private readonly Music_Title_Language_Repository objRepository;

        public Music_Title_Language_Service(string Connection_Str)
        {
            this.objRepository = new Music_Title_Language_Repository(Connection_Str);
        }

        public IQueryable<Music_Title_Language> SearchFor(Expression<Func<Music_Title_Language, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Title_Language GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Title_Language objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Title_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Title_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Title_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Title_Talent_Service : BusinessLogic<Music_Title_Talent>
    {
        private readonly Music_Title_Talent_Repository objRepository;

        public Music_Title_Talent_Service(string Connection_Str)
        {
            this.objRepository = new Music_Title_Talent_Repository(Connection_Str);
        }
        public IQueryable<Music_Title_Talent> SearchFor(Expression<Func<Music_Title_Talent, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Title_Talent GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Title_Talent objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Title_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Title_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Title_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Music_Type_Service : BusinessLogic<Music_Type>
    {
        private readonly Music_Type_Repository objRepository;

        public Music_Type_Service(string Connection_Str)
        {
            this.objRepository = new Music_Type_Repository(Connection_Str);
        }
        public IQueryable<Music_Type> SearchFor(Expression<Func<Music_Type, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Type GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Type objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Type objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Amort_Rule_Service : BusinessLogic<Amort_Rule>
    {
        private readonly Amort_Rule_Repository objRepository;

        public Amort_Rule_Service(string Connection_Str)
        {
            this.objRepository = new Amort_Rule_Repository(Connection_Str);
        }
        public IQueryable<Amort_Rule> SearchFor(Expression<Func<Amort_Rule, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Amort_Rule GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Amort_Rule objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Amort_Rule objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Amort_Rule objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Amort_Rule objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Amort_Rule_Details_Service : BusinessLogic<Amort_Rule_Details>
    {
        private readonly Amort_Rule_Details_Repository objRepository;

        public Amort_Rule_Details_Service(string Connection_Str)
        {
            this.objRepository = new Amort_Rule_Details_Repository(Connection_Str);
        }
        public IQueryable<Amort_Rule_Details> SearchFor(Expression<Func<Amort_Rule_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Amort_Rule_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Amort_Rule_Details objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Amort_Rule_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Amort_Rule_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Amort_Rule_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Glossary_Service : BusinessLogic<Glossary>
    {
        private readonly Glossary_Repository objRepository;

        public Glossary_Service(string Connection_Str)
        {
            this.objRepository = new Glossary_Repository(Connection_Str);
        }
        public IQueryable<Glossary> SearchFor(Expression<Func<Glossary, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Glossary GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Glossary objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Glossary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Glossary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Glossary objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Glossary_AskExpert_Service : BusinessLogic<Glossary_AskExpert>
    {
        private readonly Glossary_AskExpert_Repository objRepository;

        public Glossary_AskExpert_Service(string Connection_Str)
        {
            this.objRepository = new Glossary_AskExpert_Repository(Connection_Str);
        }

        public IQueryable<Glossary_AskExpert> SearchFor(Expression<Func<Glossary_AskExpert, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Glossary_AskExpert GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Glossary_AskExpert objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Glossary_AskExpert objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Glossary_AskExpert objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Glossary_AskExpert objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class System_Versions_Service
    {
        private readonly System_Versions_Repository objRepository;

        public System_Versions_Service(string Connection_Str)
        {
            this.objRepository = new System_Versions_Repository(Connection_Str);
        }
        public IQueryable<System_Versions> SearchFor(Expression<Func<System_Versions, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public System_Versions GetById(int id)
        {
            return objRepository.GetById(id);
        }
    }

    public class BVException_Service : BusinessLogic<BVException>
    {
        private readonly BVException_Repository objRepository;
        private string _Connection_Str = "";

        public BVException_Service(string Connection_Str)
        {
            _Connection_Str = Connection_Str;
            this.objRepository = new BVException_Repository(Connection_Str);
        }
        public IQueryable<BVException> SearchFor(Expression<Func<BVException, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public BVException GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(BVException objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(BVException objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(BVException objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(BVException objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(BVException objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BVException objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(BVException objToValidate, out dynamic resultSet)
        {
            int[] Arr_Selected_Channel_Code = objToValidate.BVException_Channel.Select(s => s.Channel_Code).ToArray();
            int[] Arr_Selected_Users_Code = objToValidate.BVException_Users.Select(s => s.Users_Code).ToArray();

            var Arr_Bv_Exception_Code_Channel = new BVException_Channel_Service(_Connection_Str).SearchFor(s => Arr_Selected_Channel_Code.Contains(s.Channel_Code) && s.Bv_Exception_Code != objToValidate.Bv_Exception_Code && s.BVException.Bv_Exception_Type == objToValidate.Bv_Exception_Type).Select(b => b.Bv_Exception_Code).ToList();
            var Arr_Bv_Exception_Code_User = new BVException_Users_Service(_Connection_Str).SearchFor(s => Arr_Bv_Exception_Code_Channel.Contains(s.Users_Code) && Arr_Selected_Users_Code.Contains(s.Users_Code) && s.Bv_Exception_Code != objToValidate.Bv_Exception_Code && objToValidate.Bv_Exception_Type == s.BVException.Bv_Exception_Type)
                .Select(b => b.Bv_Exception_Code).ToList();

            int Check_Duplicate = new BVException_Users_Service(_Connection_Str).SearchFor(s => Arr_Bv_Exception_Code_Channel.Contains(s.Bv_Exception_Code) && Arr_Selected_Users_Code.Contains(s.Users_Code) && s.Bv_Exception_Code != objToValidate.Bv_Exception_Code && objToValidate.Bv_Exception_Type == s.BVException.Bv_Exception_Type)
                .Select(b => b.Bv_Exception_Code).Count();

            if (Check_Duplicate > 0)
            {
                resultSet = "Combination of User and channel already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class BVException_Channel_Service : BusinessLogic<BVException_Channel>
    {
        private readonly BVException_Channel_Repository objRepository;

        public BVException_Channel_Service(string Connection_Str)
        {
            this.objRepository = new BVException_Channel_Repository(Connection_Str);
        }
        public IQueryable<BVException_Channel> SearchFor(Expression<Func<BVException_Channel, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public BVException_Channel GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(BVException_Channel objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(BVException_Channel objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(BVException_Channel objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(BVException_Channel objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BVException_Channel objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BVException_Channel objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class BVException_Users_Service : BusinessLogic<BVException_Users>
    {
        private readonly BVException_Users_Repository objRepository;

        public BVException_Users_Service(string Connection_Str)
        {
            this.objRepository = new BVException_Users_Repository(Connection_Str);
        }
        public IQueryable<BVException_Users> SearchFor(Expression<Func<BVException_Users, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public BVException_Users GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(BVException_Users objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(BVException_Users objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(BVException_Users objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(BVException_Users objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BVException_Users objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BVException_Users objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Music_Language_Service : BusinessLogic<Music_Language>
    {
        private readonly Music_Language_Repository objRepository;

        public Music_Language_Service(string Connection_Str)
        {
            this.objRepository = new Music_Language_Repository(Connection_Str);
        }

        public IQueryable<Music_Language> SearchFor(Expression<Func<Music_Language, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Language GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Music_Language objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Music_Language objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Music_Language objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Music_Language objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Music_Language objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Music_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Music_Language objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Language_Name == objToValidate.Language_Name && s.Music_Language_Code != objToValidate.Music_Language_Code).Count() > 0)
            {
                resultSet = "Music Language already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Music_Theme_Service : BusinessLogic<Music_Theme>
    {
        private readonly Music_Theme_Repository objRepository;

        public Music_Theme_Service(string Connection_Str)
        {
            this.objRepository = new Music_Theme_Repository(Connection_Str);
        }
        public IQueryable<Music_Theme> SearchFor(Expression<Func<Music_Theme, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Theme GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Music_Theme objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Music_Theme objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Music_Theme objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Music_Theme objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Music_Theme objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Music_Theme objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Music_Theme objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Music_Theme_Name == objToValidate.Music_Theme_Name && s.Music_Theme_Code != objToValidate.Music_Theme_Code).Count() > 0)
            {
                resultSet = "Music Theme already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Music_Album_Service : BusinessLogic<Music_Album>
    {
        private readonly Music_Album_Repository objRepository;

        public Music_Album_Service(string Connection_Str)
        {
            this.objRepository = new Music_Album_Repository(Connection_Str);
        }
        public IQueryable<Music_Album> SearchFor(Expression<Func<Music_Album, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Album GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Music_Album objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }
        public bool Update(Music_Album objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Music_Album objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Music_Album objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Music_Album objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Music_Album objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Music_Album objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Music_Album_Name == objToValidate.Music_Album_Name && s.Music_Album_Code != objToValidate.Music_Album_Code).Count() > 0)
            {
                resultSet = "Music album already exists";
                return false;
            }
            resultSet = "";
            return true;
        }
    }

    public class Music_Album_Talent_Service : BusinessLogic<Music_Album_Talent>
    {
        private readonly Music_Album_Talent_Repository objRepository;

        public Music_Album_Talent_Service(string Connection_Str)
        {
            this.objRepository = new Music_Album_Talent_Repository(Connection_Str);
        }
        public IQueryable<Music_Album_Talent> SearchFor(Expression<Func<Music_Album_Talent, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Album_Talent GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Album_Talent objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Album_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Album_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Album_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Error_Code_Master_Service
    {
        private readonly Error_Code_Master_Repository objError_Code_Master;
        public Error_Code_Master_Service(string Connection_Str)
        {
            this.objError_Code_Master = new Error_Code_Master_Repository(Connection_Str);
        }
        public IQueryable<Error_Code_Master> SearchFor(Expression<Func<Error_Code_Master, bool>> predicate)
        {
            return objError_Code_Master.SearchFor(predicate);
        }

        public Error_Code_Master GetById(int id)
        {
            return objError_Code_Master.GetById(id);
        }
    }

    public class Deal_Workflow_Status_Service
    {
        private readonly Deal_Workflow_Status_Repository objDeal_Workflow_Status;
        public Deal_Workflow_Status_Service(string Connection_Str)
        {
            this.objDeal_Workflow_Status = new Deal_Workflow_Status_Repository(Connection_Str);
        }
        public IQueryable<Deal_Workflow_Status> SearchFor(Expression<Func<Deal_Workflow_Status, bool>> predicate)
        {
            return objDeal_Workflow_Status.SearchFor(predicate);
        }

        public Deal_Workflow_Status GetById(int id)
        {
            return objDeal_Workflow_Status.GetById(id);
        }
    }
    public class DM_Master_Import_Service : BusinessLogic<DM_Master_Import>
    {
        private readonly DM_Master_Import_Repository objRepository;

        public DM_Master_Import_Service(string Connection_Str)
        {
            this.objRepository = new DM_Master_Import_Repository(Connection_Str);
        }
        public IQueryable<DM_Master_Import> SearchFor(Expression<Func<DM_Master_Import, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public DM_Master_Import GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public bool Save(DM_Master_Import objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(DM_Master_Import objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(DM_Master_Import objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }
        public override bool Validate(DM_Master_Import objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(DM_Master_Import objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(DM_Master_Import objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class DM_Title_Resolve_Conflict_Service : BusinessLogic<DM_Title_Resolve_Conflict>
    {
        private readonly DM_Title_Resolve_Conflict_Repository objRepository;

        public DM_Title_Resolve_Conflict_Service(string Connection_Str)
        {
            this.objRepository = new DM_Title_Resolve_Conflict_Repository(Connection_Str);
        }
        public IQueryable<DM_Title_Resolve_Conflict> SearchFor(Expression<Func<DM_Title_Resolve_Conflict, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public DM_Title_Resolve_Conflict GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public override bool Validate(DM_Title_Resolve_Conflict objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(DM_Title_Resolve_Conflict objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(DM_Title_Resolve_Conflict objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class DM_Music_Title_Service : BusinessLogic<DM_Music_Title>
    {
        private readonly DM_Music_Title_Repository objRepository;
        public DM_Music_Title_Service(string Connection_Str)
        {
            this.objRepository = new DM_Music_Title_Repository(Connection_Str);
        }
        public IQueryable<DM_Music_Title> SearchFor(Expression<Func<DM_Music_Title, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public DM_Music_Title GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(DM_Music_Title objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(DM_Music_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(DM_Music_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(DM_Music_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class DM_Master_Log_Service : BusinessLogic<DM_Master_Log>
    {
        private readonly DM_Master_Log_Repository objRepository;
        public DM_Master_Log_Service(string Connection_Str)
        {
            this.objRepository = new DM_Master_Log_Repository(Connection_Str);
        }
        public IQueryable<DM_Master_Log> SearchFor(Expression<Func<DM_Master_Log, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public DM_Master_Log GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(DM_Master_Log objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(DM_Master_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(DM_Master_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(DM_Master_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Workflow_Service : BusinessLogic<Workflow>
    {
        private readonly Workflow_Repository objRepository;
        public Workflow_Service(string Connection_Str)
        {
            this.objRepository = new Workflow_Repository(Connection_Str);
        }
        public IQueryable<Workflow> SearchFor(Expression<Func<Workflow, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Workflow GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Workflow objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Workflow objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Workflow objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Workflow objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Workflow objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Workflow objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Workflow objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Workflow_Name.ToUpper() == objToValidate.Workflow_Name.ToUpper() &&
                    s.Workflow_Code != objToValidate.Workflow_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "Workflow Name already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }

    public class Workflow_Role_Service : BusinessLogic<Workflow_Role>
    {
        private readonly Workflow_Role_Repository objRepository;
        public Workflow_Role_Service(string Connection_Str)
        {
            this.objRepository = new Workflow_Role_Repository(Connection_Str);
        }
        public IQueryable<Workflow_Role> SearchFor(Expression<Func<Workflow_Role, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Workflow_Role GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Workflow_Role objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Workflow_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Workflow_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Workflow_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class BMS_Log_Service : BusinessLogic<BMS_Log>
    {
        private readonly BMS_Log_Repository objRepository;
        public BMS_Log_Service(string Connection_Str)
        {
            this.objRepository = new BMS_Log_Repository(Connection_Str);
        }
        public IQueryable<BMS_Log> SearchFor(Expression<Func<BMS_Log, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public BMS_Log GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(BMS_Log objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(BMS_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BMS_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BMS_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class BMS_All_Masters_Service : BusinessLogic<BMS_All_Masters>
    {
        private readonly BMS_All_Masters_Repository objRepository;
        public BMS_All_Masters_Service(string Connection_Str)
        {
            this.objRepository = new BMS_All_Masters_Repository(Connection_Str);
        }
        public IQueryable<BMS_All_Masters> SearchFor(Expression<Func<BMS_All_Masters, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public BMS_All_Masters GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(BMS_All_Masters objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(BMS_All_Masters objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BMS_All_Masters objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BMS_All_Masters objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Workflow_Module_Service : BusinessLogic<Workflow_Module>
    {
        private readonly Workflow_Module_Repository objRepository;

        public Workflow_Module_Service(string Connection_Str)
        {
            this.objRepository = new Workflow_Module_Repository(Connection_Str);
        }
        public IQueryable<Workflow_Module> SearchFor(Expression<Func<Workflow_Module, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Workflow_Module GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Workflow_Module objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Workflow_Module objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Workflow_Module objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Workflow_Module objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Workflow_Module objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Workflow_Module objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Workflow_Module objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Workflow_Module_Role_Service : BusinessLogic<Workflow_Module_Role>
    {
        private readonly Workflow_Module_Role_Repository objRepository;
        public Workflow_Module_Role_Service(string Connection_Str)
        {
            this.objRepository = new Workflow_Module_Role_Repository(Connection_Str);
        }
        public IQueryable<Workflow_Module_Role> SearchFor(Expression<Func<Workflow_Module_Role, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Workflow_Module_Role GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Workflow_Module_Role objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Workflow_Module_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Workflow_Module_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Workflow_Module_Role objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class DM_Title_Service : BusinessLogic<DM_Title>
    {
        private readonly DM_Title_Repository objRepository;

        public DM_Title_Service(string Connection_Str)
        {
            this.objRepository = new DM_Title_Repository(Connection_Str);
        }
        public IQueryable<DM_Title> SearchFor(Expression<Func<DM_Title, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public DM_Title GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(DM_Title objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(DM_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(DM_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(DM_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }


    public class Upload_Files_Service : BusinessLogic<Upload_Files>
    {
        private readonly Upload_Files_Repository objRepository;
        public Upload_Files_Service(string Connection_Str)
        {
            this.objRepository = new Upload_Files_Repository(Connection_Str);
        }
        public IQueryable<Upload_Files> SearchFor(Expression<Func<Upload_Files, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Upload_Files GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Upload_Files objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Upload_Files objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Upload_Files objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Upload_Files objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Upload_Files objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Upload_Files objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Upload_Files objToValidate, out dynamic resultSet)
        {
            //if (objToValidate.EntityState != State.Deleted)
            //{
            //    int duplicateRecordCount = SearchFor(s => s.Upload_Files_Name.ToUpper() == objToValidate.Upload_Files_Name.ToUpper() &&
            //        s.Upload_Files_Code != objToValidate.Upload_Files_Code).Count();

            //    if (duplicateRecordCount > 0)
            //    {
            //        resultSet = "Upload_Files Name already exists";
            //        return false;
            //    }
            //}

            resultSet = "";
            return true;
        }
    }
    public class Program_Service : BusinessLogic<Program>
    {
        private readonly Program_Repository objRepository;
        public Program_Service(string Connection_Str)
        {
            this.objRepository = new Program_Repository(Connection_Str);
        }
        public IQueryable<Program> SearchFor(Expression<Func<Program, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Program GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Program objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Program objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Program objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Program objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Program objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Program objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Program objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Program_Name.ToUpper().Trim() == objToValidate.Program_Name.ToUpper().Trim() && s.Program_Code != objToValidate.Program_Code).Count() > 0)
            {
                resultSet = "Program already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }
    public class Music_Title_Theme_Service : BusinessLogic<Music_Title_Theme>
    {
        private readonly Music_Title_Theme_Repository objRepository;
        public Music_Title_Theme_Service(string Connection_Str)
        {
            this.objRepository = new Music_Title_Theme_Repository(Connection_Str);
        }
        public IQueryable<Music_Title_Theme> SearchFor(Expression<Func<Music_Title_Theme, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Music_Title_Theme GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Music_Title_Theme objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(Music_Title_Theme objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Music_Title_Theme objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Music_Title_Theme objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Channel_Territory_Service : BusinessLogic<Channel_Territory>
    {
        private readonly Channel_Territory_Repository objRepository;
        public Channel_Territory_Service(string Connection_Str)
        {
            this.objRepository = new Channel_Territory_Repository(Connection_Str);
        }
        public IQueryable<Channel_Territory> SearchFor(Expression<Func<Channel_Territory, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Channel_Territory GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Channel_Territory objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Channel_Territory objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Channel_Territory objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }
        public override bool Validate(Channel_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Channel_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Channel_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Version_Service
    {
        private readonly Version_Repository objEntity;
        public Version_Service(string Connection_Str)
        {
            this.objEntity = new Version_Repository(Connection_Str);
        }
        public IQueryable<RightsU_Entities.Version> SearchFor(Expression<Func<RightsU_Entities.Version, bool>> predicate)
        {
            return objEntity.SearchFor(predicate);
        }

        public RightsU_Entities.Version GetById(int id)
        {
            return objEntity.GetById(id);
        }
    }

    public class Acq_Deal_Cost_Costtype_Episode_Service : BusinessLogic<Acq_Deal_Cost_Costtype_Episode>
    {
        private readonly Acq_Deal_Cost_Costtype_Episode_Repository objRepository;
        public Acq_Deal_Cost_Costtype_Episode_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Cost_Costtype_Episode_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Cost_Costtype_Episode> SearchFor(Expression<Func<Acq_Deal_Cost_Costtype_Episode, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Deal_Cost_Costtype_Episode GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Acq_Deal_Cost_Costtype_Episode objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Acq_Deal_Cost_Costtype_Episode objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Acq_Deal_Cost_Costtype_Episode objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Acq_Deal_Cost_Costtype_Episode objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Acq_Deal_Cost_Costtype_Episode objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Acq_Deal_Cost_Costtype_Episode objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Acq_Deal_Cost_Costtype_Episode objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Acq_Deal_Cost_Title_Service : BusinessLogic<Acq_Deal_Cost_Title>
    {
        private readonly Acq_Deal_Cost_Title_Repository objRepository;
        public Acq_Deal_Cost_Title_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Cost_Title_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Cost_Title> SearchFor(Expression<Func<Acq_Deal_Cost_Title, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Deal_Cost_Title GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Acq_Deal_Cost_Title objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Acq_Deal_Cost_Title objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Acq_Deal_Cost_Title objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Acq_Deal_Cost_Title objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Acq_Deal_Cost_Title objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Acq_Deal_Cost_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Acq_Deal_Cost_Title objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Acq_Deal_Cost_Costtype_Service : BusinessLogic<Acq_Deal_Cost_Costtype>
    {
        private readonly Acq_Deal_Cost_Costtype_Repository objRepository;
        public Acq_Deal_Cost_Costtype_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Deal_Cost_Costtype_Repository(Connection_Str);
        }

        public IQueryable<Acq_Deal_Cost_Costtype> SearchFor(Expression<Func<Acq_Deal_Cost_Costtype, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Deal_Cost_Costtype GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Acq_Deal_Cost_Costtype objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Acq_Deal_Cost_Costtype objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Acq_Deal_Cost_Costtype objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Acq_Deal_Cost_Costtype objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Acq_Deal_Cost_Costtype objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Acq_Deal_Cost_Costtype objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Acq_Deal_Cost_Costtype objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Syn_Deal_Revenue_Costtype_Service : BusinessLogic<Syn_Deal_Revenue_Costtype>
    {
        private readonly Syn_Deal_Revenue_Costtype_Repository objRepository;
        public Syn_Deal_Revenue_Costtype_Service(string Connection_Str)
        {
            this.objRepository = new Syn_Deal_Revenue_Costtype_Repository(Connection_Str);
        }

        public IQueryable<Syn_Deal_Revenue_Costtype> SearchFor(Expression<Func<Syn_Deal_Revenue_Costtype, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Syn_Deal_Revenue_Costtype GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Syn_Deal_Revenue_Costtype objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Syn_Deal_Revenue_Costtype objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Syn_Deal_Revenue_Costtype objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Syn_Deal_Revenue_Costtype objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Syn_Deal_Revenue_Costtype objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Syn_Deal_Revenue_Costtype objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Syn_Deal_Revenue_Costtype objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }


    public class Report_Territory_Service : BusinessLogic<Report_Territory>
    {
        private readonly Report_Territory_Repository objADAR;
        public Report_Territory_Service(string Connection_Str)
        {
            this.objADAR = new Report_Territory_Repository(Connection_Str);
        }

        public IQueryable<Report_Territory> SearchFor(Expression<Func<Report_Territory, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Report_Territory GetById(int id)
        {
            return objADAR.GetById(id);
        }
        public override bool Validate(Report_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Report_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Report_Territory objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Report_Territory_Country_Service : BusinessLogic<Report_Territory_Country>
    {
        private readonly Report_Territory_Country_Repository objADAR;
        public Report_Territory_Country_Service(string Connection_Str)
        {
            this.objADAR = new Report_Territory_Country_Repository(Connection_Str);
        }
        public IQueryable<Report_Territory_Country> SearchFor(Expression<Func<Report_Territory_Country, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Report_Territory_Country GetById(int id)
        {
            return objADAR.GetById(id);
        }
        public override bool Validate(Report_Territory_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Report_Territory_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Report_Territory_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Email_Config_Detail_Service : BusinessLogic<Email_Config_Detail>
    {
        private readonly Email_Config_Detail_Repository objADAR;
        public Email_Config_Detail_Service(string Connection_Str)
        {
            this.objADAR = new Email_Config_Detail_Repository(Connection_Str);
        }
        public IQueryable<Email_Config_Detail> SearchFor(Expression<Func<Email_Config_Detail, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Email_Config_Detail GetById(int id)
        {
            return objADAR.GetById(id);
        }
        public bool Save(Email_Config_Detail objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objADAR, out resultSet);
        }

        public bool Update(Email_Config_Detail objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objADAR, out resultSet);
        }

        public bool Delete(Email_Config_Detail objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objADAR, out resultSet);
        }
        public override bool Validate(Email_Config_Detail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Email_Config_Detail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Email_Config_Detail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Email_Config_Service : BusinessLogic<Email_Config>
    {
        private readonly Email_Config_Repository objADAR;
        public Email_Config_Service(string Connection_Str)
        {
            this.objADAR = new Email_Config_Repository(Connection_Str);
        }

        public IQueryable<Email_Config> SearchFor(Expression<Func<Email_Config, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Email_Config GetById(int id)
        {
            return objADAR.GetById(id);
        }
        public override bool Validate(Email_Config objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Email_Config objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Email_Config objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Email_Config_Detail_User_Service : BusinessLogic<Email_Config_Detail_User>
    {
        private readonly Email_Config_Detail_User_Repository objADAR;
        public Email_Config_Detail_User_Service(string Connection_Str)
        {
            this.objADAR = new Email_Config_Detail_User_Repository(Connection_Str);
        }
        public IQueryable<Email_Config_Detail_User> SearchFor(Expression<Func<Email_Config_Detail_User, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Email_Config_Detail_User GetById(int id)
        {
            return objADAR.GetById(id);
        }
        public bool Save(Email_Config_Detail_User objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objADAR, out resultSet);
        }

        public bool Update(Email_Config_Detail_User objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objADAR, out resultSet);
        }

        public bool Delete(Email_Config_Detail_User objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objADAR, out resultSet);
        }
        public override bool Validate(Email_Config_Detail_User objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Email_Config_Detail_User objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Email_Config_Detail_User objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Email_Config_Detail_Alert_Service : BusinessLogic<Email_Config_Detail_Alert>
    {
        private readonly Email_Config_Detail_Alert_Repository objADAR;
        public Email_Config_Detail_Alert_Service(string Connection_Str)
        {
            this.objADAR = new Email_Config_Detail_Alert_Repository(Connection_Str);
        }
        public IQueryable<Email_Config_Detail_Alert> SearchFor(Expression<Func<Email_Config_Detail_Alert, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Email_Config_Detail_Alert GetById(int id)
        {
            return objADAR.GetById(id);
        }
        public bool Save(Email_Config_Detail_Alert objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objADAR, out resultSet);
        }

        public bool Update(Email_Config_Detail_Alert objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objADAR, out resultSet);
        }

        public bool Delete(Email_Config_Detail_Alert objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objADAR, out resultSet);
        }
        public override bool Validate(Email_Config_Detail_Alert objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Email_Config_Detail_Alert objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Email_Config_Detail_Alert objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Channel_Category_Service
    {
        private readonly Channel_Category_Repository objRepository;
        public Channel_Category_Service(string Connection_Str)
        {
            this.objRepository = new Channel_Category_Repository(Connection_Str);
        }
        public IQueryable<Channel_Category> SearchFor(Expression<Func<Channel_Category, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Channel_Category GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Channel_Category objD)
        {
            objRepository.Save(objD);
        }

    }

    public class Title_Alternate_Service : BusinessLogic<Title_Alternate>
    {
        private readonly Title_Alternate_Repository objTitleR;
        public Title_Alternate_Service(string Connection_Str)
        {
            this.objTitleR = new Title_Alternate_Repository(Connection_Str);
        }
        public IQueryable<Title_Alternate> SearchFor(Expression<Func<Title_Alternate, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Title_Alternate GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Title_Alternate objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Title_Alternate objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Title_Alternate objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Title_Alternate objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Alternate objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Alternate objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Alternate_Config_Service : BusinessLogic<Alternate_Config>
    {
        private readonly Alternate_Config_Repository objTitleR;
        public Alternate_Config_Service(string Connection_Str)
        {
            this.objTitleR = new Alternate_Config_Repository(Connection_Str);
        }
        public IQueryable<Alternate_Config> SearchFor(Expression<Func<Alternate_Config, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Alternate_Config GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Alternate_Config objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Alternate_Config objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Alternate_Config objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Alternate_Config objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Alternate_Config objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Alternate_Config objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Title_Alternate_Talent_Service : BusinessLogic<Title_Alternate_Talent>
    {
        private readonly Title_Alternate_Talent_Repository objTitleR;
        public Title_Alternate_Talent_Service(string Connection_Str)
        {
            this.objTitleR = new Title_Alternate_Talent_Repository(Connection_Str);
        }
        public IQueryable<Title_Alternate_Talent> SearchFor(Expression<Func<Title_Alternate_Talent, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Title_Alternate_Talent GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Title_Alternate_Talent objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Title_Alternate_Talent objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Title_Alternate_Talent objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Title_Alternate_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Alternate_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Alternate_Talent objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Title_Alternate_Genres_Service : BusinessLogic<Title_Alternate_Genres>
    {
        private readonly Title_Alternate_Genres_Repository objTitleR;
        public Title_Alternate_Genres_Service(string Connection_Str)
        {
            this.objTitleR = new Title_Alternate_Genres_Repository(Connection_Str);
        }
        public IQueryable<Title_Alternate_Genres> SearchFor(Expression<Func<Title_Alternate_Genres, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Title_Alternate_Genres GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Title_Alternate_Genres objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Title_Alternate_Genres objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Title_Alternate_Genres objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Title_Alternate_Genres objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Alternate_Genres objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Alternate_Genres objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Title_Alternate_Country_Service : BusinessLogic<Title_Alternate_Country>
    {
        private readonly Title_Alternate_Country_Repository objTitleR;
        public Title_Alternate_Country_Service(string Connection_Str)
        {
            this.objTitleR = new Title_Alternate_Country_Repository(Connection_Str);
        }
        public IQueryable<Title_Alternate_Country> SearchFor(Expression<Func<Title_Alternate_Country, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Title_Alternate_Country GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Title_Alternate_Country objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Title_Alternate_Country objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Title_Alternate_Country objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Title_Alternate_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Alternate_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Alternate_Country objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Title_Alternate_Content_Service : BusinessLogic<Title_Alternate_Content>
    {
        private readonly Title_Alternate_Content_Repository objTitleR;
        public Title_Alternate_Content_Service(string Connection_Str)
        {
            this.objTitleR = new Title_Alternate_Content_Repository(Connection_Str);
        }
        public IQueryable<Title_Alternate_Content> SearchFor(Expression<Func<Title_Alternate_Content, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Title_Alternate_Content GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Title_Alternate_Content objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Title_Alternate_Content objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Title_Alternate_Content objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Title_Alternate_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Alternate_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Alternate_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Report_Format_Service : BusinessLogic<Report_Format>
    {
        private readonly Report_Format_Repository objTitleR;
        public Report_Format_Service(string Connection_Str)
        {
            this.objTitleR = new Report_Format_Repository(Connection_Str);
        }
        public IQueryable<Report_Format> SearchFor(Expression<Func<Report_Format, bool>> predicate)
        {
            return objTitleR.SearchFor(predicate);
        }

        public Report_Format GetById(int id)
        {
            return objTitleR.GetById(id);
        }

        public bool Save(Report_Format objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTitleR, out resultSet);
        }

        public bool Update(Report_Format objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTitleR, out resultSet);
        }

        public bool Delete(Report_Format objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTitleR, out resultSet);
        }

        public override bool Validate(Report_Format objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Report_Format objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Report_Format objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Language_Group_Details_Service : BusinessLogic<Language_Group_Details>
    {
        private readonly Language_Group_Details_Repository objRepository;
        public Language_Group_Details_Service(string Connection_Str)
        {
            this.objRepository = new Language_Group_Details_Repository(Connection_Str);
        }
        public IQueryable<Language_Group_Details> SearchFor(Expression<Func<Language_Group_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Language_Group_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Language_Group_Details objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public override bool Validate(Language_Group_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Language_Group_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Language_Group_Details objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class System_Language_Message_Service : BusinessLogic<System_Language_Message>
    {
        private readonly System_Language_Message_Repository objRepository;
        public System_Language_Message_Service(string Connection_Str)
        {
            this.objRepository = new System_Language_Message_Repository(Connection_Str);
        }
        public IQueryable<System_Language_Message> SearchFor(Expression<Func<System_Language_Message, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public System_Language_Message GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(System_Language_Message objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public override bool Validate(System_Language_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(System_Language_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(System_Language_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class System_Language_Service : BusinessLogic<System_Language>
    {
        private readonly System_Language_Repository objRepository;
        public System_Language_Service(string Connection_Str)
        {
            this.objRepository = new System_Language_Repository(Connection_Str);
        }
        public IQueryable<System_Language> SearchFor(Expression<Func<System_Language, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public System_Language GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(System_Language objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public override bool Validate(System_Language objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(System_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(System_Language objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(System_Language objToValidate, out dynamic resultSet)
        {
            if (objToValidate.EntityState != State.Deleted)
            {
                int duplicateRecordCount = SearchFor(s => s.Language_Name.ToUpper() == objToValidate.Language_Name.ToUpper() && s.System_Language_Code != objToValidate.System_Language_Code).Count();

                if (duplicateRecordCount > 0)
                {
                    resultSet = "System Language already exists";
                    return false;
                }
            }

            resultSet = "";
            return true;
        }
    }
    public class Email_Notification_Log_Service : BusinessLogic<Email_Notification_Log>
    {
        private readonly Email_Notification_Log_Repository objADAR;
        public Email_Notification_Log_Service(string Connection_Str)
        {
            this.objADAR = new Email_Notification_Log_Repository(Connection_Str);
        }
        public IQueryable<Email_Notification_Log> SearchFor(Expression<Func<Email_Notification_Log, bool>> predicate)
        {
            return objADAR.SearchFor(predicate);
        }

        public Email_Notification_Log GetById(int id)
        {
            return objADAR.GetById(id);
        }
        public bool Save(Email_Notification_Log objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objADAR, out resultSet);
        }

        public bool Update(Email_Notification_Log objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objADAR, out resultSet);
        }

        public bool Delete(Email_Notification_Log objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objADAR, out resultSet);
        }
        public override bool Validate(Email_Notification_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Email_Notification_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Email_Notification_Log objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class System_Message_Service : BusinessLogic<System_Message>
    {
        private readonly System_Message_Repository objRepository;
        public System_Message_Service(string Connection_Str)
        {
            this.objRepository = new System_Message_Repository(Connection_Str);
        }
        public IQueryable<System_Message> SearchFor(Expression<Func<System_Message, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public System_Message GetById(int id)
        {
            return objRepository.GetById(id);
        }
        public override bool Validate(System_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(System_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(System_Message objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class Acq_Deal_Rights_Promoter_Group_Service
    {
        private readonly Acq_Deal_Rights_Promoter_Group_Repository objAcq_Deal_Rights_Promoter_Group;
        public Acq_Deal_Rights_Promoter_Group_Service(string Connection_Str)
        {
            this.objAcq_Deal_Rights_Promoter_Group = new Acq_Deal_Rights_Promoter_Group_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Rights_Promoter_Group> SearchFor(Expression<Func<Acq_Deal_Rights_Promoter_Group, bool>> predicate)
        {
            return objAcq_Deal_Rights_Promoter_Group.SearchFor(predicate);
        }

        public Acq_Deal_Rights_Promoter_Group GetById(int id)
        {
            return objAcq_Deal_Rights_Promoter_Group.GetById(id);
        }
    }

    public class Acq_Deal_Rights_Promoter_Remarks_Service
    {
        private readonly Acq_Deal_Rights_Promoter_Remarks_Repository objAcq_Deal_Rights_Promoter_Remarks;
        public Acq_Deal_Rights_Promoter_Remarks_Service(string Connection_Str)
        {
            this.objAcq_Deal_Rights_Promoter_Remarks = new Acq_Deal_Rights_Promoter_Remarks_Repository(Connection_Str);
        }
        public IQueryable<Acq_Deal_Rights_Promoter_Remarks> SearchFor(Expression<Func<Acq_Deal_Rights_Promoter_Remarks, bool>> predicate)
        {
            return objAcq_Deal_Rights_Promoter_Remarks.SearchFor(predicate);
        }

        public Acq_Deal_Rights_Promoter_Remarks GetById(int id)
        {
            return objAcq_Deal_Rights_Promoter_Remarks.GetById(id);
        }

    }

    public class Provisional_Deal_Run_Service : BusinessLogic<Provisional_Deal_Run>
    {
        private readonly Provisional_Deal_Run_Repository objRepository;
        public Provisional_Deal_Run_Service(string Connection_Str)
        {
            this.objRepository = new Provisional_Deal_Run_Repository(Connection_Str);
        }
        public IQueryable<Provisional_Deal_Run> SearchFor(Expression<Func<Provisional_Deal_Run, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Provisional_Deal_Run GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Provisional_Deal_Run objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Provisional_Deal_Run objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Provisional_Deal_Run objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Provisional_Deal_Run objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Provisional_Deal_Run objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Provisional_Deal_Run objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Provisional_Deal_Run objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Provisional_Deal_Run_Channel_Service : BusinessLogic<Provisional_Deal_Run_Channel>
    {
        private readonly Provisional_Deal_Run_Channel_Repository objRepository;
        public Provisional_Deal_Run_Channel_Service(string Connection_Str)
        {
            this.objRepository = new Provisional_Deal_Run_Channel_Repository(Connection_Str);
        }
        public IQueryable<Provisional_Deal_Run_Channel> SearchFor(Expression<Func<Provisional_Deal_Run_Channel, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Provisional_Deal_Run_Channel GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Provisional_Deal_Run_Channel objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Provisional_Deal_Run_Channel objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Provisional_Deal_Run_Channel objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Provisional_Deal_Run_Channel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Provisional_Deal_Run_Channel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Provisional_Deal_Run_Channel objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Provisional_Deal_Run_Channel objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Channel_Category_Details_Service
    {
        private readonly Channel_Category_Details_Repository objRepository;
        public Channel_Category_Details_Service(string Connection_Str)
        {
            this.objRepository = new Channel_Category_Details_Repository(Connection_Str);
        }
        public IQueryable<Channel_Category_Details> SearchFor(Expression<Func<Channel_Category_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Channel_Category_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(Channel_Category_Details objD)
        {
            objRepository.Save(objD);
        }

    }
    public class DM_Content_Music_Service : BusinessLogic<DM_Content_Music>
    {
        private readonly DM_Content_Music_Repository objRepository;

        public DM_Content_Music_Service(string Connection_Str)
        {
            this.objRepository = new DM_Content_Music_Repository(Connection_Str);
        }
        public IQueryable<DM_Content_Music> SearchFor(Expression<Func<DM_Content_Music, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public DM_Content_Music GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(DM_Content_Music objD)
        {
            objRepository.Save(objD);
        }

        public override bool Validate(DM_Content_Music objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(DM_Content_Music objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(DM_Content_Music objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class MQ_Log_Service
    {
        private readonly MQ_Log_Repository objRepository;
        public MQ_Log_Service(string Connection_Str)
        {
            this.objRepository = new MQ_Log_Repository(Connection_Str);
        }
        public IQueryable<MQ_Log> SearchFor(Expression<Func<MQ_Log, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public MQ_Log GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public void Save(MQ_Log objD)
        {
            objRepository.Save(objD);
        }
    }

    public class BMS_Asset_Service : BusinessLogic<BMS_Asset>
    {
        private readonly BMS_Asset_Repository objBMS_Asset;

        public BMS_Asset_Service(string Connection_Str)
        {
            this.objBMS_Asset = new BMS_Asset_Repository(Connection_Str);
        }

        public IQueryable<BMS_Asset> SearchFor(Expression<Func<BMS_Asset, bool>> predicate)
        {
            return objBMS_Asset.SearchFor(predicate);
        }

        public BMS_Asset GetById(int id)
        {
            return objBMS_Asset.GetById(id);
        }

        public bool Save(BMS_Asset objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objBMS_Asset, out resultSet);
        }

        public bool Update(BMS_Asset objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objBMS_Asset, out resultSet);
        }

        public bool Delete(BMS_Asset objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objBMS_Asset, out resultSet);
        }

        public override bool Validate(BMS_Asset objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BMS_Asset objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BMS_Asset objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class BMS_Deal_Service : BusinessLogic<BMS_Deal>
    {
        private readonly BMS_Deal_Repository objBMS_Deal;

        public BMS_Deal_Service(string Connection_Str)
        {
            this.objBMS_Deal = new BMS_Deal_Repository(Connection_Str);
        }

        public IQueryable<BMS_Deal> SearchFor(Expression<Func<BMS_Deal, bool>> predicate)
        {
            return objBMS_Deal.SearchFor(predicate);
        }

        public BMS_Deal GetById(int id)
        {
            return objBMS_Deal.GetById(id);
        }

        public bool Save(BMS_Deal objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objBMS_Deal, out resultSet);
        }

        public bool Update(BMS_Deal objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objBMS_Deal, out resultSet);
        }

        public bool Delete(BMS_Deal objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objBMS_Deal, out resultSet);
        }

        public override bool Validate(BMS_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BMS_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BMS_Deal objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class BMS_Deal_Content_Service : BusinessLogic<BMS_Deal_Content>
    {
        private readonly BMS_Deal_Content_Repository objBMS_Deal_Content;

        public BMS_Deal_Content_Service(string Connection_Str)
        {
            this.objBMS_Deal_Content = new BMS_Deal_Content_Repository(Connection_Str);
        }

        public IQueryable<BMS_Deal_Content> SearchFor(Expression<Func<BMS_Deal_Content, bool>> predicate)
        {
            return objBMS_Deal_Content.SearchFor(predicate);
        }

        public BMS_Deal_Content GetById(int id)
        {
            return objBMS_Deal_Content.GetById(id);
        }

        public bool Save(BMS_Deal_Content objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objBMS_Deal_Content, out resultSet);
        }

        public bool Update(BMS_Deal_Content objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objBMS_Deal_Content, out resultSet);
        }

        public bool Delete(BMS_Deal_Content objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objBMS_Deal_Content, out resultSet);
        }

        public override bool Validate(BMS_Deal_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BMS_Deal_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BMS_Deal_Content objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class BMS_Deal_Content_Rights_Service : BusinessLogic<BMS_Deal_Content_Rights>
    {
        private readonly BMS_Deal_Content_Rights_Repository objBMS_Deal_Content_Rights;

        public BMS_Deal_Content_Rights_Service(string Connection_Str)
        {
            this.objBMS_Deal_Content_Rights = new BMS_Deal_Content_Rights_Repository(Connection_Str);
        }

        public IQueryable<BMS_Deal_Content_Rights> SearchFor(Expression<Func<BMS_Deal_Content_Rights, bool>> predicate)
        {
            return objBMS_Deal_Content_Rights.SearchFor(predicate);
        }

        public BMS_Deal_Content_Rights GetById(int id)
        {
            return objBMS_Deal_Content_Rights.GetById(id);
        }

        public bool Save(BMS_Deal_Content_Rights objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objBMS_Deal_Content_Rights, out resultSet);
        }

        public bool Update(BMS_Deal_Content_Rights objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objBMS_Deal_Content_Rights, out resultSet);
        }

        public bool Delete(BMS_Deal_Content_Rights objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objBMS_Deal_Content_Rights, out resultSet);
        }

        public override bool Validate(BMS_Deal_Content_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(BMS_Deal_Content_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(BMS_Deal_Content_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Milestone_Nature_Service : BusinessLogic<Milestone_Nature>
    {
        private readonly Milestone_Nature_Repository objRepository;

        public Milestone_Nature_Service(string Connection_Str)
        {
            this.objRepository = new Milestone_Nature_Repository(Connection_Str);
        }
        public IQueryable<Milestone_Nature> SearchFor(Expression<Func<Milestone_Nature, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Milestone_Nature GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Milestone_Nature objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Milestone_Nature objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Milestone_Nature objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Milestone_Nature objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Milestone_Nature objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Milestone_Nature objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Milestone_Nature objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Milestone_Nature_Name == objToValidate.Milestone_Nature_Name && s.Milestone_Nature_Code != objToValidate.Milestone_Nature_Code).Count() > 0)
            {
                resultSet = "Milestone Nature already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }
    public class Title_Milestone_Service : BusinessLogic<Title_Milestone>
    {
        private readonly Title_Milestone_Repository objRepository;

        public Title_Milestone_Service(string Connection_Str)
        {
            this.objRepository = new Title_Milestone_Repository(Connection_Str);
        }
        public IQueryable<Title_Milestone> SearchFor(Expression<Func<Title_Milestone, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Milestone GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Milestone objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Milestone objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Milestone objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Milestone objToValidate, out dynamic resultSet)
        {
            //return ValidateDuplicate(objToValidate, out resultSet);
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Title_Milestone objToValidate, out dynamic resultSet)
        {
            //return ValidateDuplicate(objToValidate, out resultSet);
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Title_Milestone objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        //private bool ValidateDuplicate(Milestone_Nature objToValidate, out dynamic resultSet)
        //{
        //    if (SearchFor(s => s.Milestone_Nature_Name == objToValidate.Milestone_Nature_Name && s.Milestone_Nature_Code != objToValidate.Milestone_Nature_Code).Count() > 0)
        //    {
        //        resultSet = "Milestone Nature already exists";
        //        return false;
        //    }

        //    resultSet = "";
        //    return true;
        //}
    }
    public class TAT_Service : BusinessLogic<TAT>
    {
        private readonly TAT_Repository objTAT;

        public TAT_Service(string Connection_Str)
        {
            this.objTAT = new TAT_Repository(Connection_Str);
        }

        public IQueryable<TAT> SearchFor(Expression<Func<TAT, bool>> predicate)
        {
            return objTAT.SearchFor(predicate);
        }

        public TAT GetById(int id)
        {
            return objTAT.GetById(id);
        }

        public bool Save(TAT objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, objTAT, out resultSet);
        }

        public bool Update(TAT objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, objTAT, out resultSet);
        }

        public bool Delete(TAT objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, objTAT, out resultSet);
        }

        public override bool Validate(TAT objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(TAT objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(TAT objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class TATSLA_Service : BusinessLogic<TATSLA>
    {
        private readonly TATSLA_Repository obj_Repository;

        public TATSLA_Service(string Connection_Str)
        {
            this.obj_Repository = new TATSLA_Repository(Connection_Str);
        }

        public IQueryable<TATSLA> SearchFor(Expression<Func<TATSLA, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public TATSLA GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(TATSLA objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, obj_Repository, out resultSet);
        }

        public bool Update(TATSLA objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, obj_Repository, out resultSet);
        }

        public bool Delete(TATSLA objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, obj_Repository, out resultSet);
        }

        public override bool Validate(TATSLA objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(TATSLA objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(TATSLA objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class TATSLAMatrix_Service : BusinessLogic<TATSLAMatrix>
    {
        private readonly TATSLAMatrix_Repository obj_Repository;

        public TATSLAMatrix_Service(string Connection_Str)
        {
            this.obj_Repository = new TATSLAMatrix_Repository(Connection_Str);
        }

        public IQueryable<TATSLAMatrix> SearchFor(Expression<Func<TATSLAMatrix, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public TATSLAMatrix GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(TATSLAMatrix objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, obj_Repository, out resultSet);
        }

        public bool Update(TATSLAMatrix objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, obj_Repository, out resultSet);
        }

        public bool Delete(TATSLAMatrix objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, obj_Repository, out resultSet);
        }

        public override bool Validate(TATSLAMatrix objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(TATSLAMatrix objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(TATSLAMatrix objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class TATSLAMatrixDetail_Service : BusinessLogic<TATSLAMatrixDetail>
    {
        private readonly TATSLAMatrixDetail_Repository obj_Repository;

        public TATSLAMatrixDetail_Service(string Connection_Str)
        {
            this.obj_Repository = new TATSLAMatrixDetail_Repository(Connection_Str);
        }

        public IQueryable<TATSLAMatrixDetail> SearchFor(Expression<Func<TATSLAMatrixDetail, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public TATSLAMatrixDetail GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(TATSLAMatrixDetail objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, obj_Repository, out resultSet);
        }

        public bool Update(TATSLAMatrixDetail objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, obj_Repository, out resultSet);
        }

        public bool Delete(TATSLAMatrixDetail objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, obj_Repository, out resultSet);
        }

        public override bool Validate(TATSLAMatrixDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(TATSLAMatrixDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(TATSLAMatrixDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class TATSLAStatus_Service
    {
        private readonly TATSLAStatus_Repository obj_Repository;

        public TATSLAStatus_Service(string Connection_Str)
        {
            this.obj_Repository = new TATSLAStatus_Repository(Connection_Str);
        }

        public IQueryable<TATSLAStatus> SearchFor(Expression<Func<TATSLAStatus, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public TATSLAStatus GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }
    public class TATStatusLog_Service : BusinessLogic<TATStatusLog>
    {
        private readonly TATStatusLog_Repository obj_Repository;

        public TATStatusLog_Service(string Connection_Str)
        {
            this.obj_Repository = new TATStatusLog_Repository(Connection_Str);
        }

        public IQueryable<TATStatusLog> SearchFor(Expression<Func<TATStatusLog, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public TATStatusLog GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(TATStatusLog objTitle, out dynamic resultSet)
        {
            return base.Save(objTitle, obj_Repository, out resultSet);
        }

        public bool Update(TATStatusLog objTitle, out dynamic resultSet)
        {
            return base.Update(objTitle, obj_Repository, out resultSet);
        }

        public bool Delete(TATStatusLog objTitle, out dynamic resultSet)
        {
            return base.Delete(objTitle, obj_Repository, out resultSet);
        }

        public override bool Validate(TATStatusLog objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(TATStatusLog objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(TATStatusLog objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class ProjectMilestone_Service : BusinessLogic<ProjectMilestone>
    {
        private readonly ProjectMilestone_Repository obj_Repository;

        public ProjectMilestone_Service(string Connection_Str)
        {
            this.obj_Repository = new ProjectMilestone_Repository(Connection_Str);
        }

        public IQueryable<ProjectMilestone> SearchFor(Expression<Func<ProjectMilestone, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public ProjectMilestone GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(ProjectMilestone objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, obj_Repository, out resultSet);
        }

        public bool Update(ProjectMilestone objToSave, out dynamic resultSet)
        {
            return base.Update(objToSave, obj_Repository, out resultSet);
        }

        public bool Delete(ProjectMilestone objToSave, out dynamic resultSet)
        {
            return base.Delete(objToSave, obj_Repository, out resultSet);
        }

        public override bool Validate(ProjectMilestone objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(ProjectMilestone objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(ProjectMilestone objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }
    public class ProjectMilestoneDetail_Service : BusinessLogic<ProjectMilestoneDetail>
    {
        private readonly ProjectMilestoneDetail_Repository obj_Repository;

        public ProjectMilestoneDetail_Service(string Connection_Str)
        {
            this.obj_Repository = new ProjectMilestoneDetail_Repository(Connection_Str);
        }

        public IQueryable<ProjectMilestoneDetail> SearchFor(Expression<Func<ProjectMilestoneDetail, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public ProjectMilestoneDetail GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(ProjectMilestoneDetail objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, obj_Repository, out resultSet);
        }

        public bool Update(ProjectMilestoneDetail objToSave, out dynamic resultSet)
        {
            return base.Update(objToSave, obj_Repository, out resultSet);
        }

        public bool Delete(ProjectMilestoneDetail objToSave, out dynamic resultSet)
        {
            return base.Delete(objToSave, obj_Repository, out resultSet);
        }

        public override bool Validate(ProjectMilestoneDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(ProjectMilestoneDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(ProjectMilestoneDetail objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class ProjectMilestoneTitle_Service : BusinessLogic<ProjectMilestoneTitle>
    {
        private readonly ProjectMilestoneTitle_Repository obj_Repository;

        public ProjectMilestoneTitle_Service(string Connection_Str)
        {
            this.obj_Repository = new ProjectMilestoneTitle_Repository(Connection_Str);
        }

        public IQueryable<ProjectMilestoneTitle> SearchFor(Expression<Func<ProjectMilestoneTitle, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public ProjectMilestoneTitle GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(ProjectMilestoneTitle objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, obj_Repository, out resultSet);
        }

        public bool Update(ProjectMilestoneTitle objToSave, out dynamic resultSet)
        {
            return base.Update(objToSave, obj_Repository, out resultSet);
        }

        public bool Delete(ProjectMilestoneTitle objToSave, out dynamic resultSet)
        {
            return base.Delete(objToSave, obj_Repository, out resultSet);
        }

        public override bool Validate(ProjectMilestoneTitle objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(ProjectMilestoneTitle objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(ProjectMilestoneTitle objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Party_Category_Service : BusinessLogic<Party_Category>
    {
        private readonly Party_Category_Repository obj_Repository;

        public Party_Category_Service(string Connection_Str)
        {
            this.obj_Repository = new Party_Category_Repository(Connection_Str);
        }

        public IQueryable<Party_Category> SearchFor(Expression<Func<Party_Category, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Party_Category GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public bool Save(Party_Category objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, obj_Repository, out resultSet);
        }

        public bool Update(Party_Category objToSave, out dynamic resultSet)
        {
            return base.Update(objToSave, obj_Repository, out resultSet);
        }

        public bool Delete(Party_Category objToSave, out dynamic resultSet)
        {
            return base.Delete(objToSave, obj_Repository, out resultSet);
        }

        public override bool Validate(Party_Category objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Party_Category objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Party_Category objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
        private bool ValidateDuplicate(Party_Category objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Party_Category_Name == objToValidate.Party_Category_Name && s.Party_Category_Code != objToValidate.Party_Category_Code).Count() > 0)
            {
                resultSet = "Party Category already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Users_Configuration_Service : BusinessLogic<Users_Configuration>
    {
        private readonly Users_Configuration_Repository obj_Repository;

        public Users_Configuration_Service(string Connection_Str)
        {
            this.obj_Repository = new Users_Configuration_Repository(Connection_Str);
        }

        public IQueryable<Users_Configuration> SearchFor(Expression<Func<Users_Configuration, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Users_Configuration GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Users_Configuration objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Users_Configuration objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Users_Configuration objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Users_Exclusion_Rights_Service : BusinessLogic<Users_Exclusion_Rights>
    {
        private readonly Users_Exclusion_Rights_Repository obj_Repository;

        public Users_Exclusion_Rights_Service(string Connection_Str)
        {
            this.obj_Repository = new Users_Exclusion_Rights_Repository(Connection_Str);
        }

        public IQueryable<Users_Exclusion_Rights> SearchFor(Expression<Func<Users_Exclusion_Rights, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Users_Exclusion_Rights GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Users_Exclusion_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Users_Exclusion_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Users_Exclusion_Rights objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Party_Group_Service : BusinessLogic<Party_Group>
    {
        private readonly Party_Group_Repository objRepository;
        public Party_Group_Service(string Connection_Str)
        {
            this.objRepository = new Party_Group_Repository(Connection_Str);
        }
        public IQueryable<Party_Group> SearchFor(Expression<Func<Party_Group, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Party_Group GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Party_Group objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Party_Group objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Party_Group objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Party_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Party_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Party_Group objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Party_Group objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Party_Group_Name.ToUpper().Trim() == objToValidate.Party_Group_Name.ToUpper().Trim() && s.Party_Group_Code != objToValidate.Party_Group_Code).Count() > 0)
            {
                resultSet = "Party Master already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }
    public class Deal_Segment_Service
    {
        private readonly Deal_Segment_Repository obj_Repository;

        public Deal_Segment_Service(string Connection_Str)
        {
            this.obj_Repository = new Deal_Segment_Repository(Connection_Str);
        }

        public IQueryable<Deal_Segment> SearchFor(Expression<Func<Deal_Segment, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Deal_Segment GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }
    public class Platform_Broadcast_Service
    {
        private readonly Platform_Broadcast_Repository obj_Repository;

        public Platform_Broadcast_Service(string Connection_Str)
        {
            this.obj_Repository = new Platform_Broadcast_Repository(Connection_Str);
        }

        public IQueryable<Platform_Broadcast> SearchFor(Expression<Func<Platform_Broadcast, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Platform_Broadcast GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }

    public class Revenue_Vertical_Service
    {
        private readonly Revenue_Vertical_Repository obj_Repository;

        public Revenue_Vertical_Service(string Connection_Str)
        {
            this.obj_Repository = new Revenue_Vertical_Repository(Connection_Str);
        }

        public IQueryable<Revenue_Vertical> SearchFor(Expression<Func<Revenue_Vertical, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Revenue_Vertical GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }
    public class DM_Title_Import_Utility_Data_Service
    {
        private readonly DM_Title_Import_Utility_Data_Repository obj_Repository;

        public DM_Title_Import_Utility_Data_Service(string Connection_Str)
        {
            this.obj_Repository = new DM_Title_Import_Utility_Data_Repository(Connection_Str);
        }

        public IQueryable<DM_Title_Import_Utility_Data> SearchFor(Expression<Func<DM_Title_Import_Utility_Data, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public DM_Title_Import_Utility_Data GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }


    public class DM_Title_Import_Utility_Service
    {
        private readonly DM_Title_Import_Utility_Repository obj_Repository;

        public DM_Title_Import_Utility_Service(string Connection_Str)
        {
            this.obj_Repository = new DM_Title_Import_Utility_Repository(Connection_Str);
        }

        public IQueryable<DM_Title_Import_Utility> SearchFor(Expression<Func<DM_Title_Import_Utility, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public DM_Title_Import_Utility GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }
    public class Acq_Adv_Ancillary_Report_Service : BusinessLogic<Acq_Adv_Ancillary_Report>
    {
        private readonly Acq_Adv_Ancillary_Report_Repository objRepository;

        public Acq_Adv_Ancillary_Report_Service(string Connection_Str)
        {
            this.objRepository = new Acq_Adv_Ancillary_Report_Repository(Connection_Str);
        }
        public IQueryable<Acq_Adv_Ancillary_Report> SearchFor(Expression<Func<Acq_Adv_Ancillary_Report, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Acq_Adv_Ancillary_Report GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Acq_Adv_Ancillary_Report objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Acq_Adv_Ancillary_Report objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Acq_Adv_Ancillary_Report objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Acq_Adv_Ancillary_Report objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Acq_Adv_Ancillary_Report objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Acq_Adv_Ancillary_Report objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Acq_Adv_Ancillary_Report objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Report_Name == objToValidate.Report_Name && s.Acq_Adv_Ancillary_Report_Code != objToValidate.Acq_Adv_Ancillary_Report_Code).Count() > 0)
            {
                resultSet = "Report Name already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }

    public class Title_Objection_Status_Service : BusinessLogic<Title_Objection_Status>
    {
        private readonly Title_Objection_Status_Repository obj_Repository;

        public Title_Objection_Status_Service(string Connection_Str)
        {
            this.obj_Repository = new Title_Objection_Status_Repository(Connection_Str);
        }

        public IQueryable<Title_Objection_Status> SearchFor(Expression<Func<Title_Objection_Status, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Title_Objection_Status GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Title_Objection_Status objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Title_Objection_Status objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Title_Objection_Status objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class Title_Objection_Service : BusinessLogic<Title_Objection>
    {
        private readonly Title_Objection_Repository objRepository;

        public Title_Objection_Service(string Connection_Str)
        {
            this.objRepository = new Title_Objection_Repository(Connection_Str);
        }
        public IQueryable<Title_Objection> SearchFor(Expression<Func<Title_Objection, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Objection GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Objection objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Objection objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Objection objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Objection objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Title_Objection objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);

        }

        public override bool ValidateDelete(Title_Objection objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Title_Objection objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Title_Objection_Platform_Service : BusinessLogic<Title_Objection_Platform>
    {
        private readonly Title_Objection_Platform_Repository obj_Repository;

        public Title_Objection_Platform_Service(string Connection_Str)
        {
            this.obj_Repository = new Title_Objection_Platform_Repository(Connection_Str);
        }

        public IQueryable<Title_Objection_Platform> SearchFor(Expression<Func<Title_Objection_Platform, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Title_Objection_Platform GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Title_Objection_Platform objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Title_Objection_Platform objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Title_Objection_Platform objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class Title_Objection_Territory_Service : BusinessLogic<Title_Objection_Territory>
    {
        private readonly Title_Objection_Territory_Repository obj_Repository;

        public Title_Objection_Territory_Service(string Connection_Str)
        {
            this.obj_Repository = new Title_Objection_Territory_Repository(Connection_Str);
        }

        public IQueryable<Title_Objection_Territory> SearchFor(Expression<Func<Title_Objection_Territory, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Title_Objection_Territory GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Title_Objection_Territory objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Title_Objection_Territory objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Title_Objection_Territory objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class Title_Objection_Rights_Period_Service : BusinessLogic<Title_Objection_Rights_Period>
    {
        private readonly Title_Objection_Rights_Period_Repository obj_Repository;

        public Title_Objection_Rights_Period_Service(string Connection_Str)
        {
            this.obj_Repository = new Title_Objection_Rights_Period_Repository(Connection_Str);
        }

        public IQueryable<Title_Objection_Rights_Period> SearchFor(Expression<Func<Title_Objection_Rights_Period, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Title_Objection_Rights_Period GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Title_Objection_Rights_Period objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Title_Objection_Rights_Period objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Title_Objection_Rights_Period objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }


    public class Attrib_Group_Service : BusinessLogic<Attrib_Group>
    {
        private readonly Attrib_Group_Repository objAttrib_Group_Repository;

        public Attrib_Group_Service(string Connection_Str)
        {
            this.objAttrib_Group_Repository = new Attrib_Group_Repository(Connection_Str);
        }
        public IQueryable<Attrib_Group> SearchFor(Expression<Func<Attrib_Group, bool>> predicate)
        {
            return objAttrib_Group_Repository.SearchFor(predicate);
        }

        public Attrib_Group GetById(int id)
        {
            return objAttrib_Group_Repository.GetById(id);
        }
        public bool Save(Attrib_Group objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objAttrib_Group_Repository, out resultSet);
        }
        public override bool Validate(Attrib_Group objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(Attrib_Group objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(Attrib_Group objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }
    }

    public class Supplementary_Service : BusinessLogic<Supplementary>
    {
        private readonly Supplementary_Repository obj_Repository;

        public Supplementary_Service(string Connection_Str)
        {
            this.obj_Repository = new Supplementary_Repository(Connection_Str);
        }

        public IQueryable<Supplementary> SearchFor(Expression<Func<Supplementary, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Supplementary GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Supplementary objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Supplementary objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Supplementary objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class Supplementary_Data_Service
    {
        private readonly Supplementary_Data_Repository obj_Repository;

        public Supplementary_Data_Service(string Connection_Str)
        {
            this.obj_Repository = new Supplementary_Data_Repository(Connection_Str);
        }

        public IQueryable<Supplementary_Data> SearchFor(Expression<Func<Supplementary_Data, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Supplementary_Data GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }

    public class Supplementary_Tab_Service : BusinessLogic<Supplementary_Tab>
    {
        private readonly Supplementary_Tab_Repository obj_Repository;

        public Supplementary_Tab_Service(string Connection_Str)
        {
            this.obj_Repository = new Supplementary_Tab_Repository(Connection_Str);
        }

        public IQueryable<Supplementary_Tab> SearchFor(Expression<Func<Supplementary_Tab, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Supplementary_Tab GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Supplementary_Tab objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Supplementary_Tab objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Supplementary_Tab objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class Supplementary_Config_Service
    {
        private readonly Supplementary_Config_Repository obj_Repository;

        public Supplementary_Config_Service(string Connection_Str)
        {
            this.obj_Repository = new Supplementary_Config_Repository(Connection_Str);
        }

        public IQueryable<Supplementary_Config> SearchFor(Expression<Func<Supplementary_Config, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Supplementary_Config GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }

    public class ImgPathData_Service : BusinessLogic<ImgPathData>
    {
        private readonly ImgPathData_Repository objImgPathDataR;

        public ImgPathData_Service(string Connection_Str)
        {
            this.objImgPathDataR = new ImgPathData_Repository(Connection_Str);
        }

        public IQueryable<ImgPathData> SearchFor(Expression<Func<ImgPathData, bool>> predicate)
        {
            return objImgPathDataR.SearchFor(predicate);
        }

        public ImgPathData GetById(int id)
        {
            return objImgPathDataR.GetById(id);
        }

        public bool Save(ImgPathData objImgPathData, out dynamic resultSet)
        {
            return base.Save(objImgPathData, objImgPathDataR, out resultSet);
        }


        public bool Update(ImgPathData objImgPathData, out dynamic resultSet)
        {
            return base.Update(objImgPathData, objImgPathDataR, out resultSet);
        }

        public bool Delete(ImgPathData objImgPathData, out dynamic resultSet)
        {
            return base.Delete(objImgPathData, objImgPathDataR, out resultSet);
        }

        public override bool Validate(ImgPathData objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateUpdate(ImgPathData objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

        public override bool ValidateDelete(ImgPathData objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }
    public class Digital_Data_Service
    {
        private readonly Digital_Data_Repository obj_Repository;

        public Digital_Data_Service(string Connection_Str)
        {
            this.obj_Repository = new Digital_Data_Repository(Connection_Str);
        }

        public IQueryable<Digital_Data> SearchFor(Expression<Func<Digital_Data, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Digital_Data GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }

    public class Digital_Tab_Service : BusinessLogic<Digital_Tab>
    {
        private readonly Digital_Tab_Repository obj_Repository;

        public Digital_Tab_Service(string Connection_Str)
        {
            this.obj_Repository = new Digital_Tab_Repository(Connection_Str);
        }

        public IQueryable<Digital_Tab> SearchFor(Expression<Func<Digital_Tab, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Digital_Tab GetById(int id)
        {
            return obj_Repository.GetById(id);
        }

        public override bool Validate(Digital_Tab objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUpdate(Digital_Tab objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }

        public override bool ValidateDelete(Digital_Tab objToValidate, out dynamic resultSet)
        {
            throw new NotImplementedException();
        }
    }

    public class Digital_Config_Service
    {
        private readonly Digital_Config_Repository obj_Repository;

        public Digital_Config_Service(string Connection_Str)
        {
            this.obj_Repository = new Digital_Config_Repository(Connection_Str);
        }

        public IQueryable<Digital_Config> SearchFor(Expression<Func<Digital_Config, bool>> predicate)
        {
            return obj_Repository.SearchFor(predicate);
        }

        public Digital_Config GetById(int id)
        {
            return obj_Repository.GetById(id);
        }
    }

    public class Extended_Group_Config_Service : BusinessLogic<Extended_Group_Config>
    {
        private readonly Extended_Group_Config_Repository objRepository;

        public Extended_Group_Config_Service(string Connection_Str)
        {
            this.objRepository = new Extended_Group_Config_Repository(Connection_Str);
        }
        public IQueryable<Extended_Group_Config> SearchFor(Expression<Func<Extended_Group_Config, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Extended_Group_Config GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Extended_Group_Config objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Extended_Group_Config objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Extended_Group_Config objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Extended_Group_Config objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Extended_Group_Config objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Extended_Group_Config objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Extended_Group_Config objToValidate, out dynamic resultSet)
        {
            resultSet = "";
            return true;
        }

    }

    public class Extended_Group_Service : BusinessLogic<Extended_Group>
    {
        private readonly Extended_Group_Repository objRepository;

        public Extended_Group_Service(string Connection_Str)
        {
            this.objRepository = new Extended_Group_Repository(Connection_Str);
        }
        public IQueryable<Extended_Group> SearchFor(Expression<Func<Extended_Group, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Extended_Group GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Extended_Group objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Extended_Group objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Extended_Group objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Extended_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Extended_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Extended_Group objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Extended_Group objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => (s.Module_Code == objToValidate.Module_Code && s.Group_Order == objToValidate.Group_Order) && (s.Extended_Group_Code != objToValidate.Extended_Group_Code)).Count() > 0)
            {
                resultSet = "Extended Group already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    #region---Aeroplay----------

    public class AL_Vendor_Details_Service : BusinessLogic<AL_Vendor_Details>
    {
        private readonly AL_Vendor_Details_Repository objRepository;

        public AL_Vendor_Details_Service(string Connection_Str)
        {
            this.objRepository = new AL_Vendor_Details_Repository(Connection_Str);
        }
        public IQueryable<AL_Vendor_Details> SearchFor(Expression<Func<AL_Vendor_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public AL_Vendor_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(AL_Vendor_Details objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(AL_Vendor_Details objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(AL_Vendor_Details objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(AL_Vendor_Details objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(AL_Vendor_Details objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(AL_Vendor_Details objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(AL_Vendor_Details objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Vendor_Code == objToValidate.Vendor_Code).Count() > 0)
            {
                resultSet = "AL_Vendor_Details already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class AL_Vendor_TnC_Service : BusinessLogic<AL_Vendor_TnC>
    {
        private readonly AL_Vendor_TnC_Repository objRepository;

        public AL_Vendor_TnC_Service(string Connection_Str)
        {
            this.objRepository = new AL_Vendor_TnC_Repository(Connection_Str);
        }
        public IQueryable<AL_Vendor_TnC> SearchFor(Expression<Func<AL_Vendor_TnC, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public AL_Vendor_TnC GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(AL_Vendor_TnC objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(AL_Vendor_TnC objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(AL_Vendor_TnC objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(AL_Vendor_TnC objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(AL_Vendor_TnC objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(AL_Vendor_TnC objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(AL_Vendor_TnC objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Vendor_Code == objToValidate.Vendor_Code).Count() > 0)
            {
                resultSet = "AL_Vendor_TnC already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class AL_Vendor_OEM_Service : BusinessLogic<AL_Vendor_OEM>
    {
        private readonly AL_Vendor_OEM_Repository objRepository;

        public AL_Vendor_OEM_Service(string Connection_Str)
        {
            this.objRepository = new AL_Vendor_OEM_Repository(Connection_Str);
        }
        public IQueryable<AL_Vendor_OEM> SearchFor(Expression<Func<AL_Vendor_OEM, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public AL_Vendor_OEM GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(AL_Vendor_OEM objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(AL_Vendor_OEM objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(AL_Vendor_OEM objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(AL_Vendor_OEM objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(AL_Vendor_OEM objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(AL_Vendor_OEM objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(AL_Vendor_OEM objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Vendor_Code == objToValidate.Vendor_Code).Count() > 0)
            {
                resultSet = "AL_Vendor_OEM already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class AL_Vendor_Rule_Criteria_Service : BusinessLogic<AL_Vendor_Rule_Criteria>
    {
        private readonly AL_Vendor_Rule_Criteria_Repository objRepository;

        public AL_Vendor_Rule_Criteria_Service(string Connection_Str)
        {
            this.objRepository = new AL_Vendor_Rule_Criteria_Repository(Connection_Str);
        }
        public IQueryable<AL_Vendor_Rule_Criteria> SearchFor(Expression<Func<AL_Vendor_Rule_Criteria, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public AL_Vendor_Rule_Criteria GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(AL_Vendor_Rule_Criteria objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(AL_Vendor_Rule_Criteria objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(AL_Vendor_Rule_Criteria objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(AL_Vendor_Rule_Criteria objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(AL_Vendor_Rule_Criteria objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(AL_Vendor_Rule_Criteria objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(AL_Vendor_Rule_Criteria objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.AL_Vendor_Rule_Code == objToValidate.AL_Vendor_Rule_Code).Count() > 0)
            {
                resultSet = "AL_Vendor_Rule_Criteria already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class AL_Vendor_Rule_Service : BusinessLogic<AL_Vendor_Rule>
    {
        private readonly AL_Vendor_Rule_Repository objRepository;

        public AL_Vendor_Rule_Service(string Connection_Str)
        {
            this.objRepository = new AL_Vendor_Rule_Repository(Connection_Str);
        }
        public IQueryable<AL_Vendor_Rule> SearchFor(Expression<Func<AL_Vendor_Rule, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public AL_Vendor_Rule GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(AL_Vendor_Rule objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(AL_Vendor_Rule objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(AL_Vendor_Rule objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(AL_Vendor_Rule objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(AL_Vendor_Rule objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(AL_Vendor_Rule objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(AL_Vendor_Rule objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.AL_Vendor_Rule_Code == objToValidate.AL_Vendor_Rule_Code).Count() > 0)
            {
                resultSet = "AL_Vendor_Rule already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class AL_OEM_Service : BusinessLogic<AL_OEM>
    {
        private readonly AL_OEM_Repository objRepository;

        public AL_OEM_Service(string Connection_Str)
        {
            this.objRepository = new AL_OEM_Repository(Connection_Str);
        }
        public IQueryable<AL_OEM> SearchFor(Expression<Func<AL_OEM, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public AL_OEM GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(AL_OEM objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(AL_OEM objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(AL_OEM objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(AL_OEM objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(AL_OEM objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(AL_OEM objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(AL_OEM objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Device_Name == objToValidate.Device_Name && s.AL_OEM_Code != objToValidate.AL_OEM_Code).Count() > 0)
            {
                resultSet = "OEM already exist with this Device Name";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class Banner_Service : BusinessLogic<Banner>
    {
        private readonly Banner_Repository objRepository;

        public Banner_Service(string Connection_Str)
        {
            this.objRepository = new Banner_Repository(Connection_Str);
        }
        public IQueryable<Banner> SearchFor(Expression<Func<Banner, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Banner GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Banner objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Banner objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Banner objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Banner objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Banner objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Banner objToValidate, out dynamic resultSet)
        {
             resultSet = "";
            return true;
        }

        private bool ValidateDuplicate(Banner objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Banner_Name == objToValidate.Banner_Name && s.Banner_Code != objToValidate.Banner_Code).Count() > 0)
            {
                resultSet = "Banner already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class Title_Episode_Details_TC_Service : BusinessLogic<Title_Episode_Details_TC>
    {
        private readonly Title_Episode_Details_TC_Repository objRepository;

        public Title_Episode_Details_TC_Service(string Connection_Str)
        {
            this.objRepository = new Title_Episode_Details_TC_Repository(Connection_Str);
        }
        public IQueryable<Title_Episode_Details_TC> SearchFor(Expression<Func<Title_Episode_Details_TC, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Episode_Details_TC GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Episode_Details_TC objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Episode_Details_TC objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Episode_Details_TC objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Episode_Details_TC objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Title_Episode_Details_TC objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Title_Episode_Details_TC objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Title_Episode_Details_TC objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Title_Content_Code == objToValidate.Title_Content_Code).Count() > 0)
            {
                resultSet = "Title_Episode_Details_TC already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    public class Title_Episode_Details_Service : BusinessLogic<Title_Episode_Details>
    {
        private readonly Title_Episode_Details_Repository objRepository;

        public Title_Episode_Details_Service(string Connection_Str)
        {
            this.objRepository = new Title_Episode_Details_Repository(Connection_Str);
        }
        public IQueryable<Title_Episode_Details> SearchFor(Expression<Func<Title_Episode_Details, bool>> predicate)
        {
            return objRepository.SearchFor(predicate);
        }

        public Title_Episode_Details GetById(int id)
        {
            return objRepository.GetById(id);
        }

        public bool Save(Title_Episode_Details objToSave, out dynamic resultSet)
        {
            return base.Save(objToSave, objRepository, out resultSet);
        }

        public bool Update(Title_Episode_Details objToUpdate, out dynamic resultSet)
        {
            return base.Update(objToUpdate, objRepository, out resultSet);
        }

        public bool Delete(Title_Episode_Details objToDelete, out dynamic resultSet)
        {
            return base.Delete(objToDelete, objRepository, out resultSet);
        }

        public override bool Validate(Title_Episode_Details objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateUpdate(Title_Episode_Details objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        public override bool ValidateDelete(Title_Episode_Details objToValidate, out dynamic resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }

        private bool ValidateDuplicate(Title_Episode_Details objToValidate, out dynamic resultSet)
        {
            if (SearchFor(s => s.Title_Episode_Detail_Code == objToValidate.Title_Episode_Detail_Code).Count() > 0)
            {
                resultSet = "Title_Episode_Details already exists";
                return false;
            }

            resultSet = "";
            return true;
        }

    }

    #endregion
}